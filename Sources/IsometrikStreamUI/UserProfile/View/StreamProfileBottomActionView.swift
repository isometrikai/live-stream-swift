//
//  StreamProfileBottomActionView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 03/02/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

class StreamProfileBottomActionView: UIView {
    
    // MARK: - PROPERTIES
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 15
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let mentionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.setImage(UIImage(named: "ism_mention")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.ismTapFeedBack()
        return button
    }()
    
    let followButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.titleLabel?.font = Appearance.default.font.getFont(forTypo: .h5)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = Appearance.default.colors.appSecondary.cgColor
        button.layer.borderWidth = 0
        button.backgroundColor = .lightGray.withAlphaComponent(0.5)
        button.isEnabled = false
        
        button.layer.cornerRadius = 25
        button.ismTapFeedBack()
        return button
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
        addSubview(buttonStackView)
        //buttonStackView.addArrangedSubview(mentionButton)
        buttonStackView.addArrangedSubview(followButton)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50),
            buttonStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            mentionButton.heightAnchor.constraint(equalToConstant: 50),
            followButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
