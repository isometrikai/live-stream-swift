//
//  CustomDefaultView.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 15/09/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

class CustomDefaultView: UIView, ISMStreamUIAppearanceProvider {

    // MARK: - PROPERTIES
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    let defaultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 50
        imageView.backgroundColor = .lightGray.withAlphaComponent(0.7)
        return imageView
    }()
    
    lazy var defaultTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = appearance.font.getFont(forTypo: .h3)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var defaultActionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.backgroundColor = appearance.colors.appColor
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h5)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
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
        addSubview(stackView)
        //stackView.addArrangedSubview(defaultImageView)
        stackView.addArrangedSubview(defaultTitleLabel)
        stackView.addArrangedSubview(defaultActionButton)
    }
    
    func setupConstraints(){
        
        NSLayoutConstraint.activate([
            
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            //defaultImageView.widthAnchor.constraint(equalToConstant: 100),
            //defaultImageView.heightAnchor.constraint(equalToConstant: 100),
            
            defaultActionButton.heightAnchor.constraint(equalToConstant: 45)
            
        ])
    }

}
