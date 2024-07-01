//
//  StreamUserProfileTableViewCell.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 09/02/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit

class StreamUserProfileOptionTableViewCell: UITableViewCell, AppearanceProvider {

    // MARK: - PROPERTIES
    
    var optionData: StreamUserProfileOptions? {
        didSet {
            manageData()
        }
    }
    
    let optionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var optionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = appearance.font.getFont(forTypo: .h4)
        label.textColor = .black
        return label
    }()
    
    
    // MARK: - MAIN
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        backgroundColor = .clear
        addSubview(optionImage)
        addSubview(optionLabel)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            optionImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            optionImage.widthAnchor.constraint(equalToConstant: 25),
            optionImage.heightAnchor.constraint(equalToConstant: 25),
            optionImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            optionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            optionLabel.leadingAnchor.constraint(equalTo: optionImage.trailingAnchor, constant: 15),
            optionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    func manageData(){
        guard let optionData else { return }
        optionImage.image = UIImage(named: "\(optionData.optionImage)")
        optionLabel.text = optionData.optionLabel
    }
}
