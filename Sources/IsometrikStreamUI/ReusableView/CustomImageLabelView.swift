//
//  CustomImageLabelView.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 07/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

class CustomImageLabelView: UIView {

    // MARK: - PROPERTIES
    
    let cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .white
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: .medium)
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
        addSubview(cardImageView)
        addSubview(textLabel)
        addSubview(actionButton)
    }
    
    func setupConstraints(){
        actionButton.pin(to: self)
        NSLayoutConstraint.activate([
            cardImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            cardImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cardImageView.widthAnchor.constraint(equalToConstant: 15),
            cardImageView.heightAnchor.constraint(equalToConstant: 15),
            
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            textLabel.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: 5)
        ])
    }

}
