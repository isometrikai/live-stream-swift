//
//  PkWithFriendsHeaderView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 24/11/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import UIKit

class PkWithFriendsHeaderView: UIView, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "PK With Friends"
        label.font = appearance.font.getFont(forTypo: .h5)
        label.textColor = .white
        return label
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.close.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        return button
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white.withAlphaComponent(0.2)
        return view
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
        addSubview(titleLabel)
        addSubview(closeButton)
        addSubview(dividerView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 25),
            closeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 25),
            
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 0.7),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - ACTIONS

}
