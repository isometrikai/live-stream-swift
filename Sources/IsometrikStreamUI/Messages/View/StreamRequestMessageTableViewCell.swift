//
//  StreamRequestMessageTableViewCell.swift
//  IsometrikStream
//
//  Created by Appscrip 3Embed on 25/10/24.
//

import UIKit
import Kingfisher
import IsometrikStream

class StreamRequestMessageTableViewCell: UITableViewCell, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var viewTrailingConstraint: NSLayoutConstraint?
    var messageTrailingConstraint: NSLayoutConstraint?
    
    let backgroundCoverView: UIView = {
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
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .medium
        indicator.color = appearance.colors.appSecondary
        return indicator
    }()
    
    ///:
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = appearance.font.getFont(forTypo: .h6)
        label.textColor = .white
        return label
    }()
    
    let actionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    lazy var acceptButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.acceptRequest, for: .normal)
        button.ismTapFeedBack()
        return button
    }()
    
    lazy var rejectButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.rejectRequest, for: .normal)
        button.ismTapFeedBack()
        return button
    }()
    
    // MARK: MAIN -
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: FUNCTIONS -
    
    func setupViews(){
        backgroundColor = .clear
        addSubview(backgroundCoverView)
        addSubview(profileCoverView)
        profileCoverView.addSubview(userDefaultProfileImageView)
        profileCoverView.addSubview(userProfileImage)
        addSubview(profileButton)
        profileCoverView.addSubview(activityIndicator)
        
        addSubview(messageLabel)
        addSubview(actionStackView)
        actionStackView.addArrangedSubview(acceptButton)
        actionStackView.addArrangedSubview(rejectButton)
    }
    
    func setupConstraints(){
        userProfileImage.ism_pin(to: profileCoverView)
        userDefaultProfileImageView.ism_pin(to: profileCoverView)
        activityIndicator.ism_pin(to: profileCoverView)
        
        NSLayoutConstraint.activate([
            backgroundCoverView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundCoverView.topAnchor.constraint(equalTo: topAnchor),
            backgroundCoverView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            backgroundCoverView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            
            profileCoverView.leadingAnchor.constraint(equalTo: backgroundCoverView.leadingAnchor, constant: 5),
            profileCoverView.topAnchor.constraint(equalTo: backgroundCoverView.topAnchor, constant: 5),
            profileCoverView.widthAnchor.constraint(equalToConstant: 30),
            profileCoverView.heightAnchor.constraint(equalToConstant: 30),
            
            profileButton.leadingAnchor.constraint(equalTo: backgroundCoverView.leadingAnchor, constant: 5),
            profileButton.topAnchor.constraint(equalTo: backgroundCoverView.topAnchor, constant: 5),
            profileButton.widthAnchor.constraint(equalToConstant: 30),
            profileButton.heightAnchor.constraint(equalToConstant: 30),
            
            messageLabel.leadingAnchor.constraint(equalTo: profileCoverView.trailingAnchor, constant: 10),
            messageLabel.topAnchor.constraint(equalTo: backgroundCoverView.topAnchor, constant: 5),
            messageLabel.bottomAnchor.constraint(equalTo: backgroundCoverView.bottomAnchor, constant: -45),
            
            actionStackView.trailingAnchor.constraint(equalTo: backgroundCoverView.trailingAnchor, constant: -5),
            actionStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 5),
            
            acceptButton.widthAnchor.constraint(equalToConstant: 35),
            acceptButton.heightAnchor.constraint(equalToConstant: 35),
            
            rejectButton.widthAnchor.constraint(equalToConstant: 35),
            rejectButton.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        viewTrailingConstraint = backgroundCoverView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 10)
        viewTrailingConstraint?.isActive = true
        
        messageTrailingConstraint = messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10)
        messageTrailingConstraint?.isActive = true
    }
    
    func configureCell(message: ISMComment?){
        
        guard let message else { return }
        
        let userName = message.senderName ?? "Unknown".localized
        let userImage = message.senderImage.unwrap
        //let messageText = message.message.unwrap
        let messageText = "Send a request to be copublisher in your stream."
        let messageType = ISMStreamMessageType(rawValue: Int(message.messageType ?? 0))
        
        // MESSAGE
        
        setAttributes(AuthorName: userName + "\n", message: messageText)
        
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
