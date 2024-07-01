//
//  PKPunishmentBannerView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 05/12/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import UIKit

class PKPunishmentBannerView: UIView {

    // MARK: - PROPERTIES
    
    let bannerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Appearance.default.colors.appCyan
        view.layer.cornerRadius = 10
        return view
    }()
    
    let punishmentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = Appearance.default.font.getFont(forTypo: .h8)
        label.text = "Taking Punishment : Loser accept punishment from winner".localized
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
        addSubview(bannerView)
        addSubview(punishmentLabel)
    }
    
    func setupConstraints(){
        
        NSLayoutConstraint.activate([
            punishmentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            punishmentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            punishmentLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            bannerView.leadingAnchor.constraint(equalTo: punishmentLabel.leadingAnchor, constant: -10),
            bannerView.trailingAnchor.constraint(equalTo: punishmentLabel.trailingAnchor, constant: 10),
            bannerView.heightAnchor.constraint(equalToConstant: 20),
            bannerView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
    }

}
