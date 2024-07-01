//
//  PKInviteDefaultView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 01/12/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import UIKit

class PKInviteDefaultView: UIView, AppearanceProvider {
    
    // MARK: - PROPERTIES
    
    lazy var defaultImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = appearance.images.noViewers
        return imageView
    }()
    
    lazy var defaultText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No one to invite."
        label.font = appearance.font.getFont(forTypo: .h6)
        label.textAlignment = .center
        label.textColor = .white
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
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        backgroundColor = .clear
        addSubview(defaultImage)
        addSubview(defaultText)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            defaultImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            defaultImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            defaultImage.widthAnchor.constraint(equalToConstant: 100),
            defaultImage.heightAnchor.constraint(equalToConstant: 100),
            
            defaultText.topAnchor.constraint(equalTo: defaultImage.bottomAnchor, constant: 15),
            defaultText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            defaultText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
}
