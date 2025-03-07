//
//  CoinPlanCollectionViewCell.swift
//  
//
//  Created by Appscrip 3Embed on 03/07/24.
//

import UIKit
import IsometrikStream
import StoreKit
import SkeletonView

class CoinPlanCollectionViewCell: UICollectionViewCell, ISMAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    lazy var coverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.backgroundColor = appearance.colors.appLightGray
        view.isSkeletonable = true
        return view
    }()
    
    lazy var coinLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = appearance.colors.appSecondary
        label.font = appearance.font.getFont(forTypo: .h8)
        label.isSkeletonable = true
        label.isHiddenWhenSkeletonIsActive = true
        return label
    }()
    
    lazy var coinImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isSkeletonable = true
        imageView.skeletonCornerRadius = 8
        return imageView
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = appearance.colors.appSecondary
        label.font = appearance.font.getFont(forTypo: .h8)
        label.isSkeletonable = true
        label.isHiddenWhenSkeletonIsActive = true
        return label
    }()
    
    // MARK: MAIN -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        
        isSkeletonable = true
        contentView.isSkeletonable = true
        
        backgroundColor = .clear
        contentView.addSubview(coverView)
        coverView.addSubview(coinLabel)
        coverView.addSubview(coinImage)
        coverView.addSubview(amountLabel)
    }
    
    func setUpConstraints(){
        coverView.ism_pin(to: self)
        NSLayoutConstraint.activate([

            coinLabel.leadingAnchor.constraint(equalTo: coverView.leadingAnchor, constant: 8),
            coinLabel.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -8),
            coinLabel.topAnchor.constraint(equalTo: coverView.topAnchor, constant: 12),
            
            coinImage.centerXAnchor.constraint(equalTo: coverView.centerXAnchor),
            coinImage.centerYAnchor.constraint(equalTo: coverView.centerYAnchor),
            coinImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            coinImage.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            
            amountLabel.leadingAnchor.constraint(equalTo: coverView.leadingAnchor, constant: 8),
            amountLabel.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -8),
            amountLabel.bottomAnchor.constraint(equalTo: coverView.bottomAnchor, constant: -12),
        ])
    }
    
    func configureCell(data: ISMCoinPlan?, skProduct: SKProduct?){
        
        guard let data, let skProduct else { return }
        
        let numberOfUnits = data.numberOfUnits ?? 0
        let baseCurrencyValue = data.baseCurrencyValue ?? 0
        let baseCurrencySymbol = skProduct.priceLocale.currencySymbol ?? "$"
        
        coinLabel.text = "\(numberOfUnits) Coins"
        coinImage.image = appearance.images.goldPile2
        amountLabel.text = "\(baseCurrencySymbol)\(baseCurrencyValue)"
        
    }
    
}
