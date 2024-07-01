//
//  PKCongratulationBannerView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 05/12/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import UIKit

class PKCongratulationBannerView: UIView, AppearanceProvider {

    // MARK: - PROPERTIES
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h8)
        label.text = "Congratulation to @tannvi"
        label.textAlignment = .center
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
        backgroundColor = appearance.colors.appPink
        addSubview(titleLabel)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

}
