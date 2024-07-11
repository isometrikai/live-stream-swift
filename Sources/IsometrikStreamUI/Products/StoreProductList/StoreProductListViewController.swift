//
//  StoreProductListViewController.swift
//  Shopr
//
//  Created by new user on 30/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import MBProgressHUD

class StoreProductListViewController: UIViewController, AppearanceProvider {

    // MARK: - PROPERTIES
    
    var productViewModel: ProductViewModel?
    
    var storeTitle: String? {
        didSet {
            headerView.headerTitle.attributedText = headerView.attributedHeaderTitle(title: "Products in".localized, subtitle: storeTitle ?? "")
        }
    }
    
    var storeId: String? {
        didSet {
            // reseting the page for pagination
            guard let productViewModel else { return }
            productViewModel.storePage = 1
            
            loadData()
        }
    }
    
    var continue_callback: (()->())?
    
    lazy var headerView: CustomHeaderView = {
        let view = CustomHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        Fonts.setFont(view.headerTitle, fontFamiy: .monstserrat(.Bold), size: .custom(18), color: .black)
        view.headerTitle.textAlignment = .center
        view.dividerView.isHidden = false
        
        view.leadingActionButton.isHidden = false
        view.leadingActionButton.setImage(appearance.images.back, for: .normal)
        view.leadingActionButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var storeProductListTableview: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ProductListTableViewCell.self, forCellReuseIdentifier: "ProductListTableViewCell")
        tableView.separatorColor = .lightGray.withAlphaComponent(0.5)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: ism_windowConstant.getBottomPadding + 70, right: 0)
        tableView.tableHeaderView = UIView()
        return tableView
    }()
    
    lazy var continueButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitle("Add Products".localized, for: .normal)
//        Fonts.setFont(button.titleLabel!, fontFamiy: .monstserrat(.SemiBold), size: .custom(14), color: .white)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        button.alpha = 0.3
        button.ismTapFeedBack()
        return button
    }()
    
    lazy var defaultView: ProductDefaultPlaceholderView = {
        let view = ProductDefaultPlaceholderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigations()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.defaultView.playAnimation(for: self.appearance.json.emptyBoxAnimation)
            self.defaultView.defaultLabel.text = "No Products in this Store".localized
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        view.addSubview(storeProductListTableview)
        view.addSubview(continueButton)
        view.addSubview(defaultView)
        view.addSubview(headerView)
    }
    
    func setupNavigations(){
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
            storeProductListTableview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            storeProductListTableview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            storeProductListTableview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            storeProductListTableview.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            
            defaultView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            defaultView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            defaultView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            defaultView.topAnchor.constraint(equalTo: view.topAnchor),
        ])
    }
    
    func loadData(){
        
        guard let productViewModel, let storeId else { return }
        
        if productViewModel.storePage == 1 {
            // Reset the array data
            productViewModel.storeProductList.removeAll()
            self.storeProductListTableview.reloadData()
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        productViewModel.fetchStoreProducts(storeId: storeId) { success, errorString in
            MBProgressHUD.hide(for: self.view, animated: true)
            if success {
                if productViewModel.storeProductList.isEmpty {
                    self.defaultView.isHidden = false
                } else {
                    self.defaultView.isHidden = true
                }
                self.storeProductListTableview.reloadData()
            } else {
                self.defaultView.isHidden = false
                //self.ism_showAlert("Error", message: "\(errorString ?? "")")
            }
        }
        
    }
    
    func updateSelectionUI(){
        
        guard let productViewModel else { return }
        
        // selected product count
        let selectedStoreProductCount = productViewModel.selectedStoreProductList.count
        if selectedStoreProductCount > 0 {
            self.continueButton.isEnabled = true
            self.continueButton.alpha = 1
        } else {
            self.continueButton.isEnabled = false
            self.continueButton.alpha = 0.5
        }
        
    }
    
    // MARK: - ACTIONS
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
        
        guard let productViewModel else { return }
        productViewModel.selectedStoreProductList.removeAll()
        
    }
    
    @objc func continueButtonTapped(){
        
        guard let productViewModel else { return }
        productViewModel.mergeOtherStoreProductAndMyStoreProduct {
            self.continue_callback?()
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }

}
