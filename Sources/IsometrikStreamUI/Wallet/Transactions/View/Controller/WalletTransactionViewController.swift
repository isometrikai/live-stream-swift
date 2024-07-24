//
//  WalletTransactionViewController.swift
//  
//
//  Created by Appscrip 3Embed on 12/07/24.
//

import UIKit
import IsometrikStream

class WalletTransactionViewController: UIViewController, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    let viewModel: WalletTransactionViewModel
    
    lazy var headerView: CustomHeaderView = {
        let view = CustomHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.headerTitle.text = "Transactions"
        view.headerTitle.textColor = .black
        view.headerTitle.textAlignment = .center
        
        view.leadingActionButton.isHidden = false
        view.leadingActionButton.setImage(appearance.images.back.withRenderingMode(.alwaysTemplate), for: .normal)
        view.leadingActionButton.imageView?.tintColor = .black
        view.leadingActionButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        view.dividerView.isHidden = true
        return view
    }()
    
    lazy var optionsHeaderView: TransactionTypeOptionsHeaderView = {
        let view = TransactionTypeOptionsHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.allTransaction.addTarget(self, action: #selector(transactionOptionTapped(_:)), for: .touchUpInside)
        view.creditTransaction.addTarget(self, action: #selector(transactionOptionTapped(_:)), for: .touchUpInside)
        view.debitTransaction.addTarget(self, action: #selector(transactionOptionTapped(_:)), for: .touchUpInside)
        return view
    }()
    
    lazy var transactionTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .lightGray.withAlphaComponent(0.2)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    // MARK: MAIN -
    
    init(viewModel: WalletTransactionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpViews()
        setUpConstraints()
        loadData(showLoader: true)
        optionsHeaderView.respondToActionUpdate(for: viewModel.selectedTransactionType)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        view.addSubview(headerView)
        view.addSubview(optionsHeaderView)
        view.addSubview(transactionTableView)
        
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        
        transactionTableView.register(WalletTransactionTableViewCell.self, forCellReuseIdentifier: "WalletTransactionTableViewCell")
        
        viewModel.refreshControl.tintColor = appearance.colors.appSecondary
        transactionTableView.refreshControl = viewModel.refreshControl
        viewModel.refreshControl.addTarget(self, action: #selector(refreshControl), for: .valueChanged)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            optionsHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            optionsHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            optionsHeaderView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            optionsHeaderView.heightAnchor.constraint(equalToConstant: 50),
            
            transactionTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            transactionTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            transactionTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            transactionTableView.topAnchor.constraint(equalTo: optionsHeaderView.bottomAnchor)
        ])
    }

    func loadData(isRefreshing: Bool = false, showLoader: Bool = false){
        
        if showLoader {
            CustomLoader.shared.startLoading()
        }
        
        if isRefreshing {
            viewModel.skip = 0
            viewModel.transactions.removeAll()
            self.transactionTableView.reloadData()
        }
        
        viewModel.getTransactions { success, error in
            CustomLoader.shared.stopLoading()
            self.viewModel.refreshControl.endRefreshing()
            if success {
                self.transactionTableView.reloadData()
            }
        }
    }
    
    // MARK: - ACTIONS
    
    @objc func refreshControl(){
        loadData(isRefreshing: true)
    }
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func transactionOptionTapped(_ sender: UIButton) {
        let transactionType = TransactionType(rawValue: sender.tag)
        viewModel.selectedTransactionType = transactionType ?? .all
        optionsHeaderView.respondToActionUpdate(for: transactionType ?? .all)
        loadData(isRefreshing: true, showLoader: true)
    }

}
