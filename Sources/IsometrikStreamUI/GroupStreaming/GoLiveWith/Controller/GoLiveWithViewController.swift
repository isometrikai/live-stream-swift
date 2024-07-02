//
//  GoLiveWithViewController.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 19/06/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream
import MBProgressHUD

class GoLiveWithViewController: UIViewController, AppearanceProvider {

    // MARK: - PROPERTIES
    
    let viewModel = GoLiveWithViewModel()
    
    lazy var headerView: GoLiveWithHeaderView = {
        let view = GoLiveWithHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.userActionView.actionButton.addTarget(self, action: #selector(userTapped), for: .touchUpInside)
        view.viewerActionView.actionButton.addTarget(self, action: #selector(viewerTapped), for: .touchUpInside)
        view.searchBarView.searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return view
    }()
    
    lazy var contentTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.showsVerticalScrollIndicator = true
        tableView.register(StreamViewerTableViewCell.self, forCellReuseIdentifier: "StreamViewerTableViewCell")
        tableView.register(StreamMemberTableViewCell.self, forCellReuseIdentifier: "StreamMemberTableViewCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        return tableView
    }()
    
    lazy var defaultView: StreamDefaultEmptyView = {
        let view = StreamDefaultEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.defaultImageView.image = appearance.images.noViewers
        return view
    }()
    
    // MARK: - INITIALIZER
    
    init(isometrik: IsometrikSDK, streamData: ISMStream) {
        self.viewModel.isometrik = isometrik
        self.viewModel.streamData = streamData
        super.init(nibName: nil, bundle: nil)
        self.viewModel.resetData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        addObservers()
        
        // load user data first
        userTapped()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeObservers()
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        view.backgroundColor = appearance.colors.appDarkGray
        view.addSubview(headerView)
        view.addSubview(contentTableView)
        
        view.addSubview(defaultView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 200),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            contentTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            defaultView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            defaultView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            defaultView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            defaultView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            
        ])
    }
    
    func loadViewers(isRefresh: Bool = false){
        
        // hide default empty view when loading data
        self.defaultView.isHidden = true
        
        if isRefresh {
            viewModel.viewerPageToken = ""
            viewModel.viewers = []
            contentTableView.reloadData()
        }
        
        viewModel.getViewers { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.defaultView.isHidden = !self.viewModel.viewers.isEmpty
                    self.defaultView.defaultLabel.text = "No viewers found"
                    self.contentTableView.reloadData()
                case  .failure(_):
                    self.defaultView.isHidden = !self.viewModel.viewers.isEmpty
                    self.defaultView.defaultLabel.text = "No viewers found"
                }
            }
        }
    }
    
    // MARK: - ACTIONS
    
    @objc func userTapped(){
        viewModel.selectedOption = .user
        headerView.animateTrackIndicator(for: .user)
        
        headerView.searchBarView.searchTextField.text = ""
        headerView.searchBarView.searchTextField.placeholder = "Search Users"
        
        //getFollowers(isRefresh: true)
    }
    
    @objc func viewerTapped(){
        viewModel.selectedOption = .viewer
        headerView.animateTrackIndicator(for: .viewer)
        
        headerView.searchBarView.searchTextField.text = ""
        headerView.searchBarView.searchTextField.placeholder = "Search Viewers"
        
        loadViewers(isRefresh: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        
        let selectedOption = viewModel.selectedOption
        switch selectedOption {
        case .user:
            
            if textField.text != "" {
                self.viewModel.isSearching = true
            } else {
                self.viewModel.isSearching = true
            }
            
            //getUsers(searchString: textField.text ?? "")
            
        case .viewer:
            
            if textField.text != "" {
                self.viewModel.isSearching = true
            } else {
                self.viewModel.isSearching = true
            }
            
        case .none:
            // do nothing
            break
        }
        
    }

}

