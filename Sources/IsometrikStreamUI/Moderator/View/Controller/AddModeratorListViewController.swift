//
//  AddModeratorListViewController.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 15/02/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import MBProgressHUD
import IsometrikStream

class AddModeratorListViewController: UIViewController {

    // MARK: - PROPERTIES
    
    var isometrik: IsometrikSDK?
    var streamInfo: ISMStream?
    var moderatorViewModel = ModeratorViewModel()
    
    var change_callback: (()->Void)?
    
    var users: [ISMStreamUser] = [] {
        didSet {
            userListTableView.reloadData()
        }
    }
    
    var searchedUsers: [ISMStreamUser] = [] {
        didSet {
            userListTableView.reloadData()
        }
    }
    
    var skip = 0
    var pageTokenisupdated: Bool = true
    var isDataLoading: Bool = true
    
    let headerView: AddModeratorHeader = {
        let view = AddModeratorHeader()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var searchBarView: GlobalSearchBarView = {
        let searchView = GlobalSearchBarView()
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.backgroundColor = .clear
        searchView.delegate = self
        return searchView
    }()
    
    lazy var userListTableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.showsVerticalScrollIndicator = false
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(DynamicUserInfoTableViewCell.self, forCellReuseIdentifier: "DynamicUserInfoTableViewCell")
        tableview.backgroundColor = .clear
        tableview.separatorColor = .lightGray.withAlphaComponent(0.2)
        return tableview
    }()
    
    let noUserFoundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let noUserFoundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Appearance.default.images.noViewers
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let noUserFoundLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No user found"
        label.textAlignment = .center
        label.textColor = .white
        label.font = Appearance.default.font.getFont(forTypo: .h5)
        return label
    }()

    // MARK: - INITIALIZERS
    
    init(_isometrik: IsometrikSDK?, _streamInfo: ISMStream) {
        super.init(nibName: nil, bundle: nil)
        self.isometrik = _isometrik
        self.streamInfo = _streamInfo
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUsers()
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(searchBarView)
        view.addSubview(userListTableView)
        
        view.addSubview(noUserFoundView)
        noUserFoundView.addSubview(noUserFoundImage)
        noUserFoundView.addSubview(noUserFoundLabel)
        ism_hideKeyboardWhenTappedAround()
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBarView.heightAnchor.constraint(equalToConstant: 50),
            searchBarView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            // Default view constraints
            
            noUserFoundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noUserFoundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noUserFoundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            noUserFoundView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor),
            
            noUserFoundImage.centerYAnchor.constraint(equalTo: noUserFoundView.centerYAnchor),
            noUserFoundImage.centerXAnchor.constraint(equalTo: noUserFoundView.centerXAnchor),
            noUserFoundImage.widthAnchor.constraint(equalToConstant: 70),
            noUserFoundImage.heightAnchor.constraint(equalToConstant: 70),
            
            noUserFoundLabel.topAnchor.constraint(equalTo: noUserFoundImage.bottomAnchor, constant: 8),
            noUserFoundLabel.leadingAnchor.constraint(equalTo: noUserFoundView.leadingAnchor, constant: 10),
            noUserFoundLabel.trailingAnchor.constraint(equalTo: noUserFoundView.trailingAnchor, constant: -10),
            
            //:

            userListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            userListTableView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor)
        ])
    }
    
    func fetchUsers(withSearchString: String? = nil) {
        
        guard let isometrik = isometrik else { return }
        
        moderatorViewModel.isometrik = isometrik
        
        MBProgressHUD.showAdded(to: view, animated: true)
        moderatorViewModel.getUserList(searchString: nil) { response in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch response {
                case .success:
                self.users = self.moderatorViewModel.userList
                break
                case .error(let error):
                    print(error)
            }
        }
        
    }
    
    func loadMoreItems() {
        DispatchQueue.main.async {
            if self.users.count.isMultiple(of: 10) {
                self.fetchUsers()
            }
        }
    }
    
//    func getUsers(searchString: String){
//
//        if searchString == "" {
//            self.noUserFoundView.isHidden = true
//            self.userListTableView.isHidden = false
//            self.searchedUsers = []
//            fetchUsers()
//        }
//
//        var strUrl: String = AppConstants.searchPeople + "?"
//        if searchString != ""{
//            strUrl = AppConstants.searchPeople + "?username=\(searchString)&"
//            print("people url: \(strUrl)")
//            self.searchViewModel.peopleOffset = -40
//        }else{
//            if self.searchViewModel.peopleOffset == -40{
//                Helper.showPI()
//            }
//        }
//
//        print("API \(strUrl)")
//        print("*********Search people")
//
//        searchViewModel.getSearchData(with: strUrl, type: .people) { (success, error, canServiceCall) in
//            if success {
//                self.noUserFoundView.isHidden = true
//                self.userListTableView.isHidden = false
//                self.setSearchedUserData()
//            }
//
//            if let error = error{
//                print(error.localizedDescription)
//                if error.code != 204{
//                    Helper.showAlertViewOnWindow(Strings.error.localized, message: (error.localizedDescription))
//                }else if error.code == 204{
//                    self.noUserFoundLabel.text = "No user found with \"\(searchString)\" "
//                    self.noUserFoundView.isHidden = false
//                    self.userListTableView.isHidden = true
//                }
//                self.searchViewModel.peopleOffset = self.searchViewModel.peopleOffset - 40
//            }
////            self.canPeopleServiceCall = canServiceCall
//        }
//    }

