//
//  CustomBattleProfileView.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 21/06/24.
//

import UIKit

class CustomBattleProfileView: UIView, AppearanceProvider {
    
    // MARK: - PROPERTIES
    
    lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = appearance.images.battleHostBackground
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.alpha = 0
        return imageView
    }()
    
    let profileView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    let userProfilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let defaultProfilePicture: CustomDefaultProfileView = {
        let imageView = CustomDefaultProfileView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
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
        addSubview(coverImageView)
        addSubview(profileView)
        profileView.addSubview(defaultProfilePicture)
        profileView.addSubview(userProfilePicture)
    }
    
    func setupConstraints(){
        coverImageView.ism_pin(to: self)
        defaultProfilePicture.ism_pin(to: profileView)
        userProfilePicture.ism_pin(to: profileView)
        NSLayoutConstraint.activate([
            profileView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60),
            profileView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileView.widthAnchor.constraint(equalToConstant: 50),
            profileView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
