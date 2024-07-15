//
//  StreamTagProductViewController.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 21/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

class StreamTagProductViewController: UIViewController, ISMStreamUIAppearanceProvider {
    
    // MARK: - PROPERTIES
    var bottomConstraint: NSLayoutConstraint?
    var productViewModel: ProductViewModel
    
    lazy var headerView: CustomHeaderView = {
        let view = CustomHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.headerTitle.text = "Tag Products".localized
        view.headerTitle.font = appearance.font.getFont(forTypo: .h3)
        view.headerTitle.textColor = .black
        view.headerTitle.textAlignment = .center
        
        view.leadingActionButton.isHidden = false
        view.leadingActionButton.setImage(appearance.images.close.withRenderingMode(.alwaysTemplate), for: .normal)
        view.leadingActionButton.imageView?.tintColor = .black
        view.leadingActionButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        view.trailingActionButton2.isHidden = false
        view.trailingActionButton2.setTitle("+" + "Add".localized, for: .normal)
        view.trailingActionButton2.titleLabel?.font = appearance.font.getFont(forTypo: .h4)
        view.trailingActionButton2.setTitleColor(appearance.colors.appSecondary, for: .normal)
        view.trailingActionButton2.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        return view
    }()
    
    lazy var searchBarView: CustomSearchTextBarView = {
        let view = CustomSearchTextBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return view
    }()
    
    lazy var tagProductTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(StreamTagProductTableViewCell.self, forCellReuseIdentifier: "StreamTagProductTableViewCell")
        tableView.separatorColor = .lightGray.withAlphaComponent(0.5)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    lazy var defaultView: ProductDefaultPlaceholderView = {
        let view = ProductDefaultPlaceholderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: - MAIN
    
    init(productViewModel: ProductViewModel) {
        self.productViewModel = productViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        observers()
        //loadData()
        
        // Load the default initials
        self.defaultView.isHidden = true
        DispatchQueue.main.async {
            self.defaultView.playAnimation(for: self.appearance.json.emptyBoxAnimation)
            self.defaultView.defaultLabel.text = "No tagged product found".localized
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // pass data back for any updates on dismissal
        self.productViewModel.pinnedProduct_Callback?(self.productViewModel)
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(tagProductTableView)
        view.addSubview(headerView)
        view.addSubview(searchBarView)
        view.addSubview(defaultView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 55),
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            
            tagProductTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tagProductTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tagProductTableView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor),
            tagProductTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            defaultView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            defaultView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            defaultView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor),
            defaultView.bottomAnchor.constraint(equalTo: tagProductTableView.bottomAnchor),
            
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBarView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            searchBarView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        bottomConstraint = NSLayoutConstraint(item: tagProductTableView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification) , name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification) , name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    func loadData(isRefreshed: Bool = false, query: String = ""){
        
        productViewModel.skip = 0
        productViewModel.taggedProductList.removeAll()
        self.tagProductTableView.reloadData()
        
        if !isRefreshed {
            DispatchQueue.main.async {
                CustomLoader.shared.startLoading()
            }
        } else {
            self.defaultView.isHidden = true
        }
        
        // hide the navigation forward if searching, otherwise not
        headerView.trailingActionButton2.isHidden = (query != "") ? true : false
        
        productViewModel.fetchTaggedProducts(query: query) { success, error in
            CustomLoader.shared.stopLoading()
            if success {
                
                if self.productViewModel.taggedProductList.count == 0 {
                    self.defaultView.isHidden = false
                } else {
                    self.defaultView.isHidden = true
                }
                
                self.tagProductTableView.reloadData()
            } else {
                print(error ?? "")
                self.defaultView.isHidden = false
            }
        }
    }
    
    // MARK: - ACTIONS
    
    @objc func backButtonTapped(){
        self.dismiss(animated: true)
    }
    
    @objc func addButtonTapped(){
        let controller = AllProductsViewController()
        
        controller.routeType = .push
        controller.headerView.headerTitle.text = "Add Products".localized
        
        productViewModel.isOfferEditable = true
        controller.isFromLive = true
        controller.productViewModel = productViewModel
        controller.product_Callback = { [weak self] (selectedProducts, allProducts) in
            guard let self else { return }
            self.loadData()
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        let text = textField.text ?? ""
        self.loadData(query: text)
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardHeight : 0
            
            UIView.animate(withDuration: 0.2, delay: 0 , options: .curveEaseOut , animations: {
                self.view.layoutIfNeeded()
            } , completion: {(completed) in
            })
        }
    }

}
