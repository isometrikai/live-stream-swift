//
//  PKChallengeDurationCollectionViewCell.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 29/11/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import UIKit

class PKChallengeDurationCollectionViewCell: UICollectionViewCell {
    
    // MARK: - PROPERTIES
    
    override var isSelected: Bool {
        didSet {
            cardView.layer.borderColor = isSelected ? Appearance.default.colors.appColor.cgColor : Appearance.default.colors.appLightGray.withAlphaComponent(0.5).cgColor
            durationLabel.textColor = isSelected ? Appearance.default.colors.appColor : Appearance.default.colors.appLightGray
        }
    }
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = Appearance.default.colors.appLightGray.withAlphaComponent(0.5).cgColor
        view.layer.borderWidth = 1.5
        view.layer.cornerRadius = 20
        return view
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Appearance.default.colors.appLightGray
        label.text = "1 min"
        label.font = Appearance.default.font.getFont(forTypo: .h8)
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
        cardView.pin(to: self)
        durationLabel.pin(to: cardView)
    }
    
}
