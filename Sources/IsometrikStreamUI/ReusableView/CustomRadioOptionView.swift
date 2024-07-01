//
//  CustomRadioOptionView.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 23/04/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit

class CustomRadioOptionView: UIView {
    
    // MARK: - PROPERTIES
    
    let radioImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Appearance.default.images.radioUnSelected
        return imageView
    }()
    
    let optionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = Appearance.default.font.getFont(forTypo: .h4)
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: MAIN -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        addSubview(radioImage)
        addSubview(optionLabel)
        addSubview(actionButton)
    }
    
    func setUpConstraints(){
        actionButton.pin(to: self)
        NSLayoutConstraint.activate([
            radioImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            radioImage.widthAnchor.constraint(equalToConstant: 24),
            radioImage.heightAnchor.constraint(equalToConstant: 24),
            radioImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            optionLabel.leadingAnchor.constraint(equalTo: radioImage.trailingAnchor, constant: 16),
            optionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            optionLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}
