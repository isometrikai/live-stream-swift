//
//  MoreSettingTableViewCell.swift
//  
//
//  Created by Appscrip 3Embed on 09/07/24.
//

import UIKit

class MoreSettingTableViewCell: UITableViewCell, AppearanceProvider {

    // MARK: - PROPERTIES
    
    var data: StreamSettingData? {
        didSet {
            manageData()
        }
    }
    
    let settingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var settingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h6)
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
        settingLabel.textColor = data.labelColor
        
        settingImage.tintColor = data.labelColor
        
    }
}
