//
//  CoinPlanCollectionViewCell.swift
//  
//
//  Created by Appscrip 3Embed on 03/07/24.
//

import UIKit
import IsometrikStream

class CoinPlanCollectionViewCell: UICollectionViewCell, AppearanceProvider {
    
    // MARK: - PROPERTIES
    
    lazy var coverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.backgroundColor = appearance.colors.appLightGray
        return view
    }()
    
    lazy var coinLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = appearance.colors.appSecondary
        label.font = appearance.font.getFont(forTypo: .h8)
        return label
    }()
    
    lazy var coinImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = appearance.images.coin
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = appearance.colors.appSecondary
        label.font = appearance.font.getFont(forTypo: .h8)
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
        backgroundColor = .clear
        addSubview(coverView)
        addSubview(coinLabel)
        addSubview(coinImage)
        addSubview(amountLabel)
    }
    
    func setUpConstraints(){
        coverView.ism_pin(to: self)
        NSLayoutConstraint.activate([

            coinLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            coinLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            coinLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            
            coinImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            coinImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            coinImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            coinImage.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            
            amountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            amountLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }
    
    func configureCell(data: CoinPlan?){
        
        guard let data else { return }
        
        let numberOfUnits = data.numberOfUnits ?? 0
        let baseCurrencyValue = data.baseCurrencyValue ?? 0
        let baseCurrencySymbol = data.baseCurrencySymbol ?? ""
        
        coinLabel.text = "\(numberOfUnits) Coins"
        amountLabel.text = "\(baseCurrencySymbol)\(baseCurrencyValue)"
        
    }
    
}
