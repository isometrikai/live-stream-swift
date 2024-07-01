//
//  PKRefuseInvitationView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 01/12/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import UIKit

class PKRefuseInvitationView: UIView {
    
    // MARK: - PROPERTIES
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Refuse all invitations".localized
        label.textColor = .white
        label.font = Appearance.default.font.getFont(forTypo: .h6)
        return label
    }()
    
    let toggleSwitch: UISwitch = {
        let toggleView = UISwitch()
        toggleView.translatesAutoresizingMaskIntoConstraints = false
        toggleView.isOn = false
        toggleView.onTintColor = Appearance.default.colors.appColor
        return toggleView
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
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(toggleSwitch)
        addSubview(dividerView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: toggleSwitch.leadingAnchor, constant: -10),
            
            toggleSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            toggleSwitch.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.topAnchor.constraint(equalTo: topAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
}
