//
//  AllProductsViewController.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 23/10/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import MBProgressHUD
import IsometrikStream

enum RouteType {
    case present
    case push
}

class AllProductsViewController: UIViewController, AppearanceProvider {
    
    // MARK: - PROPERTIES
    
    var isFromLive: Bool = false
    
    var routeType:RouteType? = .present {
        didSet {
            manageUI()
        }
    }
    
    var productViewModel: ProductViewModel? {
        didSet {
            manageData()
            manageUI()
        }
    }
    
    var selectedProductHeaderHeightConstraint: NSLayoutConstraint?
    var product_Callback: ((_ selectedProducts: [StreamProductModel]?, _ allProducts: [StreamProductModel])->Void)?
    
    lazy var headerView: CustomHeaderView = {
        let view = CustomHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.headerTitle.text = "Add Products".localized
        view.headerTitle.textColor = .black
        view.headerTitle.font = appearance.font.getFont(forTypo: .h3)
        view.headerTitle.textAlignment = .center
        view.dividerView.isHidden = true
        return view
    }()
    
    lazy var toggleActionView: ProductToggleView = {
        let view = ProductToggleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.myStoreButton.addTarget(self, action: #selector(myStoreButtonTapped), for: .touchUpInside)
        view.otherStoreButton.addTarget(self, action: #selector(otherStoreButtonTapped), for: .touchUpInside)
        return view
    }()
    
    lazy var selectedProductHeaderView: SelectedProductCustomHeaderView = {
        let view = SelectedProductCustomHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.delegate = self
        return view
    }()
    
    lazy var productTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ProductListTableViewCell.self, forCellReuseIdentifier: "ProductListTableViewCell")
        tableView.register(StoreListTableViewCell.self, forCellReuseIdentifier: "StoreListTableViewCell")
        tableView.separatorColor = .lightGray.withAlphaComponent(0.4)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: ism_windowConstant.getBottomPadding + 70, right: 0)
        tableView.tableHeaderView = UIView()
        return tableView
    }()
    
    lazy var defaultView: ProductDefaultPlaceholderView = {
        let view = ProductDefaultPlaceholderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.backgroundColor = .white
        return view
    }()
    
    let bottomCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var continueButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitle("Continue".localized, for: .normal)
