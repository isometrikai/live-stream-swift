//
//  CustomRTMPMemerView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 13/10/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

class CustomRTMPMemberView: UIView {

    // MARK: - PROPERTIES
    
    let defaultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Appearance.default.images.joinStream
        return imageView
    }()
    
    let defaultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Join"
        label.font = Appearance.default.font.getFont(forTypo: .h8)
        label.textAlignment = .center
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
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
        
        self.layer.masksToBounds = true
        addSubview(defaultImageView)
        addSubview(defaultLabel)
        
        addSubview(actionButton)
    }
    
    func setupConstraints(){
        actionButton.pin(to: self)
        NSLayoutConstraint.activate([
            defaultImageView.widthAnchor.constraint(equalToConstant: 30),
            defaultImageView.heightAnchor.constraint(equalToConstant: 30),
            defaultImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            defaultImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            defaultLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            defaultLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            defaultLabel.topAnchor.constraint(equalTo: defaultImageView.bottomAnchor, constant: 5)
        ])
    }

}
