//
//  StreamPinnedItemView.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 08/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit
import Kingfisher
import IsometrikStream

class StreamPinnedItemView: UIView, ISMStreamUIAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    let coverCardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    let updateFlagView: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        view.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return view
    }()
    
    let commissionFlag: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.setTitleColor(.white, for: .normal)
        view.isHidden = true
        return view
    }()
    
    // product Info
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return imageView
    }()
    
    let productInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var productCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Product Brand".localized
        
        label.font = appearance.font.getFont(forTypo: .h8)
        label.textColor = UIColor.colorWithHex(color: "#9797BE")
        
        return label
    }()
    
    lazy var productLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Product title".localized
        
        label.font = appearance.font.getFont(forTypo: .h8)
        label.textColor = .black
        
        return label
    }()
    
    lazy var priceInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        
        label.font = appearance.font.getFont(forTypo: .h8)
        label.textColor = .black
        
        return label
    }()
    
    //:
    
    let clickableAreaButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        return button
    }()
    
    // Timer view
    
    lazy var timerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("--:--", for: .normal)
        button.setImage(appearance.images.timer.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = appearance.colors.appColor
        button.titleLabel?.font = UIFont.monospacedSystemFont(ofSize: 13, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.backgroundColor = .black.withAlphaComponent(0.2)
        button.isHidden = true
        return button
    }()
    
    //:
    
    
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
        addSubview(coverCardView)
        coverCardView.addSubview(productImageView)
        coverCardView.addSubview(commissionFlag)
        
        coverCardView.addSubview(productInfoStackView)
        productInfoStackView.addArrangedSubview(productCategoryLabel)
        productInfoStackView.addArrangedSubview(productLabel)
        productInfoStackView.addArrangedSubview(priceInfoLabel)
        
        addSubview(updateFlagView)
        coverCardView.addSubview(clickableAreaButton)
    }
    
    func setupConstraints(){
        clickableAreaButton.ism_pin(to: self)
        NSLayoutConstraint.activate([
            
            coverCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            coverCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            coverCardView.topAnchor.constraint(equalTo: topAnchor),
            coverCardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            productImageView.leadingAnchor.constraint(equalTo: coverCardView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: coverCardView.trailingAnchor),
            productImageView.topAnchor.constraint(equalTo: coverCardView.topAnchor),
            productImageView.bottomAnchor.constraint(equalTo: productInfoStackView.topAnchor, constant: -5),
            
            productInfoStackView.leadingAnchor.constraint(equalTo: coverCardView.leadingAnchor, constant: 5),
            productInfoStackView.trailingAnchor.constraint(equalTo: coverCardView.trailingAnchor, constant: -5),
            productInfoStackView.bottomAnchor.constraint(equalTo: coverCardView.bottomAnchor, constant: -5),
            
            updateFlagView.leadingAnchor.constraint(equalTo: coverCardView.leadingAnchor),
            updateFlagView.topAnchor.constraint(equalTo: coverCardView.topAnchor),
            updateFlagView.heightAnchor.constraint(equalToConstant: 20),
            
            commissionFlag.leadingAnchor.constraint(equalTo: coverCardView.leadingAnchor),
            commissionFlag.trailingAnchor.constraint(equalTo: coverCardView.trailingAnchor),
            commissionFlag.heightAnchor.constraint(equalToConstant: 25),
            commissionFlag.bottomAnchor.constraint(equalTo: productInfoStackView.topAnchor)
            
//            timerButton.leadingAnchor.constraint(equalTo: leadingAnchor),
//            timerButton.trailingAnchor.constraint(equalTo: trailingAnchor),
//            timerButton.bottomAnchor.constraint(equalTo: bottomAnchor),
//            timerButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configureView(productData: StreamProductModel?, userType: StreamUserType = .viewer) {
        
        guard let productData else { return }
        
        let productName = productData.productName.unwrap
        let productBrandName = productData.brandName.unwrap
        let productImage = productData.images?.first?.medium ?? ""
        let currencySymbol = productData.currencySymbol.unwrap
        let productStoreId = productData.supplier?.id ?? ""
        let basePrice = productData.liveStreamfinalPriceList?.basePrice ?? 0
        let finalPrice = productData.liveStreamfinalPriceList?.finalPrice ?? 0
        let discountedPercentage = productData.liveStreamfinalPriceList?.discountPercentage ?? 0
        let isOutOfStock = productData.outOfStock ?? false
        
//        let resellerCommissionType = CommissionType(rawValue: productData.resellerCommissionType ?? 0)
        let resellerPercentageCommission = productData.resellerPercentageCommission ?? 0.0
        let resellerFixedCommission = productData.resellerFixedCommission ?? 0.0
        
        if let productImgURL = URL(string: productImage) {
            productImageView.kf.setImage(with: productImgURL)
        } else {
            productImageView.image = UIImage()
        }
        
        productLabel.text = productName
        productCategoryLabel.text = productBrandName.uppercased()
        
        if isOutOfStock {
            updateFlagView.isHidden = false
            updateFlagView.setTitle("out of stock".uppercased(), for: .normal)
            updateFlagView.titleLabel?.font = appearance.font.getFont(forTypo: .h8)
        } else {
            if discountedPercentage == 0 {
                updateFlagView.isHidden = true
                updateFlagView.setTitle("", for: .normal)
                updateFlagView.titleLabel?.font = appearance.font.getFont(forTypo: .h8)
                priceInfoLabel.text = "\(basePrice) \(currencySymbol)"
            } else {
                updateFlagView.isHidden = false
                updateFlagView.setTitle("\(discountedPercentage)% OFF", for: .normal)
                updateFlagView.titleLabel?.font = appearance.font.getFont(forTypo: .h8)
                priceInfoLabel.attributedText = priceAttributedTitle(symbol: currencySymbol, price: Double(finalPrice), orginalPrice: basePrice, discount: discountedPercentage)
            }
        }
        
        // Managing commision flag
        switch userType {
        case .host:
            
            // if product do not belong to streamer's store, no need to show commission, return
//            if productStoreId == Utility.getCurrentStoreId() {
//                return
//            }
            
//            commissionFlag.isHidden = false
//            var earnings = 0.0
//            if resellerCommissionType == .percentage {
//                earnings = (finalPrice * (Double(resellerPercentageCommission) / 100.0))
//            } else {
//                earnings = resellerFixedCommission
//            }
//            
//            if earnings != 0 {
//                commissionFlag.setAttributedTitle(earningAttributedText(earning: earnings, currencySymbol: currencySymbol), for: .normal)
//            } else {
//                commissionFlag.isHidden = true
//            }
            break
        default:
            commissionFlag.isHidden = true
        }
        
    }
    
    func priceAttributedTitle(symbol: String, price: Double , orginalPrice: Double, discount: Double) -> NSAttributedString {
        
        let originalPrice = String(format: "%.2f", orginalPrice)
        let price = String(format: "%.2f", price)
        
        let attribute1 = [
            NSAttributedString.Key.font: appearance.font.getFont(forTypo: .h7),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        let attribute2 = [
            NSAttributedString.Key.font: appearance.font.getFont(forTypo: .h7),
            NSAttributedString.Key.foregroundColor: UIColor.colorWithHex(color: "#BCBCE5")
        ]
        
        let attribute3 = [
            NSAttributedString.Key.font: appearance.font.getFont(forTypo: .h8),
            NSAttributedString.Key.foregroundColor: UIColor.colorWithHex(color: "#5FCF4C")
        ]
        
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSAttributedString(string: "\(price) \(symbol)", attributes: attribute1 as [NSAttributedString.Key : Any]))
        
        attributedString.append(NSAttributedString(string: " "))
        
        if orginalPrice != 0 {
            attributedString.append(NSAttributedString(string: "\(orginalPrice) \(symbol)", attributes: attribute2 as [NSAttributedString.Key : Any]).withStrikeThrough(1))
        }
        
        attributedString.append(NSAttributedString(string: " "))
        
        attributedString.append(NSAttributedString(string: "\(discount)% OFF", attributes: attribute3 as [NSAttributedString.Key : Any]))
        
        return attributedString
        
    }
    
    func earningAttributedText(earning: Double, currencySymbol: String) -> NSAttributedString {
        
        let earnings = String(format: "%.2f", earning)
        
        let attribute1 = [
            NSAttributedString.Key.font: appearance.font.getFont(forTypo: .h8),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        let attribute2 = [
            NSAttributedString.Key.font: appearance.font.getFont(forTypo: .h7),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSAttributedString(string: "You'll earn: ", attributes: attribute1 as [NSAttributedString.Key : Any]))
        attributedString.append(NSAttributedString(string: "\(earnings)\(currencySymbol)", attributes: attribute2 as [NSAttributedString.Key : Any]))
        
        return attributedString
        
    }
    
}
