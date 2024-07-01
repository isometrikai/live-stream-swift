//
//  DefaultAddProductCollectionViewCell.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 07/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

class DefaultAddProductCollectionViewCell: UICollectionViewCell {
    
    // MARK: - PROPERTIES
    
    let defaultCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let defaultButtonImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = Appearance.default.images.add.withRenderingMode(.alwaysTemplate)
        image.tintColor = .white
        return image
    }()
    
    let defaultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add Products".localized
        label.font = Appearance.default.font.getFont(forTypo: .h8)
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
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        addSubview(defaultCoverView)
        defaultCoverView.addSubview(defaultButtonImage)
        defaultCoverView.addSubview(defaultLabel)
    }
    
    func setupConstraints(){
        defaultCoverView.pin(to: self)
        NSLayoutConstraint.activate([
            defaultButtonImage.centerYAnchor.constraint(equalTo: defaultCoverView.centerYAnchor, constant: -15),
            defaultButtonImage.centerXAnchor.constraint(equalTo: defaultCoverView.centerXAnchor),
            defaultButtonImage.heightAnchor.constraint(equalToConstant: 30),
            defaultButtonImage.widthAnchor.constraint(equalToConstant: 30),
            
            defaultLabel.centerYAnchor.constraint(equalTo: defaultCoverView.centerYAnchor, constant: 15),
            defaultLabel.centerXAnchor.constraint(equalTo: defaultCoverView.centerXAnchor)
        ])
    }
    
}
