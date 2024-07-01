//
//  StreamPinnedItemPriceActionView.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 08/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

class StreamPinnedItemPriceActionView: UIView {
    
    // MARK: - PROPERTIES
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        backgroundColor = Appearance.default.colors.appColor
        addSubview(priceLabel)
    }
    
    func setupConstraints(){
        priceLabel.pin(to: self)
    }
    
    func priceAttributedTitle(symbol: String, price: Double , orginalPrice: Double) -> NSAttributedString {
        
        let originalPrice = String(format: "%.2f", orginalPrice)
        let price = String(format: "%.2f", price)
        
        let attribute1 = [
            NSAttributedString.Key.font: Appearance.default.font.getFont(forTypo: .h7),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        let attribute2 = [
            NSAttributedString.Key.font: Appearance.default.font.getFont(forTypo: .h8),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        let attributedString = NSMutableAttributedString()
        if orginalPrice != 0 {
            attributedString.append(NSAttributedString(string: "\(orginalPrice) \(symbol)\n", attributes: attribute2 as [NSAttributedString.Key : Any]).withStrikeThrough(1))
        }
        
        attributedString.append(NSAttributedString(string: "\(price) \(symbol)", attributes: attribute1 as [NSAttributedString.Key : Any]))
    
        
        return attributedString
        
    }
    
    func bidAttributeTitle(symbol: String, price: Double, titleLabel: String) -> NSAttributedString {
        
        let attribute1 = [
            NSAttributedString.Key.font: Appearance.default.font.getFont(forTypo: .h7),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        let attribute2 = [
            NSAttributedString.Key.font: Appearance.default.font.getFont(forTypo: .h8),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: "\(titleLabel)\n", attributes: attribute2 as [NSAttributedString.Key : Any]))
        
        attributedString.append(NSAttributedString(string: "\(price) \(symbol)", attributes: attribute1 as [NSAttributedString.Key : Any]))
    
        
        return attributedString
        
    }
    
}
