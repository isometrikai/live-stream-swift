//
//  StreamUpdateInfoMessageView.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 29/09/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit
import Kingfisher
import IsometrikStream

class StreamEventUpdateInfoMessageView: UIView, ISMStreamUIAppearanceProvider {

    // MARK: - PROPERTIES
    
    let coverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.4)
        view.layer.cornerRadius = 25
        view.alpha = 0
        return view
    }()
    
    let profileCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let userProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userDefaultProfileImageView: CustomDefaultProfileView = {
        let imageView = CustomDefaultProfileView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h7)
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = appearance.font.getFont(forTypo: .h6)
        label.textColor = appearance.colors.appColor
        label.numberOfLines = 0
        return label
    }()
    
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
        addSubview(coverView)
        coverView.addSubview(profileCoverView)
        profileCoverView.addSubview(userDefaultProfileImageView)
        profileCoverView.addSubview(userProfileImage)
        
        coverView.addSubview(userNameLabel)
        coverView.addSubview(messageLabel)
    }
    
    func setupConstraints(){
        userProfileImage.ism_pin(to: profileCoverView)
        userDefaultProfileImageView.ism_pin(to: profileCoverView)
        NSLayoutConstraint.activate([
            
            coverView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            coverView.topAnchor.constraint(equalTo: topAnchor),
            coverView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            coverView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            profileCoverView.leadingAnchor.constraint(equalTo: coverView.leadingAnchor, constant: 5),
            profileCoverView.centerYAnchor.constraint(equalTo: coverView.centerYAnchor),
            profileCoverView.widthAnchor.constraint(equalToConstant: 40),
            profileCoverView.heightAnchor.constraint(equalToConstant: 40),

            userNameLabel.leadingAnchor.constraint(equalTo: profileCoverView.trailingAnchor, constant: 10),
            userNameLabel.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -15),
            userNameLabel.topAnchor.constraint(equalTo: coverView.topAnchor, constant: 5),
            userNameLabel.heightAnchor.constraint(equalToConstant: 15),
            
            messageLabel.leadingAnchor.constraint(equalTo: profileCoverView.trailingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -15),
            messageLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: coverView.bottomAnchor, constant: -5)
        ])
    }
    
    func configureData(message: ISMComment?) {
        
        guard let message else { return }
        
        let userName = message.senderName ?? "Unknown".localized
        let userImage = message.senderImage.unwrap
        let messageText = message.message.unwrap
        
        if userName == "" {
            userNameLabel.text = "Unknown".localized
        } else {
            userNameLabel.text = userName
        }
        
        if let imageUrl = URL(string: userImage) {
            self.userProfileImage.kf.setImage(with: imageUrl)
        }
        
        let initialText = userName.prefix(2)
        userDefaultProfileImageView.initialsText.text = "\(initialText)".uppercased()
        
        self.coverView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.coverView.alpha = 1
        }
        
    }

}
