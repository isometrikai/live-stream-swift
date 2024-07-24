//
//  StreamProfileView.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 23/03/22.
//

import UIKit

class StreamProfileView: UIView, ISMAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    let profileCard: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.6)
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageCardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let defaultProfileView: CustomDefaultProfileView = {
        let defaultView = CustomDefaultProfileView()
        defaultView.layer.cornerRadius = 20
        return defaultView
    }()
    
    let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var profileName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = ""
        label.numberOfLines = 0
        label.font = appearance.font.getFont(forTypo: .h8)
        return label
    }()
    
    lazy var userIdentifierLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = ""
        label.numberOfLines = 0
        label.font = appearance.font.getFont(forTypo: .h8)
        return label
    }()
    
    let profileDetailsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.follow.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = appearance.colors.appRed
        return button
    }()
    
    // MARK: - MAIN
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            profileCard.layer.cornerRadius = profileCard.frame.height / 2
            profileCard.layer.borderWidth = 1
            profileCard.layer.borderColor = UIColor.white.cgColor
            
            profileImageCardView.layer.cornerRadius = profileImageCardView.frame.height / 2
            profileImageCardView.layer.borderWidth = 1
            profileImageCardView.layer.borderColor = UIColor.white.cgColor
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        addSubview(profileCard)
        profileCard.addSubview(defaultProfileView)
        
        profileCard.addSubview(profileImageCardView)
        profileImageCardView.addSubview(profileImage)
        
        profileCard.addSubview(infoStackView)
        profileCard.addSubview(profileDetailsButton)
        profileCard.addSubview(followButton)
        
        infoStackView.addArrangedSubview(profileName)
        infoStackView.addArrangedSubview(userIdentifierLabel)
        
        
    }
    
    func setupConstraints(){
        profileCard.ism_pin(to: self)
        profileDetailsButton.ism_pin(to: profileCard)
        defaultProfileView.ism_pin(to: profileImageCardView)
        profileImage.ism_pin(to: profileImageCardView)
        NSLayoutConstraint.activate([
            profileImageCardView.widthAnchor.constraint(equalToConstant: 40),
            profileImageCardView.heightAnchor.constraint(equalToConstant: 40),
            profileImageCardView.leadingAnchor.constraint(equalTo: profileCard.leadingAnchor),
            profileImageCardView.centerYAnchor.constraint(equalTo: profileCard.centerYAnchor),
            
            infoStackView.leadingAnchor.constraint(equalTo: profileImageCardView.trailingAnchor, constant: 6),
            infoStackView.centerYAnchor.constraint(equalTo: profileCard.centerYAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: followButton.leadingAnchor, constant: -3),
            
            profileName.heightAnchor.constraint(equalToConstant: 13),
            userIdentifierLabel.heightAnchor.constraint(equalToConstant: 11),
            
            followButton.trailingAnchor.constraint(equalTo: profileCard.trailingAnchor, constant: -6),
            followButton.widthAnchor.constraint(equalToConstant: 20),
            followButton.heightAnchor.constraint(equalToConstant: 20),
            followButton.centerYAnchor.constraint(equalTo: profileCard.centerYAnchor)
        ])
    }
    
}
