//
//  StreamModeratorsListViewController.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 14/02/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream
import SkeletonView

protocol StreamModeratorsListActionDelegate {
    func openListForSelectingModerators()
}

class StreamModeratorsListViewController: UIViewController, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    var viewModel: ModeratorViewModel
    
    let headerView: CustomHeaderView = {
        let view = CustomHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DynamicUserInfoTableViewCell.self, forCellReuseIdentifier: "DynamicUserInfoTableViewCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.isSkeletonable = true
        return tableView
    }()
    
    lazy var defaultView: StreamDefaultEmptyView = {
        let view = StreamDefaultEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.defaultImageView.image = appearance.images.noViewers
        view.defaultLabel.text = "No Moderators Found".localized
        return view
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .medium
        indicator.tintColor = .darkGray
        return indicator
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                    #selector(self.refreshAction),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = .lightGray
        return refreshControl
    }()
    
    // MARK: - INITIALIZERS
    
    init(viewModel: ModeratorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setupInitials()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        tableView.rowHeight = 70
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // removing previous loaded data
        viewModel.skip = 0
        viewModel.moderatorList.removeAll()
        
        self.tableView.showAnimatedSkeleton(usingColor: .wetAsphalt, transition: .crossDissolve(0.5))
        viewModel.getModerators { [weak self] in
            guard let self else { return }
            self.tableView.hideSkeleton()
            self.tableView.reloadData()
            self.headerView.headerTitle.text = "Moderators".localized + " (\(self.viewModel.moderatorList.count))"
        }
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        view.backgroundColor = appearance.colors.appDarkGray
        view.addSubview(headerView)
        view.addSubview(defaultView)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        self.headerView.trailingActionButton2.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            defaultView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            defaultView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            defaultView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            defaultView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupInitials(){
        
        // initializing configurations
        let headerTitle = headerView.headerTitle
        headerTitle.text = "Moderators".localized
        headerTitle.font = appearance.font.getFont(forTypo: .h3)
        headerTitle.textAlignment = .left
        
        let trailingActionButton = self.headerView.trailingActionButton2
        trailingActionButton.setTitle("+" + "Add".localized, for: .normal)
        trailingActionButton.setTitleColor(appearance.colors.appSecondary, for: .normal)
        trailingActionButton.isHidden = false
        trailingActionButton.titleLabel?.font = appearance.font.getFont(forTypo: .h6)
        trailingActionButton.backgroundColor = appearance.colors.appColor
        
    }
    
    // MARK: - ACTIONS
    
    @objc func refreshAction(){
        self.viewModel.moderatorList.removeAll()
        self.tableView.reloadData()
        
        self.viewModel.getModerators {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func addButtonTapped(){
        self.dismiss(animated: true)
        viewModel.delegate?.openListForSelectingModerators()
    }

}

extension StreamModeratorsListViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.moderatorList.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "DynamicUserInfoTableViewCell"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DynamicUserInfoTableViewCell", for: indexPath) as! DynamicUserInfoTableViewCell
        
        let isometrik = viewModel.isometrik
        
        let userData = viewModel.moderatorList[indexPath.row]
        let currentUserId = isometrik.getUserSession().getUserId()
        let currentUserType = isometrik.getUserSession().getUserType()
        
        cell.userData = userData
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.contentView.isUserInteractionEnabled = false
        
        if userData.userId == currentUserId {
            cell.actionButton.isHidden = true
        } else {
            if currentUserType == .host {
                cell.actionButton.isHidden = false
            }
        }
        
        // if current user is host show remove button
        cell.actionButton.setTitle("Remove", for: .normal)
        cell.actionButtonWidth?.constant = 100
        
        cell.actionButton_callback = { [weak self] data in
            
            guard let self else { return }
            
            // remove this user as a moderator
            self.removeModerator(userData: data)
            
            // remove this user from the list and update
            self.viewModel.moderatorList.remove(at: indexPath.row)
            self.tableView.reloadData()
            
            self.headerView.headerTitle.text = "Moderators" + " (\(self.viewModel.moderatorList.count))"
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}


extension StreamModeratorsListViewController {
    
    func removeModerator(userData: ISMStreamUser){
        
        let streamInfo = viewModel.streamInfo
        let isometrik = viewModel.isometrik
        
        let moderatorId = userData.userId.unwrap
        let streamId = streamInfo.streamId.unwrap
        let initiatorId = isometrik.getUserSession().getUserId()
        
        isometrik.getIsometrik().removeModerator(streamId: streamInfo.streamId ?? "", moderatorId: moderatorId, initiatorId: initiatorId) { moderator in
            print(moderator)
        } failure: { error in
            print(error)
        }
        
    }
    
}
