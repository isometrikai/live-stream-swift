//
//  StreamingInfoMessageView.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 15/12/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

class StreamingInfoMessageView: UIView, AppearanceProvider {

    // MARK: - PROPERTIES
    var messageData: ISMComment? {
        didSet {
            manageData()
        }
    }
    
    let defaultImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 15
        return image
    }()
    
    lazy var backCardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = appearance.colors.appColor
        view.layer.cornerRadius = 10
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        backgroundColor = .clear
        addSubview(defaultImage)
        addSubview(infoLabel)
    }
    
    func setupContraints(){
        NSLayoutConstraint.activate([
            defaultImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            defaultImage.widthAnchor.constraint(equalToConstant: 30),
            defaultImage.heightAnchor.constraint(equalToConstant: 30),
            defaultImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            infoLabel.leadingAnchor.constraint(equalTo: defaultImage.trailingAnchor, constant: 5),
            infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            infoLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
        ])
    }
    
    func manageData(){
        
        guard let data = messageData else {
            return
        }
        
        infoLabel.alpha = 0
        defaultImage.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            
            self.infoLabel.alpha = 1
            self.defaultImage.alpha = 1
            
            self.infoLabel.text = data.message
            self.defaultImage.image = UIImage(named: "\(data.senderImage ?? "")")?.withRenderingMode(.alwaysTemplate)
            self.defaultImage.tintColor = .white
            
        }
        
    }

}
