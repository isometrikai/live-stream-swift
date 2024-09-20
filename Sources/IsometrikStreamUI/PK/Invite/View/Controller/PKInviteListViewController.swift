//
//  PKInviteListViewController.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 24/11/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import UIKit

class PKInviteListViewController: UIViewController, ISMAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    var viewModel: PKInviteUserViewModel
    
    lazy var headerView: PkWithFriendsHeaderView = {
        let view = PkWithFriendsHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return view
    }()
    
    lazy var searchView: PkWithFriendsSearchView = {
        let view = PkWithFriendsSearchView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return view
    }()
    
    lazy var userTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(PKUserTableViewCell.self, forCellReuseIdentifier: "PKUserTableViewCell")
        tableView.separatorColor = .white.withAlphaComponent(0.3)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    let defaultView: PKInviteDefaultView = {
        let view = PKInviteDefaultView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let bottomRefuseAllInvitationView: PKRefuseInvitationView = {
        let view = PKRefuseInvitationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    // MARK: - INITIALIZER
    
    init(viewModel: PKInviteUserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        loadData()
    }
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        view.backgroundColor = appearance.colors.appDarkGray
        view.addSubview(headerView)
        view.addSubview(searchView)
        view.addSubview(userTableView)
        view.addSubview(defaultView)
//        view.addSubview(bottomRefuseAllInvitationView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            searchView.heightAnchor.constraint(equalToConstant: 70),
            
            userTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            userTableView.topAnchor.constraint(equalTo: searchView.bottomAnchor),
            
            defaultView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            defaultView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            defaultView.topAnchor.constraint(equalTo: searchView.bottomAnchor),
            defaultView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
//            bottomRefuseAllInvitationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            bottomRefuseAllInvitationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            bottomRefuseAllInvitationView.heightAnchor.constraint(equalToConstant: 50),
//            bottomRefuseAllInvitationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func loadData(for query: String = ""){
        
        CustomLoader.shared.startLoading()
        self.viewModel.streamUserList.removeAll()
        self.userTableView.reloadData()
        
        viewModel.getData(query: query) {
            DispatchQueue.main.async {
                CustomLoader.shared.stopLoading()
                if self.viewModel.streamUserList.isEmpty {
                    self.defaultView.isHidden = false
                } else {
                    self.defaultView.isHidden = true
                }
                self.userTableView.reloadData()
            }
        }
    }
    
    // MARK: - ACTIONS
    
    @objc func closeButtonTapped(){
        self.dismiss(animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        loadData(for: textField.text ?? "")
    }

}


extension PKInviteListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.streamUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PKUserTableViewCell", for: indexPath) as! PKUserTableViewCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.selectionStyle = .none
        cell.data = viewModel.streamUserList[indexPath.row]
        cell.contentView.isUserInteractionEnabled = false
        cell.tag = indexPath.row
        cell.backgroundColor = .clear
        
        cell.actionButtonCallback = { [weak self] index in
            self?.viewModel.sendInvite(index: index, completionHandler: { (success, errorMessage) in
                DispatchQueue.main.sync {
                    if success {
                        self?.dismiss(animated: true)
                        let streamData = self?.viewModel.streamUserList[safe:index]
                        self?.viewModel.linking_CallBack?(streamData)
                    }else{
                        self?.view.showToast( message: errorMessage ?? "")
                    }
                }
            })
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
