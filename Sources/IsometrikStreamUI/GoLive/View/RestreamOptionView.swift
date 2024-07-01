//
//  RestreamOptionView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 11/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

class RestreamOptionView: UIView, AppearanceProvider {

    // MARK: - PROPERTIES
    
    let dividerOne: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return view
    }()
    
    lazy var restreamLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Restream".localized
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h6)
        return label
    }()
    
    lazy var trailingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = appearance.images.arrowRight.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let dividerTwo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return view
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
        addSubview(dividerOne)
        addSubview(restreamLabel)
        addSubview(trailingImage)
        addSubview(dividerTwo)
        addSubview(actionButton)
    }
    
    func setupConstraints(){
        actionButton.ism_pin(to: self)
        NSLayoutConstraint.activate([
            dividerOne.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            dividerOne.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            dividerOne.topAnchor.constraint(equalTo: topAnchor),
            dividerOne.heightAnchor.constraint(equalToConstant: 1),
            
            restreamLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            restreamLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            restreamLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            trailingImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            trailingImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingImage.heightAnchor.constraint(equalToConstant: 18),
            trailingImage.widthAnchor.constraint(equalToConstant: 18),
            
            dividerTwo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            dividerTwo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            dividerTwo.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerTwo.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

}