//        Fonts.setFont(button.titleLabel!, fontFamiy: .monstserrat(.SemiBold), size: .custom(14), color: .white)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        button.alpha = 0.3
        button.ismTapFeedBack()
        return button
    }()
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        defaultView.isHidden = true
        productTableView.isHidden = true
        
        self.toggleActionView.updateUI(activeButton: .myStore)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.defaultView.playAnimation(for: self.appearance.json.emptyBoxAnimation)
            self.defaultView.defaultLabel.text = "There are no products available to tag".localized
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(productTableView)
        view.addSubview(defaultView)
        
        view.addSubview(headerView)
        view.addSubview(toggleActionView)
        view.addSubview(bottomCoverView)
        view.addSubview(continueButton)
        view.addSubview(selectedProductHeaderView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            toggleActionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toggleActionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toggleActionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            toggleActionView.heightAnchor.constraint(equalToConstant: 60),
            
            defaultView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            defaultView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            defaultView.topAnchor.constraint(equalTo: view.topAnchor),
            defaultView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            productTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            productTableView.topAnchor.constraint(equalTo: toggleActionView.bottomAnchor),
            
            selectedProductHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            selectedProductHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            selectedProductHeaderView.bottomAnchor.constraint(equalTo: continueButton.topAnchor),
            
            bottomCoverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomCoverView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomCoverView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomCoverView.heightAnchor.constraint(equalToConstant: ism_windowConstant.getBottomPadding + 50),
            
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        selectedProductHeaderHeightConstraint = selectedProductHeaderView.heightAnchor.constraint(equalToConstant: 0) // 140
        selectedProductHeaderHeightConstraint?.isActive = true
    }
    
    func updateSelectedProductView(){
        
        guard let productViewModel else { return }
        
        let estimatedBottomOffset = 120 + ism_windowConstant.getBottomPadding + 60
        
        // selected product count
        let selectedProductCount = productViewModel.selectedProductList.count
        if selectedProductCount > 0 {
            selectedProductHeaderView.isHidden = false
            selectedProductHeaderHeightConstraint?.constant = 140
            productTableView.contentInset.bottom = estimatedBottomOffset
            
            self.continueButton.isEnabled = true
            self.continueButton.alpha = 1
        } else {
            selectedProductHeaderView.isHidden = true
            selectedProductHeaderHeightConstraint?.constant = 0
            productTableView.contentInset.bottom = 0
            
            self.continueButton.isEnabled = false
            self.continueButton.alpha = 0.3
        }
        
        // update header data collection
        selectedProductHeaderView.productData = productViewModel.selectedProductList
        
    }
    
    func manageData(){
        
        guard let productViewModel else { return }
        
        productViewModel.productList.removeAll()
        self.productTableView.reloadData()
        
        self.defaultView.isHidden = true
        
        if productViewModel.productList.isEmpty || productViewModel.selectedProductList.isEmpty {
            
            MBProgressHUD.showAdded(to: self.view, animated: true)

            productViewModel.fetchProducts { success, error in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if success {
                    let _ = self.productViewModel!.totalProducts
                    
                    self.productTableView.isHidden = false
                    self.defaultView.isHidden = true
                    
                    // if Selected list is not empty replace the product in all list
                    if !productViewModel.selectedProductList.isEmpty {
                        productViewModel.updateAllProductListFromSelectedProduct {
                            self.productTableView.isHidden = false
                            self.defaultView.isHidden = true
                            self.updateSelectedProductView()
                            self.productTableView.reloadData()
                        }
                    }
                    
                    self.productTableView.reloadData()
            
                } else {
                    self.defaultView.isHidden = false
                    print(error ?? "")
                }
            }
            
        } else {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                
                guard let self else { return }
                
                MBProgressHUD.hide(for: self.view, animated: true)
                self.productTableView.isHidden = false
                self.defaultView.isHidden = true
                self.updateSelectedProductView()
                self.productTableView.reloadData()
                
            }
        }
        
    }
    
    func manageOtherStoreData(){
        
        guard let productViewModel else { return }
        
        productViewModel.storesList.removeAll()
        self.productTableView.reloadData()
        
        self.defaultView.isHidden = true
    
        MBProgressHUD.showAdded(to: self.view, animated: true)
    
        productViewModel.fetchAllStores() { success, error in
            MBProgressHUD.hide(for: self.view, animated: true)
            if success {
                if productViewModel.storesList.isEmpty {
                    self.defaultView.isHidden = false
                    self.productTableView.isHidden = true
                } else {
                    self.defaultView.isHidden = true
                    self.productTableView.isHidden = false
                }
                self.productTableView.reloadData()
            } else {
                self.defaultView.isHidden = false
                self.productTableView.isHidden = true
            }
        }
        
    }
    
    func manageUI(){
        
        guard let routeType else { return }
        
        switch routeType {
        case .present:
            
            headerView.trailingActionButton.isHidden = false
            headerView.trailingActionButton.setImage(appearance.images.close.withRenderingMode(.alwaysTemplate), for: .normal)
            headerView.trailingActionButton.imageView?.tintColor = .black
            headerView.trailingActionButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            
            break
        case .push:
            
            headerView.leadingActionButton.isHidden = false
            headerView.leadingActionButton.setImage(appearance.images.back, for: .normal)
            headerView.leadingActionButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            
            break
        }
        
    }
    
    func navigateBack(){
        guard let productViewModel, let routeType else { return }
        
        switch routeType {
        case .present:
            
            if !isFromLive {
                let selectedProducts = productViewModel.selectedProductList
                let allProducts = productViewModel.productList
                
                if !(selectedProducts.count > 0)  { return }
                
                product_Callback?(selectedProducts, allProducts)
            }
            
            self.dismiss(animated: true)
        case .push:
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - ACTION TAPPED
    
    @objc func backButtonTapped(){
        guard let routeType else { return }
        switch routeType {
        case .present:
            self.dismiss(animated: true)
        case .push:
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @objc func continueButtonTapped(){
        
        guard let productViewModel else { return }
        
        if isFromLive {
            
            let group = DispatchGroup()
            group.enter()
            MBProgressHUD.showAdded(to: view, animated: true)
            // create offers for change in products
            productViewModel.createOfferAndTagProductToLiveStream { success, error in
                if success {
                    group.leave()
                } else {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.ism_showAlert("Error", message: "\(error ?? "")")
                }
            }
            
            group.notify(queue: .main){
                productViewModel.removeTaggedProducts { success, error in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if success {
                        self.backButtonTapped()
                    } else {
                        self.ism_showAlert("Error", message: "\(error ?? "")")
                    }
                }
            }
        
        } else {
            self.navigateBack()
        }
        
    }
    
    @objc func myStoreButtonTapped(){
        
        toggleActionView.updateUI(activeButton: .myStore)
        
        guard let productViewModel else { return }
        productViewModel.myStore = true
        manageData()
    }
    
    @objc func otherStoreButtonTapped(){
        toggleActionView.updateUI(activeButton: .otherStore)
        
        guard let productViewModel else { return }
        productViewModel.myStore = false
        manageOtherStoreData()
    }

}
