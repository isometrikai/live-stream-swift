//
//  StreamDeletedMessageTableViewCell.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 10/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

class StreamDeleteMessageTableViewCell: UITableViewCell, AppearanceProvider {

    // MARK: - PROPERTIES
    
    var data: ISMComment? {
        didSet {
            manageData()
        }
    }
    
    lazy var defaultImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 15
        image.image = appearance.images.removeCircle
        return image
    }()
    
    lazy var backCardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = appearance.colors.appRed.withAlphaComponent(0.3)
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white.withAlphaComponent(0.8)
        label.font = appearance.font.getFont(forTypo: .h8)
        label.numberOfLines = 0
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
        addSubview(backCardView)
        addSubview(defaultImage)
        addSubview(infoLabel)
    }
    
    func setupContraints(){
        NSLayoutConstraint.activate([
            
            backCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backCardView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            backCardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            defaultImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            defaultImage.widthAnchor.constraint(equalToConstant: 30),
            defaultImage.heightAnchor.constraint(equalToConstant: 30),
            defaultImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            infoLabel.leadingAnchor.constraint(equalTo: defaultImage.trailingAnchor, constant: 5),
            infoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            infoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            infoLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
            
        ])
    }
    
    func manageData(){
        guard let data = data else {
            return
        }
        
        let deletionTime = data.deletionTime
        
        let deletionTimeStamp = TimeInterval((deletionTime ?? 0)/1000)
        let deletionDate = Date(timeIntervalSince1970: deletionTimeStamp)
        let timeOfDeletion = deletionDate.ism_getCustomMessageTime()
        
        let sentAt = data.sentAt
        
        let timeStamp = TimeInterval((sentAt ?? 0)/1000)
        let date = Date(timeIntervalSince1970: timeStamp)
        let time = date.ism_getCustomMessageTime()
        
        infoLabel.text = "The message has been removed by".localized + " \(data.streamInfo?.initiatorName ?? "")" + " \(timeOfDeletion)"
        
    }

}
