//
//  RestreamOptionTableViewCell.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 11/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream
import SkeletonView

class RestreamOptionTableViewCell: UITableViewCell, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var restreamData: ISMRestreamChannel? {
        didSet {
            manageData()
        }
    }
    
    let optionHeader: GoLiveCustomToggleView = {
        let view = GoLiveCustomToggleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.activeColor = .black
        view.isSkeletonable = true
        return view
    }()

    lazy var trailingImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = appearance.images.arrowRight.withRenderingMode(.alwaysTemplate)
        image.tintColor = .black.withAlphaComponent(0.3)
        image.isSkeletonable = true
        return image
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
        backgroundColor = .clear
        isSkeletonable = true
        contentView.isSkeletonable = true
        contentView.addSubview(optionHeader)
        contentView.addSubview(trailingImage)
    }
    
    func setupConstraints(){
        optionHeader.ism_pin(to: self)
        NSLayoutConstraint.activate([
            trailingImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            trailingImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingImage.widthAnchor.constraint(equalToConstant: 30),
            trailingImage.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func manageData(){
        
        guard let restreamData else { return }
        
        optionHeader.toggleTitleLabel.text = "Stream on".localized + " \(restreamData.channelName.unwrap)"
        optionHeader.isSelected = restreamData.enabled ?? false
        
    }

}
