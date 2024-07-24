//
//  PKChallengeHeaderView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 29/11/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import UIKit

class PKChallengeHeaderView: UIView, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "PK Challenge Settings"
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h8)
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Configure your PK challenge by modifying the settings below"
        label.textColor = appearance.colors.appLightGray
        label.font = appearance.font.getFont(forTypo: .h8)
        label.numberOfLines = 0
        return label
    }()
    
    let customBannerView: PKChallengeCustomBannerView = {
        let view = PKChallengeCustomBannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
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
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(customBannerView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            customBannerView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            customBannerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            customBannerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            customBannerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
