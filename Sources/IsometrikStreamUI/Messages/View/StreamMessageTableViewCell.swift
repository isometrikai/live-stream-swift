//
//  StreamMessageTableViewCell.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 13/09/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit
import Kingfisher
import IsometrikStream

class StreamMessageTableViewCell: UITableViewCell, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var viewTrailingConstraint: NSLayoutConstraint?
    var messageTrailingConstraint: NSLayoutConstraint?
    
    let backgroundMessageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.2)
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    /// Profile
    
    let profileCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let userProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userDefaultProfileImageView: CustomDefaultProfileView = {
        let imageView = CustomDefaultProfileView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let profileButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    ///:
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = appearance.font.getFont(forTypo: .h6)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    let deleteView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var deleteImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = appearance.images.removeCircle.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = appearance.colors.appRed
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - MAIN
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        backgroundColor = .clear
        addSubview(backgroundMessageView)
        addSubview(profileCoverView)
        profileCoverView.addSubview(userDefaultProfileImageView)
        profileCoverView.addSubview(userProfileImage)
        addSubview(profileButton)
        
        //addSubview(userNameLabel)
        addSubview(messageLabel)
        
        addSubview(deleteView)
        deleteView.addSubview(deleteImage)
        deleteView.addSubview(deleteButton)
    }
    
    func setupConstraints(){
        userProfileImage.ism_pin(to: profileCoverView)
        userDefaultProfileImageView.ism_pin(to: profileCoverView)
        deleteButton.ism_pin(to: deleteView)
        
        NSLayoutConstraint.activate([
            backgroundMessageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundMessageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundMessageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            backgroundMessageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            
            profileCoverView.leadingAnchor.constraint(equalTo: backgroundMessageView.leadingAnchor, constant: 5),
            profileCoverView.topAnchor.constraint(equalTo: backgroundMessageView.topAnchor, constant: 5),
            profileCoverView.widthAnchor.constraint(equalToConstant: 30),
            profileCoverView.heightAnchor.constraint(equalToConstant: 30),
            
            profileButton.leadingAnchor.constraint(equalTo: backgroundMessageView.leadingAnchor, constant: 5),
            profileButton.topAnchor.constraint(equalTo: backgroundMessageView.topAnchor, constant: 5),
            profileButton.widthAnchor.constraint(equalToConstant: 30),
            profileButton.heightAnchor.constraint(equalToConstant: 30),

//            userNameLabel.leadingAnchor.constraint(equalTo: profileCoverView.trailingAnchor, constant: 10),
//            userNameLabel.topAnchor.constraint(equalTo: backgroundMessageView.topAnchor, constant: 5),
//            userNameLabel.heightAnchor.constraint(equalToConstant: 15),
            
            messageLabel.leadingAnchor.constraint(equalTo: profileCoverView.trailingAnchor, constant: 10),
            messageLabel.topAnchor.constraint(equalTo: backgroundMessageView.topAnchor, constant: 5),
            messageLabel.bottomAnchor.constraint(equalTo: backgroundMessageView.bottomAnchor, constant: -5),
            
            deleteView.trailingAnchor.constraint(equalTo: backgroundMessageView.trailingAnchor, constant: -5),
            deleteView.topAnchor.constraint(equalTo: backgroundMessageView.topAnchor, constant: 5),
            deleteView.heightAnchor.constraint(equalToConstant: 30),
            deleteView.widthAnchor.constraint(equalToConstant: 30),
            
            deleteImage.centerYAnchor.constraint(equalTo: deleteView.centerYAnchor),
            deleteImage.centerXAnchor.constraint(equalTo: deleteView.centerXAnchor),
            deleteImage.widthAnchor.constraint(equalToConstant: 15),
            deleteImage.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        viewTrailingConstraint = backgroundMessageView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 10)
        viewTrailingConstraint?.isActive = true
        
        messageTrailingConstraint = messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10)
        messageTrailingConstraint?.isActive = true
    }
    
    func configureData(message: ISMComment?, userAccess: StreamUserAccess?) {
        
        guard let message, let userAccess else { return }
        
        let userName = message.senderName ?? "Unknown".localized
        let userImage = message.senderImage.unwrap
        let messageText = message.message.unwrap
        let messageType = ISMStreamMessageType(rawValue: Int(message.messageType ?? 0))
        
        // MESSAGE
        
        if messageType == .productBought {
            setAttributes(AuthorName: "" , message: messageText)
        } else {
            setAttributes(AuthorName: userName + "\n", message: messageText)
        }
        
        //:
        
        // PROFILE
        
        if userImage != UserDefaultsProvider.shared.getIsometrikDefaultProfile(), !userImage.isEmpty {
            
            if let url = URL(string: userImage) {
                userProfileImage.kf.setImage(with: url)
            }
            
        } else {
            userProfileImage.image = UIImage()
        }
        
        let initialText = userName.prefix(2).uppercased()
        userDefaultProfileImageView.initialsText.text = initialText
        userDefaultProfileImageView.contentMode = .scaleAspectFill
        
        //:
        
        // DELETE ACTIONS
        
        viewTrailingConstraint?.constant = (userAccess == .moderator) ? 40 : 10
        messageTrailingConstraint?.constant = (userAccess == .moderator) ? -40: -10
        
        if messageType == .productBought {
            deleteView.isHidden = true
        } else {
            deleteView.isHidden = (userAccess == .moderator) ? false : true
        }
        
        //:
        
        if messageType == .productBought {
            backgroundMessageView.backgroundColor = appearance.colors.appColor.withAlphaComponent(0.5)
        } else {
            backgroundMessageView.backgroundColor = .black.withAlphaComponent(0.2)
        }
        
    }
    
    func setAttributes(AuthorName: String, message: String) {
                
        let attributedText = NSMutableAttributedString(
            attributedString: NSAttributedString(
                string: AuthorName,
                attributes: [
                    NSAttributedString.Key.font: appearance.font.getFont(forTypo: .h7)! ,
                    NSAttributedString.Key.foregroundColor: UIColor.white
                ]
            )
        )
                
        attributedText.append(
            NSAttributedString(
                string: message,
                attributes: [
                    NSAttributedString.Key.font: appearance.font.getFont(forTypo: .h8)!,
                    NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.8)
                ]
            )
        )
        
        self.messageLabel.attributedText = attributedText
        
    }

}
