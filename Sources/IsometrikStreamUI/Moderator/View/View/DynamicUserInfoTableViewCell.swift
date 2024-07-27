//
//  DynamicUserInfoTableViewCell.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 15/02/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import Kingfisher
import IsometrikStream

class DynamicUserInfoTableViewCell: UITableViewCell, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var userData: ISMStreamUser? {
        didSet {
            manageData()
        }
    }
    
    var actionButtonWidth: NSLayoutConstraint?
    var actionButton_callback: ((_ userData: ISMStreamUser)->Void)?
    
    let userProfilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        return imageView
    }()
    
    let defaultUserProfilePicture: CustomDefaultProfileView = {
        let view = CustomDefaultProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        return view
    }()
    
    let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = appearance.font.getFont(forTypo: .h5)
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = appearance.font.getFont(forTypo: .h8)
        return label
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add".localized, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h8)
        button.setTitleColor(appearance.colors.appSecondary, for: .normal)
        button.backgroundColor = appearance.colors.appColor
        button.layer.cornerRadius = 17.5
        button.ismTapFeedBack()
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
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
        addSubview(defaultUserProfilePicture)
        addSubview(userProfilePicture)
        
        addSubview(infoStackView)
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(subtitleLabel)
        
        addSubview(actionButton)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            
            defaultUserProfilePicture.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            defaultUserProfilePicture.centerYAnchor.constraint(equalTo: centerYAnchor),
            defaultUserProfilePicture.widthAnchor.constraint(equalToConstant: 50),
            defaultUserProfilePicture.heightAnchor.constraint(equalToConstant: 50),
            
            userProfilePicture.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            userProfilePicture.centerYAnchor.constraint(equalTo: centerYAnchor),
            userProfilePicture.widthAnchor.constraint(equalToConstant: 50),
            userProfilePicture.heightAnchor.constraint(equalToConstant: 50),
            
            infoStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            infoStackView.leadingAnchor.constraint(equalTo: userProfilePicture.trailingAnchor, constant: 15),
            infoStackView.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -15),
            
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            actionButton.heightAnchor.constraint(equalToConstant: 35),
            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor)
            
        ])
        
        actionButtonWidth = actionButton.widthAnchor.constraint(equalToConstant: 70)
        actionButtonWidth?.isActive = true
        
    }
    
    func manageData(){
        
        guard let userData = userData else { return }
        
        let imagePath = userData.imagePath.unwrap
        let userName = userData.identifier.unwrap
        let name = userData.name.unwrap
        
        if imagePath != UserDefaultsProvider.shared.getIsometrikDefaultProfile() {
            if let imageUrl = URL(string: imagePath) {
                userProfilePicture.kf.setImage(with: imageUrl)
            } else {
                userProfilePicture.image = UIImage()
            }
        } else {
            userProfilePicture.image = UIImage()
        }
        
        let initialText = name.prefix(2)
        defaultUserProfilePicture.initialsText.text = "\(initialText)".uppercased()
        
        titleLabel.text = name
        subtitleLabel.text = userName
        
    }
    
    // MARK: - ACTIONS

    @objc func actionButtonTapped(){
        guard let userData = userData else { return }
        actionButton_callback?(userData)
    }
}
