//
//  StreamUserProfileViewController.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 08/02/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit
import Kingfisher
import IsometrikStream

enum UserProfileActionType {
    case kickout
    case makeModerator
    case report
    case block
}

struct StreamUserProfileOptions {
    let optionLabel: String
    let optionImage: String
    var optionColor: UIColor = .black
    var actionType: UserProfileActionType
}

protocol StreamUserProfileDelegate {
    func didUserProfileOptionTapped(actionType: UserProfileActionType, messageData: ISMComment?)
}

class StreamUserProfileViewController: UIViewController, ISMStreamUIAppearanceProvider {

    // MARK: - PROPERTIES
    
    var delegate: StreamUserProfileDelegate?
    var messageData: ISMComment?
    var streamUserProfileOptions: [StreamUserProfileOptions] = []
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.close, for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var optionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(StreamUserProfileOptionTableViewCell.self, forCellReuseIdentifier: "StreamUserProfileOptionTableViewCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - Header View
    
    let headerCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 35
        return view
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        return imageView
    }()
    
    lazy var defaultProfileView: CustomDefaultProfileView = {
        let defaultView = CustomDefaultProfileView()
        defaultView.layer.cornerRadius = 35
        defaultView.initialsText.font = appearance.font.getFont(forTypo: .h4)
        return defaultView
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = appearance.font.getFont(forTypo: .h4)
        label.textColor = .black
        return label
    }()
    
    //:
    
    // MARK: MAIN -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        manageData()
        self.optionsTableView.reloadData()
    }
    
    init(messageData: ISMComment? = nil, streamUserProfileOptions: [StreamUserProfileOptions]) {
        super.init(nibName: nil, bundle: nil)
        self.streamUserProfileOptions = streamUserProfileOptions
        self.messageData = messageData
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        view.backgroundColor = .white
        view.addSubview(headerCoverView)
        headerCoverView.addSubview(profileCoverView)
        headerCoverView.addSubview(defaultProfileView)
        headerCoverView.addSubview(profileImage)
        headerCoverView.addSubview(userNameLabel)
        
        view.addSubview(optionsTableView)
        view.addSubview(closeButton)
    }
    
    func setUpConstraints(){
        
        profileImage.ism_pin(to: profileCoverView)
        defaultProfileView.ism_pin(to: profileCoverView)
        NSLayoutConstraint.activate([
            
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            closeButton.widthAnchor.constraint(equalToConstant: 35),
            closeButton.heightAnchor.constraint(equalToConstant: 35),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            
            headerCoverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerCoverView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerCoverView.topAnchor.constraint(equalTo: view.topAnchor),
            headerCoverView.heightAnchor.constraint(equalToConstant: 100),
            
            profileCoverView.centerYAnchor.constraint(equalTo: headerCoverView.centerYAnchor),
            profileCoverView.leadingAnchor.constraint(equalTo: headerCoverView.leadingAnchor, constant: 20),
            profileCoverView.widthAnchor.constraint(equalToConstant: 70),
            profileCoverView.heightAnchor.constraint(equalToConstant: 70),
            
            userNameLabel.leadingAnchor.constraint(equalTo: profileCoverView.trailingAnchor, constant: 15),
            userNameLabel.centerYAnchor.constraint(equalTo: profileCoverView.centerYAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: headerCoverView.trailingAnchor, constant: -15),
            
            optionsTableView.topAnchor.constraint(equalTo: headerCoverView.bottomAnchor),
            optionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            optionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            optionsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    func manageData(){
        
        guard let messageData else { return }
        
        let senderImage = messageData.senderImage ?? ""
        let senderName = messageData.senderName ?? ""
        
        let userProfile = messageData.metaData?.userProfile ?? senderImage
        let userName = messageData.metaData?.userName ?? senderName
        
        if userProfile != UserDefaultsProvider.shared.getIsometrikDefaultProfile() {
            if let userProfileUrl = URL(string: userProfile) {
                profileImage.kf.setImage(with: userProfileUrl)
            } else {
                profileImage.image = UIImage()
            }
        } else {
            profileImage.image = UIImage()
        }
        
        userNameLabel.text = userName
        let nameInitials = "\(userName.prefix(2))".uppercased()
        defaultProfileView.initialsText.text = nameInitials
        
    }
    
    // MARK: - ACTIONS
    
    @objc func closeButtonTapped(){
        self.dismiss(animated: true)
    }


}
