//
//  StreamTaggedProductList.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 24/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

class StreamTaggedProductList: UIViewController, ISMStreamUIAppearanceProvider {

    // MARK: - PROPERTIES
    
    var productViewModel: ProductViewModel? {
        didSet {
            loadData()
        }
    }
    
    lazy var headerView: CustomHeaderView = {
        let view = CustomHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.headerTitle.text = "All Products"
        view.headerTitle.textAlignment = .center
        
        view.trailingActionButton.isHidden = false
        view.trailingActionButton.setImage(appearance.images.close.withRenderingMode(.alwaysTemplate), for: .normal)
        view.trailingActionButton.imageView?.tintColor = .black
        view.trailingActionButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return view
    }()
    
    lazy var taggedProductTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(TaggedProductListTableViewCell.self, forCellReuseIdentifier: "TaggedProductListTableViewCell")
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        return tableView
    }()
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(taggedProductTableView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            taggedProductTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taggedProductTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            taggedProductTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            taggedProductTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
    }
    
    func loadData(){
        guard let productViewModel else { return }
        DispatchQueue.main.async {
            CustomLoader.shared.startLoading()
        }
        
        productViewModel.fetchTaggedProducts { success, error in
            CustomLoader.shared.stopLoading()
            if success {
                //self.defaultView.isHidden = false
                self.headerView.headerTitle.text = "All Products"
                self.taggedProductTableView.reloadData()
            } else {
                //self.defaultView.isHidden = true
                print(error ?? "")
            }
        }
        
    }
    
    // MARK: - ACTIONS
    
    @objc func backButtonTapped(){
        self.dismiss(animated: true)
    }

}
