//
//  GoLiveWithActionView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 19/06/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

class GoLiveWithActionView: UIView, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    let actionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.axis = .horizontal
        return stackView
    }()
    
    let actionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var actionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Action Name"
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h8)
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
        addSubview(actionStackView)
        actionStackView.addArrangedSubview(actionImageView)
        actionStackView.addArrangedSubview(actionLabel)
        addSubview(actionButton)
    }
    
    func setupConstraints(){
        actionButton.ism_pin(to: self)
        NSLayoutConstraint.activate([
            actionStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            actionImageView.heightAnchor.constraint(equalToConstant: 15),
            actionImageView.widthAnchor.constraint(equalToConstant: 15)
        ])
    }

}
