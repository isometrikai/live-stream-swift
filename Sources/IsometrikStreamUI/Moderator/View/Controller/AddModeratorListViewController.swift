//
//  AddModeratorListViewController.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 15/02/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

class AddModeratorListViewController: UIViewController, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    var viewModel: ModeratorViewModel
    
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
    
    lazy var noUserFoundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = appearance.images.noViewers
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var noUserFoundLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No user found"
        label.textAlignment = .center
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h5)
        return label
    }()

    // MARK: - INITIALIZERS
    
    init(viewModel: ModeratorViewModel) {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUsers()
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        view.backgroundColor = appearance.colors.appDarkGray
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
        DispatchQueue.main.async {
            CustomLoader.shared.startLoading()
        }
        viewModel.getUserList(searchString: withSearchString) { response in
            CustomLoader.shared.stopLoading()
            self.searchBarView.stopAnimating()
            switch response {
                case .success:
                
                if withSearchString != nil, self.viewModel.searchedUserList.isEmpty {
                    self.noUserFoundLabel.text = "No user found with" + withSearchString.unwrap
                    self.noUserFoundView.isHidden = false
                    self.userListTableView.isHidden = true
                    return
                } else {
                    self.noUserFoundView.isHidden = true
                    self.userListTableView.isHidden = false
                }
                
                DispatchQueue.main.async {
                    self.userListTableView.reloadData()
                }
                
                break
                case .error(_):
                if withSearchString != nil, self.viewModel.searchedUserList.isEmpty {
                    self.noUserFoundLabel.text = "No user found with" + withSearchString.unwrap
                    self.noUserFoundView.isHidden = false
                    self.userListTableView.isHidden = true
                } else {
                    self.noUserFoundView.isHidden = true
                    self.userListTableView.isHidden = false
                }
            }
        }
        
    }
    
    func loadMoreItems() {
        DispatchQueue.main.async {
            if self.viewModel.userList.count.isMultiple(of: self.viewModel.limit) {
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
            title: "Are you sure want to add" + "\"\(userData.name.unwrap)\" " + "as a moderator" + "?",
            message: "",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: .default,
                                      handler: { _ in
            
            // add that user as a moderator
            self.viewModel.addModerator(userId: userData.userId.unwrap)
            
            let isSearchingUser = self.viewModel.isSearchingUser
            
            // remove that user from the list and update
            if isSearchingUser {
                if self.viewModel.searchedUserList.count > indexPath.row {
                    self.viewModel.searchedUserList.remove(at: indexPath.row)
                }
            } else {
                if self.viewModel.userList.count > indexPath.row {
                    self.viewModel.userList.remove(at: indexPath.row)
                }
            }
            
            self.userListTableView.reloadData()
            self.dismiss(animated: true)
            self.viewModel.change_callback?()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .destructive))
        self.present(alert, animated: true, completion: nil)
        
    }

}

extension AddModeratorListViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isSearchingUser {
            return viewModel.searchedUserList.count
        } else {
            return viewModel.userList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DynamicUserInfoTableViewCell") as! DynamicUserInfoTableViewCell
        
        if viewModel.isSearchingUser {
            cell.userData = viewModel.searchedUserList[indexPath.row]
        } else {
            cell.userData = viewModel.userList[indexPath.row]
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
        viewModel.isDataLoading = false
        self.view.endEditing(true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !(viewModel.isSearchingUser) {
            if ((userListTableView.contentOffset.y + userListTableView.frame.size.height) >= userListTableView.contentSize.height)
            {
                if !viewModel.isDataLoading{
                    viewModel.isDataLoading = true
                    loadMoreItems()
                }
            }
        }
    }
}

extension AddModeratorListViewController: GlobalSearchBarActionDelegate {
    
    func didSearchTextFieldDidChange(withText: String) {
        
        viewModel.isSearchingUser = withText == "" ? false : true
        
        if withText == "" {
            searchBarView.stopAnimating()
            noUserFoundView.isHidden = true
            userListTableView.isHidden = false
            viewModel.searchedUserList = []
            viewModel.userList = []
            viewModel.skip = 0
            
            fetchUsers()
            return
        }
        
        viewModel.searchedUserList = []
        viewModel.skip = 0
        self.userListTableView.reloadData()
        
        searchBarView.startAnimating()
        
        viewModel.debouncer.debounce {
            self.fetchUsers(withSearchString: withText.lowercased())
        }
        
    }
    
}



