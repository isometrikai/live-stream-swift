//
//  CustomFeatureView.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 03/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

class customFeatureView: UIView, ISMStreamUIAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var featureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "--"
        label.textColor = .black
        label.font = appearance.font.getFont(forTypo: .h5)
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
        addSubview(iconImageView)
        addSubview(featureLabel)
        addSubview(actionButton)
    }
    
    func setupConstraints(){
        actionButton.ism_pin(to: self)
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 15),
            iconImageView.heightAnchor.constraint(equalToConstant: 15),
            
            featureLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 7),
            featureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            featureLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
