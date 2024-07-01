//
//  CustomVideoContainerImageView.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 09/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

class CustomVideoContainerImageView: UIView {
    
    // MARK: - PROPERTIES
    
    var cardImageWidthAnchor: NSLayoutConstraint?
    var cardImageHeightAnchor: NSLayoutConstraint?
    
    let cardImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let cardButton: UIButton = {
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
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        addSubview(cardImage)
        addSubview(cardButton)
    }
    
    func setupConstraints(){
        cardButton.pin(to: self)
        NSLayoutConstraint.activate([
            cardImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            cardImage.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        cardImageWidthAnchor = cardImage.widthAnchor.constraint(equalToConstant: 20)
        cardImageWidthAnchor?.isActive = true
        
        cardImageHeightAnchor = cardImage.heightAnchor.constraint(equalToConstant: 20)
        cardImageHeightAnchor?.isActive = true
    }
    
}
