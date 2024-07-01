//
//  StreamSellerProfileVC.swift
//  Shopr
//
//  Created by Nikunj's M1 on 07/03/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit

class StreamSellerProfileVC: UIViewController {
    
    // MARK: - PROPERTIES
    
//    var isometrik: IsometrikSDK?
//    let profileVmObject = ProfileViewModel() // Used for profileViewModel Object Reference
//    var isCloseEvent: Bool = false
//    var leave_callback: (()->Void)?
//    var followButton_callback: ((Bool)->())?
//    var navigateToLogin: (()->Void)?
//    
//    var userId: String? {
//        didSet{
//            guard let userId = userId else { return }            
//            profileVmObject.isSelf = isSelf
//            loadProfileData(id: userId) { user in
//                    if let user {
//                        DispatchQueue.main.async {
//                        self.updateUI(profile: user)
//                    }
//                }
//             
//            }
//        }
//    }
//    var isSelf: Bool = false
//    
//    lazy var reportButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("Report".localized, for: .normal)
//        button.titleLabel?.font = Appearance.default.font.getFont(forTypo: .h8)
//        button.setTitleColor(.lightGray, for: .normal)
//        button.ismTapFeedBack()
//        button.addTarget(self, action: #selector(reportButtonTapped), for: .touchUpInside)
//        return button
//    }()
//    
//    lazy var closeButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setImage(UIImage(named: "ic_close"), for: .normal)
//        button.titleLabel?.font = Appearance.default.font.getFont(forTypo: .h8)
//        button.setTitleColor(.lightGray, for: .normal)
//        button.ismTapFeedBack()
//        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
//        return button
//    }()
//    
//    let defaultProfileView: CustomDefaultProfileView = {
//        let defaultView = CustomDefaultProfileView()
//        defaultView.initialsText.font = Appearance.default.font.getFont(forTypo: .h2)
//        defaultView.layer.cornerRadius = 50
//        return defaultView
//    }()
//    
//    let userProfileImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 50
//        return imageView
//    }()
//    
//    let fullNameLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "---"
//        label.textColor = .black
//        label.font = Appearance.default.font.getFont(forTypo: .h4)
//        label.textAlignment = .center
//        return label
//    }()
//    
//    let userNameLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "---"
//        label.textColor = .lightGray
//        label.font = Appearance.default.font.getFont(forTypo: .h6)
//        label.textAlignment = .center
//        return label
//    }()
//    
//    let featureView: ProfileFeatureView = {
//        let view = ProfileFeatureView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    let descriptionLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = ""
//        label.textColor = .lightGray
//        label.font = Appearance.default.font.getFont(forTypo: .h8)
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        return label
//    }()
//    
//    lazy var bottomActionView: StreamProfileBottomActionView = {
//        let view = StreamProfileBottomActionView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.followButton.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
//        view.isHidden = true
//        return view
//    }()
//    
//    lazy var bottomActionViewForViewers: StreamProfileBottomActionViewForViewers = {
//        let view = StreamProfileBottomActionViewForViewers()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.followAndLeaveButton.addTarget(self, action: #selector(followAndLeaveTapped), for: .touchUpInside)
//        view.leaveButton.addTarget(self, action: #selector(leaveTapped), for: .touchUpInside)
//        view.isHidden = true
//        
//        return view
//    }()
//    
//    let noDataView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .white
//        return view
//    }()
//    
//    let activityIndicator: UIActivityIndicatorView = {
//        let indicator = UIActivityIndicatorView()
//        indicator.translatesAutoresizingMaskIntoConstraints = false
//        indicator.transform = CGAffineTransform.init(scaleX: 2, y: 2)
//        indicator.isHidden = true
//        indicator.tintColor = .black
//        return indicator
//    }()
//    
//    
//    // MARK: - MAIN
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupViews()
//        setupConstraints()
//    }
//    
//    // MARK: - FUNCTIONS
//    
//    func setupViews(){
//        
//        view.layer.cornerRadius = 30
//        
//        view.backgroundColor = .white
//        view.addSubview(reportButton)
//        view.addSubview(bottomActionView)
//        view.addSubview(bottomActionViewForViewers)
//        view.addSubview(defaultProfileView)
//        view.addSubview(userProfileImageView)
//        view.addSubview(featureView)
//        view.addSubview(fullNameLabel)
//        view.addSubview(userNameLabel)
//        view.addSubview(descriptionLabel)
//        view.addSubview(noDataView)
//        noDataView.addSubview(activityIndicator)
//        view.addSubview(closeButton)
//                
//    }
//    
//    func setupConstraints(){
//        
//        noDataView.ism_pin(to: self.view)
//        NSLayoutConstraint.activate([
//            reportButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            reportButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
//            
//            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
//            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
//            closeButton.heightAnchor.constraint(equalToConstant: 50),
//            closeButton.widthAnchor.constraint(equalToConstant: 50),
//            
//            defaultProfileView.widthAnchor.constraint(equalToConstant: 100),
//            defaultProfileView.heightAnchor.constraint(equalToConstant: 100),
//            defaultProfileView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            defaultProfileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
//            
//            userProfileImageView.widthAnchor.constraint(equalToConstant: 100),
//            userProfileImageView.heightAnchor.constraint(equalToConstant: 100),
//            userProfileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            userProfileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
//            
//            fullNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            fullNameLabel.topAnchor.constraint(equalTo: userProfileImageView.bottomAnchor, constant: 5),
//            fullNameLabel.heightAnchor.constraint(equalToConstant: 24),
//            
//            userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            userNameLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 5),
//            userNameLabel.heightAnchor.constraint(equalToConstant: 20),
//            
//            featureView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            featureView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 15),
//            featureView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            featureView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            featureView.heightAnchor.constraint(equalToConstant: 15),
//            
//            bottomActionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            bottomActionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            bottomActionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
//            bottomActionView.heightAnchor.constraint(equalToConstant: 70),
//            
//            bottomActionViewForViewers.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            bottomActionViewForViewers.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            bottomActionViewForViewers.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
//            bottomActionViewForViewers.heightAnchor.constraint(equalToConstant: 70),
//            
//            descriptionLabel.bottomAnchor.constraint(equalTo: bottomActionView.topAnchor, constant: -10),
//            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            descriptionLabel.topAnchor.constraint(equalTo: featureView.bottomAnchor, constant: 15),
//            
//            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
//    
//    func loadProfileData(id: String,needToHideView : Bool = false, completion: @escaping(User?)->()){
//        
//        activityIndicator.startAnimating()
//        activityIndicator.isHidden = false
//        noDataView.isHidden = false
//        if id != "" {
//            profileVmObject.memberId = id
//        }
//        profileVmObject.userDetailsService { (profile, error, canServiceCall) in
//            if profile != nil{
//                
//                DispatchQueue.main.async {
//                    self.activityIndicator.isHidden = true
//                    self.activityIndicator.stopAnimating()
//                    self.noDataView.isHidden = true
//                }
//       
//                let user = self.profileVmObject.userProfileModel
//                completion(user)
//                
//            }else if let error = error{
//                if error.code != 204{
//                    Helper.showAlertViewOnWindow("Error".localized, message: error.localizedDescription)
//                }
//                completion(nil)
//            }
//        }
//        
//    }
//    
//    func updateUI(profile :User ){
//    
//        let userName = profile.userName
//        let fullName =  (profile.firstName.capitalized) + " " +  (profile.lastName.capitalized)
//        
//        if let url = URL(string: profile.profilePic ) {
//            userProfileImageView.sd_setImage(with: url)
//        }
//        userNameLabel.text = "@\(userName)"
//        fullNameLabel.text = fullName
//        
//        let initials = String(userName.prefix(2))
//        defaultProfileView.initialsText.text = "\(initials)".uppercased()
//        
//        descriptionLabel.text = "\(profile.bioData )"
//        
//        featureView.followersView.featureLabel.text = "\( profile.followers)"
//        featureView.coinView.featureLabel.text = "\(profile.rating)"
//        
//        if isSelf {
//            bottomActionView.buttonStackView.isHidden = true
//            reportButton.isHidden = true
//        } else {
//            reportButton.isHidden = false
//            bottomActionView.buttonStackView.isHidden = false
//            let followStatus =  profile.followStatus
//            
//            switch followStatus {
//            case 0: // follow
//                followButtonUIChanges(for: .follow)
//                break
//            case 1: // following
//                followButtonUIChanges(for: .following)
//                break
//            case 2: // requested
//                followButtonUIChanges(for: .requested)
//                break
//            default: print("Nothing")
//            }
//        }
//        
//        if self.isCloseEvent {
//            bottomActionView.isHidden = true
//            bottomActionViewForViewers.isHidden = false
//            
//            let followAndLeaveButton = bottomActionViewForViewers.followAndLeaveButton
//            let followStatus =  profile.followStatus
//            
//            if !isSelf{
//                if followStatus == 0 {
//                    bottomActionViewForViewers.addViewToStackView(view: followAndLeaveButton)
//                } else {
//                    bottomActionViewForViewers.removeViewFromStackView(view: followAndLeaveButton)
//                }
//            }
//            
//        } else {
//            bottomActionView.isHidden = false
//            bottomActionViewForViewers.isHidden = true
//        }
//        
//    }
//    
//    func followButtonUIChanges(for status: FollowStatusCode) {
//     
//        let button = bottomActionView.followButton
//        
//        switch status {
//            case .follow:
//            button.backgroundColor = Appearance.default.colors.appColor
//            button.isEnabled = true
//            button.alpha = 1
//            button.layer.borderWidth = 0
//            button.setTitleColor(Appearance.default.colors.appSecondary, for: .normal)
//            button.setTitle("Follow".localized, for: .normal)
//            button.titleLabel?.font = Appearance.default.font.getFont(forTypo: .h5)
//            button.layoutSubviews()
//            break
//            case .following:
//            button.backgroundColor = .clear
//            button.isEnabled = true
//            button.alpha = 1
//            button.layer.borderWidth = 1.5
//            button.setTitleColor(Appearance.default.colors.appSecondary, for: .normal)
//            button.setTitle("Following".localized, for: .normal)
//            button.titleLabel?.font = Appearance.default.font.getFont(forTypo: .h5)
//            button.layoutSubviews()
//            break
//            case .requested:
//            button.backgroundColor = .lightGray.withAlphaComponent(0.5)
//            button.isEnabled = false
//            button.alpha = 0.5
//            button.layer.borderWidth = 0
//            button.setTitleColor(.white, for: .normal)
//            button.setTitle("Requested".localized, for: .normal)
//            button.layoutSubviews()
//            break
//        }
//        
//    }
//    
//    // MARK: - ACTIONS
//    
//    @objc func reportButtonTapped(){
//        
//        guard let isometrik else { return }
//        
//        // no action if guest user
//        let isGuestUser = (isometrik.getUserSession().getUserType() == .guest)
//        if isGuestUser { 
//            self.navigateToLogin?()
//            self.dismiss(animated: false)
//            return
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            
//            guard let profileData = self.profileVmObject.userProfileModel else { return }
//            let userId = profileData.userId
//            let controller = StreamReportViewController()
//            controller.userViewModel.userId = userId ?? ""
//            controller.modalPresentationStyle = .pageSheet
//            
//            if #available(iOS 15.0, *) {
//                if #available(iOS 16.0, *) {
//                    controller.sheetPresentationController?.prefersGrabberVisible = false
//                    controller.sheetPresentationController?.detents = [
//                        .custom(resolver: { context in
//                            return 250 + windowConstant.getBottomPadding
//                        })
//                    ]
//                }
//            }
//            
//            self.present(controller, animated: true)
//            
//        }
//    }
//    
//    @objc func followButtonTapped(){
//        
//        
//        guard let isometrik else { return }
//        
//        // no action if guest user
//        let isGuestUser = (isometrik.getUserSession().getUserType() == .guest)
//        if isGuestUser {
//            self.navigateToLogin?()
//            self.dismiss(animated: false)
//            return
//        }
//        
//        guard var profileData = profileVmObject.userProfileModel,
//              let userId = profileData.userId  else { return }
//        let followStatus = profileData.followStatus
//        
//        
//        if followStatus == 0 {
//            profileVmObject.FollowPeopleService(isFollow: true, peopleId: userId, privicy: 0)
//            followButtonUIChanges(for: .following)
//            profileData.followStatus = 1
//            loadProfileData(id: userId, needToHideView: true) {_ in 
//                self.followButton_callback?(true)
//            }
//            
//        } else if followStatus == 1 {
//            
//            profileVmObject.FollowPeopleService(isFollow: false, peopleId: userId, privicy: 0)
//            followButtonUIChanges(for: .follow)
//            profileData.followStatus = 0
//            loadProfileData(id: userId, needToHideView: true) {_ in 
//                self.followButton_callback?(false)
//            }
//            
//        }
//        
//    }
//    
//    @objc func followAndLeaveTapped(){
//        followButtonTapped()
//        leave_callback?()
//    }
//    
//    @objc func leaveTapped(){
//        leave_callback?()
//    }
//    
//    @objc func closeButtonTapped(){
//        self.dismiss(animated: true)
//    }


}

