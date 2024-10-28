//
//  File.swift
//  
//
//  Created by Appscrip 3Embed on 10/07/24.
//

import UIKit
import IsometrikStream
import SkeletonView

class ISMWalletBalanceHeaderView: UIView, ISMAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    lazy var featureStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.layer.borderColor = appearance.colors.appLightGray.cgColor
        stackView.layer.borderWidth = 1
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true
        stackView.backgroundColor = appearance.colors.appLightGray
        stackView.isSkeletonable = true
        return stackView
    }()
    
    lazy var coinFeatureView: BalanceFeatureView = {
        let view = BalanceFeatureView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.featureTitleLabel.text = "Total Coins"
        view.featureSubtitleImageView.image = appearance.images.coin
        view.featureActionButton.tag = ISMWalletCurrencyType.coin.rawValue
        view.backgroundColor = .white
        view.isSkeletonable = true
        return view
    }()
    
    lazy var moneyFeatureView: BalanceFeatureView = {
        let view = BalanceFeatureView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.featureTitleLabel.text = "Total Money"
        view.featureSubtitleImageView.image = appearance.images.walletMoney
        view.featureActionButton.tag = ISMWalletCurrencyType.money.rawValue
        view.backgroundColor = .white
        view.isSkeletonable = true
        return view
    }()
    
    public let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return view
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
        
        addSubview(featureStackView)
        featureStackView.addArrangedSubview(coinFeatureView)
        featureStackView.addArrangedSubview(moneyFeatureView)
        
        addSubview(dividerView)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            
            featureStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            featureStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            featureStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            coinFeatureView.heightAnchor.constraint(equalToConstant: 75),
            moneyFeatureView.heightAnchor.constraint(equalToConstant: 75),
            
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func configureView(balanceData: ISMWalletBalance?, currencyType: ISMWalletCurrencyType){
        
        // if balanceData is nil
        guard let balanceData else {
            
            let balance = UserDefaultsProvider.shared.getWalletBalance(currencyType: currencyType.getValue)
            
            switch currencyType {
            case .coin:
                coinFeatureView.featureSubtitle.text = "\(Int64(balance))"
                break
            case .money:
                moneyFeatureView.featureSubtitle.text = "$" + Double(balance).formattedWithSuffix(fractionDigits: 1)
                break
            }
            
            return
        }
        
        
        let balance = balanceData.balance.unwrap
        let currencySymbol = balanceData.currencySymbol.unwrap
        
        switch currencyType {
        case .coin:
            coinFeatureView.featureSubtitle.text = "\(Int64(balance))"
            break
        case .money:
            moneyFeatureView.featureSubtitle.text = "\(currencySymbol)" + Double(balance).formattedWithSuffix(fractionDigits: 1)
            break
        }
        
    }
    
}


class BalanceFeatureView: UIView, ISMAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.isSkeletonable = true
        return stackView
    }()
    
    lazy var featureTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = appearance.colors.appGray
        label.font = appearance.font.getFont(forTypo: .h8)
        label.isSkeletonable = true
        label.linesCornerRadius = 5
        return label
    }()
    
    let featureSubtitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.isSkeletonable = true
        return stackView
    }()
    
    let featureSubtitleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isSkeletonable = true
        imageView.skeletonCornerRadius = 12.5
        return imageView
    }()
    
    lazy var featureSubtitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = appearance.font.getFont(forTypo: .h3)
        label.isSkeletonable = true
        label.linesCornerRadius = 5
        label.lastLineFillPercent = 60
        return label
    }()
    
    lazy var featureActionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Transactions", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        button.backgroundColor = appearance.colors.appColor
        button.setTitleColor(appearance.colors.appSecondary, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h6)
        button.layer.cornerRadius = 17.5
        button.isSkeletonable = true
        button.isHiddenWhenSkeletonIsActive = true
        return button
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
        addSubview(infoStackView)
        infoStackView.addArrangedSubview(featureTitleLabel)
        infoStackView.addArrangedSubview(featureSubtitleStackView)
        
        featureSubtitleStackView.addArrangedSubview(featureSubtitleImageView)
        featureSubtitleStackView.addArrangedSubview(featureSubtitle)
        addSubview(featureActionButton)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            infoStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            infoStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            infoStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            featureSubtitleImageView.widthAnchor.constraint(equalToConstant: 25),
            featureSubtitleImageView.heightAnchor.constraint(equalToConstant: 25),
            
            featureActionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            featureActionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            featureActionButton.heightAnchor.constraint(equalToConstant: 35),
        ])
    }
    
}
