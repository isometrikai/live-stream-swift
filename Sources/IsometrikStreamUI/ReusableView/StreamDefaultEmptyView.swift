//
//  StreamDefaultEmptyView.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 08/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

class StreamDefaultEmptyView: UIView, AppearanceProvider {

    // MARK: - PROPERTIES
    
    let defaultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var defaultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "No Data Found".localized
        
        label.font = appearance.font.getFont(forTypo: .h6)
        label.textColor = .black
        
        label.textAlignment = .center
        label.numberOfLines = 0
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
        addSubview(defaultImageView)
        addSubview(defaultLabel)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            defaultImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            defaultImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40),
            defaultImageView.widthAnchor.constraint(equalToConstant: 150),
            defaultImageView.heightAnchor.constraint(equalToConstant: 150),
            
            defaultLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            defaultLabel.topAnchor.constraint(equalTo: defaultImageView.bottomAnchor, constant: 15),
            defaultLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            defaultLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
        ])
    }

}
