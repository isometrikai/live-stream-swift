//
//  PKChallengeDurationCollectionViewCell.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 29/11/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import UIKit

class PKChallengeDurationCollectionViewCell: UICollectionViewCell, ISMAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    override var isSelected: Bool {
        didSet {
            cardView.layer.borderColor = isSelected ? appearance.colors.appColor.cgColor : appearance.colors.appLightGray.withAlphaComponent(0.5).cgColor
            durationLabel.textColor = isSelected ? appearance.colors.appColor : appearance.colors.appLightGray
        }
    }
    
    lazy var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = appearance.colors.appLightGray.withAlphaComponent(0.5).cgColor
        view.layer.borderWidth = 1.5
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = appearance.colors.appLightGray
        label.text = "1 min"
        label.font = appearance.font.getFont(forTypo: .h8)
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
        addSubview(cardView)
        cardView.addSubview(durationLabel)
    }
    
    func setupConstraints(){
        cardView.ism_pin(to: self)
        durationLabel.ism_pin(to: cardView)
    }
    
}