//    func setSearchedUserData(){
//        let peopleArray = searchViewModel.peopleArray
//
//        var usersArray: [ISMUser] = []
//
//        let searchGroup = DispatchGroup()
//        searchGroup.enter()
//
//        for i in 0..<peopleArray.count {
//
//            let people = peopleArray[i]
//            let user = ISMUser(userID: people.streamUserId ?? "", userId: people.streamUserId ?? "", identifier: people.streamUserId ?? "", name: "\(people.firstName) \(people.lastName)", imagePath: people.profilePic ?? "")
//
//            usersArray.append(user)
//
//            if i == peopleArray.count - 1 {
//                searchGroup.leave()
//            }
//        }
//
//        searchGroup.notify(queue: .main) {
//            self.searchedUsers = usersArray
//        }
//
//    }
    
    func handleAddAction(userData: ISMStreamUser, indexPath: IndexPath){
        
        // show alert before adding
        let alert = UIAlertController(
            title: "Are you sure want to add".localized + "\"\(userData.name.unwrap)\" " + "as a moderator".localized + "?",
            message: "",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: .default,
                                      handler: { _ in
            
            // add that user as a moderator
            self.addModerator(userData: userData)
            
            let isSearchingUser = self.moderatorViewModel.isSearchingUser ?? false
            
            // remove that user from the list and update
            if isSearchingUser {
                self.searchedUsers.remove(at: indexPath.row)
            } else {
                self.users.remove(at: indexPath.row)
            }
            
            self.userListTableView.reloadData()
            self.dismiss(animated: true)
            self.change_callback?()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .destructive))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func addModerator(userData: ISMStreamUser){
        
        
        guard let streamInfo = streamInfo,
              let isometrik = isometrik else { return }
        
        let moderatorId = userData.userId ?? ""
        let initiatorId = streamInfo.createdBy ?? ""
        
        isometrik.getIsometrik().addModerator(streamId: streamInfo.streamId ?? "", moderatorId: moderatorId, initiatorId: initiatorId) { result in
            print(result)
        } failure: { error in
            print(error)
        }
        
    }

}

extension AddModeratorListViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if moderatorViewModel.isSearchingUser {
            return searchedUsers.count
        } else {
            return users.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DynamicUserInfoTableViewCell") as! DynamicUserInfoTableViewCell
        
        if moderatorViewModel.isSearchingUser {
            cell.userData = searchedUsers[indexPath.row]
        } else {
            cell.userData = users[indexPath.row]
        }
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.contentView.isUserInteractionEnabled = false
        
        cell.actionButton_callback = { [weak self] userdata in
            
            guard let self else { return }
            self.handleAddAction(userData: userdata, indexPath: indexPath)
            
        }
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
        self.view.endEditing(true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !(moderatorViewModel.isSearchingUser) {
            if ((userListTableView.contentOffset.y + userListTableView.frame.size.height) >= userListTableView.contentSize.height)
            {
                if !isDataLoading{
                    isDataLoading = true
                    loadMoreItems()
                }
            }
        }
    }
}

extension AddModeratorListViewController: GlobalSearchBarActionDelegate {
    
    func didSearchTextFieldDidChange(withText: String) {
        
        moderatorViewModel.searchTimer?.invalidate()
        moderatorViewModel.isSearchingUser = withText == "" ? false : true
        
        if withText == "" {
            searchBarView.stopAnimating()
            noUserFoundView.isHidden = true
            userListTableView.isHidden = false
            searchedUsers = []
            users = []
            moderatorViewModel.skip = 0
            moderatorViewModel.userList = []
            
            fetchUsers()
            return
        }
        
        self.searchedUsers = []
        self.moderatorViewModel.skip = 0
        self.userListTableView.reloadData()
        
        searchBarView.startAnimating()
        
        moderatorViewModel.searchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] (timer) in
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                
                guard let self else { return }
                
                //Use search text and perform the query
                self.moderatorViewModel.getUserList(searchString: withText.lowercased()) { result in
                 
                    DispatchQueue.main.async {
                        self.searchBarView.stopAnimating()
                    }
                    
                    switch result {
                    case .success:
                        if self.moderatorViewModel.searchedUserList.isEmpty {
                            self.noUserFoundLabel.text = "No user found with".localized + " \"\(withText)\" "
                            self.noUserFoundView.isHidden = false
                            self.userListTableView.isHidden = true
                            return
                        }
                        self.noUserFoundView.isHidden = true
                        self.userListTableView.isHidden = false
                        DispatchQueue.main.async {
                            self.searchedUsers = self.moderatorViewModel.searchedUserList
                        }
                        
                        break
                    case .error(_):
                        self.noUserFoundLabel.text = "No user found with".localized + " \"\(withText)\" "
                        self.noUserFoundView.isHidden = false
                        self.userListTableView.isHidden = true
                    }
                }
            }
        })
        
    }
    
}



