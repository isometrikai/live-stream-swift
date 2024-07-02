//
//  StreamSettingOptionTableViewCell.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 09/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

class StreamSettingOptionTableViewCell: UITableViewCell, AppearanceProvider {

    // MARK: - PROPERTIES
    
    var data: StreamSettingData? {
        didSet {
            manageData()
        }
    }
    
    lazy var settingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = appearance.images.close.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        return imageView
    }()
    
    lazy var settingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = appearance.font.getFont(forTypo: .h6)
        label.textColor = .white
        return label
    }()
    
    // MARK: - MAIN
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        backgroundColor = .clear
        addSubview(settingImage)
        addSubview(settingLabel)
    }
    
    func setupContraints(){
        NSLayoutConstraint.activate([
            settingImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            settingImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            settingImage.widthAnchor.constraint(equalToConstant: 20),
            settingImage.heightAnchor.constraint(equalToConstant: 20),
            
            settingLabel.leadingAnchor.constraint(equalTo: settingImage.trailingAnchor, constant: 15),
            settingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            settingLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func manageData(){
        guard let data = data else {
            return
        }

        settingImage.image = data.settingImage
        settingLabel.text = data.settingLabel
        
    }
    
}
