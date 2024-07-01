//
//  StoreListTableViewCell.swift
//  Shopr
//
//  Created by new user on 29/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import Kingfisher
import IsometrikStream

class StoreListTableViewCell: UITableViewCell, AppearanceProvider {
    
    // MARK: - PROPERTIES
    
    var data: StreamStoreModel? {
        didSet {
            manageData()
        }
    }
    
    let storeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 1
        imageView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        imageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var storeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = appearance.font.getFont(forTypo: .h6)
        return label
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.colorWithHex(color: "#9797BE")
        label.font = appearance.font.getFont(forTypo: .h8)
        return label
    }()
    
    lazy var trailingArrowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = appearance.images.arrowRight.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.colorWithHex(color: "#BCBCE5")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - MAIN
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        addSubview(storeImage)
        
        addSubview(infoStackView)
        infoStackView.addArrangedSubview(storeNameLabel)
        infoStackView.addArrangedSubview(userNameLabel)
        
        addSubview(trailingArrowImage)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            storeImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            storeImage.widthAnchor.constraint(equalToConstant: 40),
            storeImage.heightAnchor.constraint(equalToConstant: 40),
            storeImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            infoStackView.leadingAnchor.constraint(equalTo: storeImage.trailingAnchor, constant: 15),
            infoStackView.trailingAnchor.constraint(equalTo: trailingArrowImage.leadingAnchor, constant: -15),
            infoStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            trailingArrowImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            trailingArrowImage.widthAnchor.constraint(equalToConstant: 15),
            trailingArrowImage.heightAnchor.constraint(equalToConstant: 15),
            trailingArrowImage.centerYAnchor.constraint(equalTo: centerYAnchor)
             
        ])
    }
    
    func manageData(){
        
        guard let data else { return }
        
        let imageString = data.storeLogo?.logoImageMobile ?? ""
        let storeName = data.storeName ?? ""
        let userName = data.userName ?? ""
        
        if let imageURL = URL(string: imageString) {
            storeImage.kf.setImage(with: imageURL)
        } else {
            storeImage.image = UIImage()
        }
        
        storeNameLabel.text = storeName
        userNameLabel.text = "@\(userName)"
        
    }
    
}
