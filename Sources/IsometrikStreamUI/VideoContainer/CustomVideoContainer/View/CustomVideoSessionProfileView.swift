//
//  CustomVideoSessionProfileView.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 09/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

class CustomVideoSessionProfileView: UIView, ISMStreamUIAppearanceProvider {
    
    // MARK: - PROPERTIES

    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "ism_UserDefault")
        imageView.clipsToBounds = true
        return imageView
    }()

    let blurrView: BlurrHolderView = {
        let view = BlurrHolderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        return view
    }()
    
    let profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let defaultProfilePicture: CustomDefaultProfileView = {
        let view = CustomDefaultProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = appearance.font.getFont(forTypo: .h8)
        label.numberOfLines = 1
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let liveStatusView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 3.5
        view.isHidden = true
        return view
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
        addSubview(backgroundImage)
        addSubview(blurrView)
        addSubview(profileView)
        profileView.addSubview(defaultProfilePicture)
        profileView.addSubview(profilePicture)
        profileView.addSubview(usernameLabel)
        profileView.addSubview(liveStatusView)
    }
    
    func setupConstraints(){
        blurrView.ism_pin(to: self)
        profileView.ism_pin(to: self)
        backgroundImage.ism_pin(to: self)
        NSLayoutConstraint.activate([
            profilePicture.widthAnchor.constraint(equalToConstant: 50),
            profilePicture.heightAnchor.constraint(equalToConstant: 50),
            profilePicture.centerXAnchor.constraint(equalTo: profileView.centerXAnchor),
            profilePicture.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),
            
            defaultProfilePicture.widthAnchor.constraint(equalToConstant: 50),
            defaultProfilePicture.heightAnchor.constraint(equalToConstant: 50),
            defaultProfilePicture.centerXAnchor.constraint(equalTo: profileView.centerXAnchor),
            defaultProfilePicture.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),
            
            usernameLabel.centerXAnchor.constraint(equalTo: profileView.centerXAnchor),
            usernameLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 15),
            usernameLabel.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 20),
            usernameLabel.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -20),
            
            liveStatusView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            liveStatusView.widthAnchor.constraint(equalToConstant: 7),
            liveStatusView.heightAnchor.constraint(equalToConstant: 7),
            liveStatusView.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 4)
        ])
    }
    
}


class BlurrHolderView: UIView, ISMStreamUIAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    let blurrView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var blurrViewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font =  appearance.font.getFont(forTypo: .h4)
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
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        addSubview(blurrView)
        addSubview(blurrViewLabel)
        
        blurrView.effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurrViewLabel.text = nil
    }
    
    func setupConstraints(){
        blurrView.ism_pin(to: self)
        NSLayoutConstraint.activate([
            blurrViewLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            blurrViewLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}

