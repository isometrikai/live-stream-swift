//
//  GoLiveCustomToggleView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 06/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import SkeletonView

class GoLiveCustomToggleView: UIView, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var activeColor: UIColor? = .white
    var isSelected: Bool? = false {
        didSet {
            guard let isSelected else { return }
            
            if isSelected {
                if activeColor == .black {
                    toggleImageView.image = appearance.images.toggleOnDark
                } else {
                    toggleImageView.image = appearance.images.toggleOn
                }
            } else {
                if activeColor == .black {
                    toggleImageView.image = appearance.images.toggleOffDark
                } else {
                    toggleImageView.image = appearance.images.toggleOff
                }
            }
            
            toggleTitleLabel.textColor = isSelected ? activeColor : .lightGray
        }
    }
    
    let toggleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isSkeletonable = true
        imageView.skeletonCornerRadius = 20
        return imageView
    }()
    
    lazy var toggleTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Use Persistent RTMP Stream Key".localized
        label.font = appearance.font.getFont(forTypo: .h6)
        label.textColor = .white
        label.isSkeletonable = true
        label.linesCornerRadius = 3
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
        isSkeletonable = true
        addSubview(toggleImageView)
        addSubview(toggleTitleLabel)
        addSubview(actionButton)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            toggleImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            toggleImageView.widthAnchor.constraint(equalToConstant: 40),
            toggleImageView.heightAnchor.constraint(equalToConstant: 40),
            toggleImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            actionButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            actionButton.widthAnchor.constraint(equalToConstant: 40),
            actionButton.heightAnchor.constraint(equalToConstant: 40),
            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            toggleTitleLabel.leadingAnchor.constraint(equalTo: toggleImageView.trailingAnchor, constant: 10),
            toggleTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            toggleTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}
