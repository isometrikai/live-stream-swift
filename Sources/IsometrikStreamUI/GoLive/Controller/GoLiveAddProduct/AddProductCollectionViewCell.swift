//
//  ProductCollectionViewCell.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 23/10/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

protocol AddProductActionDelegate {
    func didClearTapped(index: Int)
}

class AddProductCollectionViewCell: UICollectionViewCell, AppearanceProvider {
    
    // MARK: - PROPERTIES
    
    var delegate: AddProductActionDelegate?
    
    var data: StreamProductModel? {
        didSet {
            manageData()
        }
    }
    
    let productCardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        view.layer.borderWidth = 0.7
        view.layer.cornerRadius = 15
        view.backgroundColor = .white
        return view
    }()
    
    let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        imageView.layer.cornerRadius = 15
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
        label.text = "Product Brand".localized
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = appearance.font.getFont(forTypo: .h7)
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
        label.text = ""
        label.numberOfLines = 2
        label.font = appearance.font.getFont(forTypo: .h5)
        label.textColor = .black
        return label
    }()
    
    lazy var clearButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.close, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 11
        button.ismTapFeedBack()
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let commissionFlag: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.setTitleColor(.white, for: .normal)
        view.isEnabled = false
        view.isHidden = true
        return view
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
        backgroundColor = .clear
        
        addSubview(productCardView)
        productCardView.addSubview(productImage)
        productCardView.addSubview(commissionFlag)
        
        productCardView.addSubview(productInfoStackView)
        productInfoStackView.addArrangedSubview(productCategoryLabel)
        productInfoStackView.addArrangedSubview(productLabel)
        productInfoStackView.addArrangedSubview(priceInfoLabel)
        
        productCardView.addSubview(clearButton)

    }
    
    func setupConstraints(){
        productCardView.ism_pin(to: self)
        NSLayoutConstraint.activate([
            
            productImage.leadingAnchor.constraint(equalTo: productCardView.leadingAnchor),
            productImage.trailingAnchor.constraint(equalTo: productCardView.trailingAnchor),
            productImage.topAnchor.constraint(equalTo: productCardView.topAnchor),
            productImage.bottomAnchor.constraint(equalTo: productInfoStackView.topAnchor, constant: -8),
            
            productInfoStackView.leadingAnchor.constraint(equalTo: productCardView.leadingAnchor, constant: 8),
            productInfoStackView.trailingAnchor.constraint(equalTo: productCardView.trailingAnchor, constant: -8),
            productInfoStackView.bottomAnchor.constraint(equalTo: productCardView.bottomAnchor, constant: -8),
            productInfoStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 15),
            
            clearButton.trailingAnchor.constraint(equalTo: productCardView.trailingAnchor, constant: -10),
            clearButton.topAnchor.constraint(equalTo: productCardView.topAnchor, constant: 10),
            clearButton.heightAnchor.constraint(equalToConstant: 22),
            clearButton.widthAnchor.constraint(equalToConstant: 22),
            
            commissionFlag.leadingAnchor.constraint(equalTo: productCardView.leadingAnchor),
            commissionFlag.trailingAnchor.constraint(equalTo: productCardView.trailingAnchor),
            commissionFlag.heightAnchor.constraint(equalToConstant: 25),
            commissionFlag.bottomAnchor.constraint(equalTo: productInfoStackView.topAnchor)
            
        ])
    }
    
    func manageData(){
        guard let productData = data else { return }
        
        let productStoreId = productData.supplier?.id ?? ""
        let productCategory = productData.brandName ?? ""
        let productName = productData.productName ?? ""
        var originalPrice = productData.liveStreamfinalPriceList?.basePrice ?? 0
        let imageStringUrl = productData.images?.first?.medium ?? ""
        let currencySymbol = productData.currencySymbol ?? ""
        let finalPrice = productData.liveStreamfinalPriceList?.finalPrice ?? 0
        let discountType = StreamProductDiscountType(rawValue: productData.liveStreamfinalPriceList?.discountType ?? 0)
        let msrpPrice = productData.liveStreamfinalPriceList?.msrpPrice ?? 0
        let discountedPercentage = productData.liveStreamfinalPriceList?.discountPercentage ?? 0
        let previousDiscount = productData.liveStreamfinalPriceList?.discount ?? 0
//        let resellerCommissionType = CommissionType(rawValue: productData.resellerCommissionType ?? 0)
        let resellerPercentageCommission = productData.resellerPercentageCommission ?? 0.0
        let resellerFixedCommission = productData.resellerFixedCommission ?? 0.0
        
        // -------
        
        if let imageUrl = URL(string: imageStringUrl) {
            productImage.kf.setImage(with: imageUrl)
        } else {
            productImage.image = UIImage()
        }
        
        productCategoryLabel.text = productCategory.uppercased()
        productLabel.text = productName
        
        // if product belong to streamer's store, myStore will become true
//        let myStore = (productStoreId == Utility.getCurrentStoreId())
       
//        if !myStore {
//            commissionFlag.isHidden = false
//            var earnings = 0.0
//            if resellerCommissionType == .percentage {
//                earnings = (finalPrice * (Double(resellerPercentageCommission) / 100.0))
//            } else {
//                earnings = resellerFixedCommission
//            }
//            
//            if earnings == 0 {
//                normalPricingFlow()
//                commissionFlag.isHidden = true
//            } else {
//                commissionFlag.setAttributedTitle(earningAttributedText(earning: earnings, currencySymbol: currencySymbol), for: .normal)
//            }
//        } else {
//            commissionFlag.isHidden = true
//        }
        
        
        normalPricingFlow()
        
        func normalPricingFlow(){
            
            if discountedPercentage == 0 {
                
                if previousDiscount != 0 && msrpPrice != 0 {
                    let price = msrpPrice - (msrpPrice * (Double(previousDiscount) / 100.0))
                    priceInfoLabel.attributedText = priceAttributedTitle(symbol: currencySymbol, price: Double(price), orginalPrice: Double(msrpPrice), discount: previousDiscount)
                    
                } else if previousDiscount != 0 && msrpPrice == 0 {
                    
                    let price = originalPrice - (originalPrice * (Double(previousDiscount) / 100.0))
                    priceInfoLabel.attributedText = priceAttributedTitle(symbol: currencySymbol, price: Double(price), orginalPrice: Double(originalPrice), discount: previousDiscount)
                    
                } else {
                    priceInfoLabel.text = String(format: "%.2f", finalPrice) + "\(currencySymbol)"
                }
                
            } else {
                
                if originalPrice == 0 {
                    originalPrice = msrpPrice
                }
                
                let price = originalPrice - (originalPrice * (Double(discountedPercentage) / 100.0))
                priceInfoLabel.attributedText = priceAttributedTitle(symbol: currencySymbol, price: Double(price), orginalPrice: Double(originalPrice), discount: discountedPercentage)
                
            }
        }
        
    }
    
    func priceAttributedTitle(symbol: String, price: Double , orginalPrice: Double, discount: Double) -> NSAttributedString {
        
        let originalPrice = String(format: "%.2f", orginalPrice)
        let price = String(format: "%.2f", price)
        
        let attribute1 = [
            NSAttributedString.Key.font: appearance.font.getFont(forTypo: .h5),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        let attribute2 = [
            NSAttributedString.Key.font: appearance.font.getFont(forTypo: .h6),
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
        
        attributedString.append(NSAttributedString(string: "\n"))
        
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
    
    // MARK: - Actions
    
    @objc func clearButtonTapped(){
        delegate?.didClearTapped(index: self.tag)
    }
    
}
