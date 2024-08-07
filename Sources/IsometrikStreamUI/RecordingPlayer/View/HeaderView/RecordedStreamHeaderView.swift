//
//  RecordedStreamHeaderView.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 25/12/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

class RecordedStreamHeaderView: UIView, ISMAppearanceProvider {
    
    lazy var profileView: StreamProfileView = {
        let view = StreamProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //: - trailing action views
    
    let trailingActionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let cartView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cartImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "cart_tab_white_2")
        return image
    }()
    
    lazy var cartBadge: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("0", for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h9)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.isHidden = true
        return button
    }()
    
    let cartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var viewerCountView: CustomFeatureView = {
        let view = CustomFeatureView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.iconImageView.image = appearance.images.eye.withRenderingMode(.alwaysTemplate)
        view.iconImageView.tintColor = .white
        view.featureLabel.text = "0"
        view.featureLabel.textColor = .white
        view.featureLabel.font = appearance.font.getFont(forTypo: .h8)
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 12.5
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.close.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        button.ismTapFeedBack()
        button.layer.cornerRadius = 15
        return button
    }()
    
    //:
    
    // MARK: - MAIN
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        backgroundColor = .clear
        addSubview(profileView)
        
        addSubview(trailingActionView)
        
        trailingActionView.addSubview(cartView)
        cartView.addSubview(cartImage)
        cartView.addSubview(cartBadge)
        
        trailingActionView.addSubview(cartButton)
        trailingActionView.addSubview(viewerCountView)
        trailingActionView.addSubview(closeButton)
        
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            profileView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            profileView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            profileView.heightAnchor.constraint(equalToConstant: 40),
            
            trailingActionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            trailingActionView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            trailingActionView.heightAnchor.constraint(equalToConstant: 40),
            trailingActionView.leadingAnchor.constraint(equalTo: cartView.leadingAnchor),
            
            cartButton.leadingAnchor.constraint(equalTo: cartView.leadingAnchor),
            cartButton.trailingAnchor.constraint(equalTo: cartView.trailingAnchor),
            cartButton.topAnchor.constraint(equalTo: cartView.topAnchor),
            cartButton.bottomAnchor.constraint(equalTo: cartView.bottomAnchor),
            
            closeButton.trailingAnchor.constraint(equalTo: trailingActionView.trailingAnchor, constant: -12),
            closeButton.centerYAnchor.constraint(equalTo: trailingActionView.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            
            viewerCountView.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -5),
            viewerCountView.heightAnchor.constraint(equalToConstant: 25),
            viewerCountView.centerYAnchor.constraint(equalTo: trailingActionView.centerYAnchor),
            
            cartView.trailingAnchor.constraint(equalTo: viewerCountView.leadingAnchor, constant: -10),
            cartView.heightAnchor.constraint(equalToConstant: 35),
            cartView.widthAnchor.constraint(equalToConstant: 35),
            cartView.centerYAnchor.constraint(equalTo: trailingActionView.centerYAnchor),
            
            cartImage.widthAnchor.constraint(equalToConstant: 25),
            cartImage.heightAnchor.constraint(equalToConstant: 25),
            cartImage.centerXAnchor.constraint(equalTo: cartView.centerXAnchor),
            cartImage.centerYAnchor.constraint(equalTo: cartView.centerYAnchor),
            
            cartBadge.leadingAnchor.constraint(equalTo: cartImage.trailingAnchor, constant: -10),
            cartBadge.topAnchor.constraint(equalTo: cartImage.topAnchor, constant: -10),
            cartBadge.heightAnchor.constraint(equalToConstant: 20),
            cartBadge.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configureData(streamData: ISMStream? , isometrik: IsometrikSDK?){
        
        guard let streamData, let isometrik else { return }
        
        let currentUserId = isometrik.getUserSession().getUserId()
        
        let firstName = streamData.userMetaData?.firstName ?? ""
        let lastName = streamData.userMetaData?.lastName ?? ""
        let fullName = "\(firstName) \(lastName)"
        
        let userName = streamData.userDetails?.userName ?? ""
        let userId = streamData.initiatorId ?? ""
        
        let userProfilePic = streamData.userDetails?.profilePic ?? ""
        let followStatusCode = streamData.userDetails?.followStatus ?? 0
        let privacy = streamData.userDetails?.privacy ?? 0
        
        
        //let followStatus = FollowStatusCode(rawValue: followStatusCode)
        
        if userProfilePic != UserDefaultsProvider.shared.getIsometrikDefaultProfile() {
            if let url = URL(string: userProfilePic) {
                profileView.profileImage.kf.setImage(with: url)
            } else {
                profileView.profileImage.image = UIImage()
            }
        } else {
            profileView.profileImage.image = UIImage()
        }
        
        let initialText = "\(firstName.prefix(1))\(lastName.prefix(1))"
        profileView.defaultProfileView.initialsText.font = appearance.font.getFont(forTypo: .h6)
        profileView.defaultProfileView.initialsText.text = initialText
        
        profileView.profileName.text = fullName
        profileView.userIdentifierLabel.text = userName
        
        // views count
        viewerCountView.featureLabel.text = "\(streamData.recordViewCount ?? 0)"

//        if userId == currentUserId {
//            profileView.followButton.isHidden = true
//        } else {
//            profileView.followButton.isHidden = false
//        }
        
//        switch followStatus {
//        case .follow:
//            profileView.followButton.setImage(UIImage(named: "ism_follow")?.withRenderingMode(.alwaysTemplate), for: .normal)
//            profileView.followButton.imageView?.tintColor = .white
//            break
//        case .following:
//            profileView.followButton.setImage(UIImage(named: "ism_following")?.withRenderingMode(.alwaysTemplate), for: .normal)
//            profileView.followButton.imageView?.tintColor = .white
//            break
//        case .requested:
//            profileView.followButton.setImage(UIImage(named: "ism_requested")?.withRenderingMode(.alwaysTemplate), for: .normal)
//            profileView.followButton.imageView?.tintColor = .white
//            break
//        case nil:
//            break
//        }
        
    }

}
