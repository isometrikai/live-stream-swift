//
//  PKBattleTimerView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 09/12/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import UIKit

class PKBattleTimerView: UIView, ISMStreamUIAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    lazy var coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = appearance.images.battleTimerOverlay
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = appearance.font.getFont(forTypo: .h8)
        label.textColor = appearance.colors.appYellow2
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
        addSubview(coverImage)
        addSubview(timerLabel)
    }
    
    func setupConstraints(){
        coverImage.ism_pin(to: self)
        NSLayoutConstraint.activate([
            timerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            timerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            timerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

}

