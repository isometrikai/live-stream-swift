//
//  PKUserTableViewCell.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 29/11/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import UIKit
import Kingfisher
import IsometrikStream
import SkeletonView

class PKUserTableViewCell: UITableViewCell, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var data: ISM_PK_InviteStream? {
        didSet {
            manageData()
        }
    }
    
    var actionButtonCallback: ((_ index: Int) -> ())?
    
    lazy var userProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = appearance.colors.appLightGray.withAlphaComponent(0.5).cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userDefaultImage: CustomDefaultProfileView = {
        let imageView = CustomDefaultProfileView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.isSkeletonable = true
        imageView.skeletonCornerRadius = 25
        return imageView
    }()
    
    // MARK: - USER INFO LABEL
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.isSkeletonable = true
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h6)
        label.isSkeletonable = true
        label.skeletonTextNumberOfLines = 2
        label.lastLineFillPercent = 70
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isSkeletonable = true
        label.isHiddenWhenSkeletonIsActive = true
        return label
    }()
    
    //:
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Invite", for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h8)
        button.setTitleColor(appearance.colors.appColor, for: .normal)
        button.layer.borderColor = appearance.colors.appColor.cgColor
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 15
        button.ismTapFeedBack()
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        button.isSkeletonable = true
        button.skeletonCornerRadius = 15
        
        return button
    }()
    
    
    // MARK: - MAIN
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        actionButton.layer.borderWidth = 0
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        
        backgroundColor = .clear
        
        isSkeletonable = true
        contentView.isSkeletonable = true
        
        contentView.addSubview(userDefaultImage)
        contentView.addSubview(userProfileImage)
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        
        contentView.addSubview(actionButton)
    }
    
    func setupContraints(){
        NSLayoutConstraint.activate([
            userDefaultImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            userDefaultImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userDefaultImage.widthAnchor.constraint(equalToConstant: 50),
            userDefaultImage.heightAnchor.constraint(equalToConstant: 50),
            
            userProfileImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            userProfileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userProfileImage.widthAnchor.constraint(equalToConstant: 50),
            userProfileImage.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            actionButton.heightAnchor.constraint(equalToConstant: 30),
            actionButton.widthAnchor.constraint(equalToConstant: 80),
            
            stackView.leadingAnchor.constraint(equalTo: userProfileImage.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -10),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 17),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    func manageData(){
        guard let data = data else { return }
        
        actionButton.layer.borderWidth = 1
        
        let profilePic = data.profilePic.unwrap
        if profilePic != UserDefaultsProvider.shared.getIsometrikDefaultProfile(), !profilePic.isEmpty, let profileURL = URL(string: profilePic) {
            userProfileImage.kf.setImage(with: profileURL)
        }
        
        titleLabel.text = "@\(data.userName ?? "")"
        subtitleLabel.ism_setLabelWithLeftImage(withImage: appearance.images.eye, imageColor: appearance.colors.appLightGray, imageSize: 13, text: "\(data.viewerCount ?? 0)", font: appearance.font.getFont(forTypo: .h8)!, textColor: appearance.colors.appLightGray)
            
        if let userName = data.userName {
            
            let initialText = userName.prefix(2)
            userDefaultImage.initialsText.text = "\(initialText)".uppercased()
            
        }
    }
    
    // MARK: - ACTIONS
    
    @objc func actionButtonTapped(){
        actionButtonCallback?(self.tag)
    }

}
