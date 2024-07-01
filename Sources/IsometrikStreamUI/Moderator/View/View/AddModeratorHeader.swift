//
//  AddModeratorHeader.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 15/02/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

class AddModeratorHeader: UIView, AppearanceProvider {

    // MARK: - PROPERTIES
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add Moderators".localized
        label.font = appearance.font.getFont(forTypo: .h4)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add moderator to a broadcast who can kickout members, or viewers, remove messages and reply to a message".localized + "."
        label.textColor = .lightGray
        label.font = appearance.font.getFont(forTypo: .h6)
        label.textAlignment = .center
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
        addSubview(titleLabel)
        addSubview(descriptionLabel)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)
        ])
    }

}
