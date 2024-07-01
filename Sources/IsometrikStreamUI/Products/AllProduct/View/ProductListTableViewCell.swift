//
//  ProductListTableViewCell.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 25/10/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import Kingfisher
import IsometrikStream

protocol ProductListActionDelegate {
    func didActionButtonTapped(index: Int)
}

class ProductListTableViewCell: UITableViewCell, AppearanceProvider {

    // MARK: - PROPERTIES
    
    var myStore: Bool = false
    var isOfferEditable: Bool = false
    
    var delegate: ProductListActionDelegate?
    var productData: StreamProductModel? {
        didSet {
            manageData()
        }
    }
    
    let productCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let productImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        image.backgroundColor = .lightGray.withAlphaComponent(0.2)
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    
    let offerBannerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.isHidden = true
        return view
    }()
    
    let offerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
//        Fonts.setFont(label, fontFamiy: .monstserrat(.Medium), size: .custom(10) ,color: .white)
        label.textAlignment = .center
        return label
    }()
    
    // - product info label
    
    let productInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    let productCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        Fonts.setFont(label, fontFamiy: .monstserrat(.Regular), size: .custom(11), color: UIColor.colorWithHex(color: "#9797BE"))
        return label
    }()
    
    let productTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        Fonts.setFont(label, fontFamiy: .monstserrat(.Medium), size: .custom(13), color: .black)
        return label
    }()
    
    let productPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        Fonts.setFont(label, fontFamiy: .monstserrat(.Bold), size: .custom(14), color: .black)
        return label
    }()
    
    //:
    
    // Earning label
    
    let earningLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    //:
    
    let checkBoxImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Discount".localized, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h8)
        button.setTitleColor(UIColor.colorWithHex(color: "#EA5C03"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
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
        
        addSubview(productCoverView)
        productCoverView.addSubview(productImage)
        productCoverView.addSubview(offerBannerView)
        offerBannerView.addSubview(offerLabel)
        
        addSubview(productInfoStackView)
        productInfoStackView.addArrangedSubview(productCategoryLabel)
        productInfoStackView.addArrangedSubview(productTitle)
        productInfoStackView.addArrangedSubview(productPrice)
        
        addSubview(checkBoxImage)
        addSubview(actionButton)
        
        addSubview(earningLabel)
    }
    
    func setupConstraints(){
        productImage.ism_pin(to: productCoverView)
        NSLayoutConstraint.activate([
            
            productCoverView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            productCoverView.heightAnchor.constraint(equalToConstant: 80),
            productCoverView.widthAnchor.constraint(equalToConstant: 80),
            productCoverView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            offerBannerView.leadingAnchor.constraint(equalTo: productCoverView.leadingAnchor),
            offerBannerView.trailingAnchor.constraint(equalTo: productCoverView.trailingAnchor),
            offerBannerView.bottomAnchor.constraint(equalTo: productCoverView.bottomAnchor),
            offerBannerView.heightAnchor.constraint(equalToConstant: 22),
            
            offerLabel.centerYAnchor.constraint(equalTo: offerBannerView.centerYAnchor),
            offerLabel.centerXAnchor.constraint(equalTo: offerBannerView.centerXAnchor),
            
            productInfoStackView.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 10),
            productInfoStackView.trailingAnchor.constraint(equalTo: checkBoxImage.leadingAnchor, constant: -10),
            productInfoStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            productPrice.heightAnchor.constraint(equalToConstant: 40),
            
            checkBoxImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            checkBoxImage.widthAnchor.constraint(equalToConstant: 20),
            checkBoxImage.heightAnchor.constraint(equalToConstant: 20),
            checkBoxImage.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            actionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            earningLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            earningLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - ACTIONS
    
    func manageData(){
        guard let productData else { return }
        
        let productCategory = productData.brandName ?? ""
        let productName = productData.productName ?? ""
        let imageStringUrl = productData.images?.first?.medium ?? ""
        let currencySymbol = productData.currencySymbol ?? ""
        let finalPrice = productData.liveStreamfinalPriceList?.finalPrice ?? 0
        var originalPrice = productData.liveStreamfinalPriceList?.basePrice ?? 0
        let discountType = StreamProductDiscountType(rawValue: productData.liveStreamfinalPriceList?.discountType ?? 0)
        let msrpPrice = productData.liveStreamfinalPriceList?.msrpPrice ?? 0
        let discountedPercentage = productData.liveStreamfinalPriceList?.discountPercentage ?? 0
        let previousDiscount = productData.liveStreamfinalPriceList?.discount ?? 0
//        let resellerCommissionType = CommissionType(rawValue: productData.resellerCommissionType ?? 0)
        let resellerPercentageCommission = productData.resellerPercentageCommission ?? 0.0
        let resellerFixedCommission = productData.resellerFixedCommission ?? 0.0
//        let isStoreIdMatches = (productData.supplier?.id == Utility.getCurrentStoreId())
        
        if let imageUrl = URL(string: imageStringUrl) {
            productImage.kf.setImage(with: imageUrl)
        }
        
        productCategoryLabel.text = productCategory.uppercased()
        productTitle.text = productName
        
//        if !myStore && !isStoreIdMatches {
//            
//            earningLabel.isHidden = false
//            var earnings = 0.0
//            if resellerCommissionType == .percentage {
//                earnings = resellerPercentageCommission
//            } else {
//                earnings = resellerFixedCommission
//            }
//            
//            if earnings == 0 {
//                normalPricingFlow()
//                earningLabel.isHidden = true
//            } else {
//                earningLabel.attributedText = self.earningAttributeText(earning: earnings, currencySymbol: currencySymbol , isPercentage: resellerCommissionType == .percentage)
//            }
//            
//        } else {
//            earningLabel.isHidden = true
//        }
        
        normalPricingFlow()
        
        func normalPricingFlow(){
            
            if discountedPercentage == 0 {
                
                if previousDiscount != 0 && msrpPrice != 0 {
                    
                    let price = msrpPrice - (msrpPrice * (Double(previousDiscount) / 100.0))
                    productPrice.attributedText = priceAttributedTitle(symbol: currencySymbol, price: Double(price), orginalPrice: Double(msrpPrice), discount: previousDiscount)
                    offerLabel.text = "\(previousDiscount)% OFF"
                    offerBannerView.isHidden = false
                    
                } else if previousDiscount != 0 && msrpPrice == 0 {
                        
                    let price = originalPrice - (originalPrice * (Double(previousDiscount) / 100.0))
                    productPrice.attributedText = priceAttributedTitle(symbol: currencySymbol, price: Double(price), orginalPrice: Double(originalPrice), discount: previousDiscount)
                    offerLabel.text = "\(previousDiscount)% OFF"
                    offerBannerView.isHidden = false
                    
                } else {
                    productPrice.text = String(format: "%.2f", finalPrice) + "\(currencySymbol)"
                    offerBannerView.isHidden = true
                }
                
                actionButton.setTitle("Add Discount".localized, for: .normal)
                actionButton.setTitleColor(UIColor.colorWithHex(color: "#0A11D5"), for: .normal)
                
            } else {
                
                if originalPrice == 0 {
                    originalPrice = msrpPrice
                }
                
                let price = originalPrice - (originalPrice * (Double(discountedPercentage) / 100.0))
                productPrice.attributedText = priceAttributedTitle(symbol: currencySymbol, price: Double(price), orginalPrice: Double(originalPrice), discount: discountedPercentage)
                offerLabel.text = "\(discountedPercentage)% OFF"
                
                offerBannerView.isHidden = false
                
                actionButton.setTitle(isOfferEditable ? "Update Discount".localized : "Remove Discount".localized, for: .normal)
                actionButton.setTitleColor(UIColor.colorWithHex(color: isOfferEditable ? "#0A11D5" : "#D83707"), for: .normal)
            }
        }
        
        checkBoxImage.image =  productData.isSelected ? appearance.images.checkedCheckbox : appearance.images.uncheckedCheckbox
        
        if myStore {
            actionButton.isHidden = productData.isSelected ? false : true
        } else {
            actionButton.isHidden = true
        }
        
        
    }
    
    func priceAttributedTitle(symbol: String, price: Double , orginalPrice: Double, discount: Double) -> NSAttributedString {
        
        let origPrice = String(format: "%.2f", orginalPrice)
        let price = String(format: "%.2f", price)
        
        let attribute1 = [
            NSAttributedString.Key.font: appearance.font.getFont(forTypo: .h6),
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
            attributedString.append(NSAttributedString(string: "\(origPrice) \(symbol)", attributes: attribute2 as [NSAttributedString.Key : Any]).withStrikeThrough(1))
        }
        
        attributedString.append(NSAttributedString(string: " "))
         
        //attributedString.append(NSAttributedString(string: "\(discount)% OFF", attributes: attribute3 as [NSAttributedString.Key : Any]))
        
        return attributedString
        
    }
    
    func earningAttributeText(earning: Double, currencySymbol: String, isPercentage: Bool) -> NSAttributedString {
        
        let earnings = earning.clean
        
        let attribute1 = [
            NSAttributedString.Key.font: appearance.font.getFont(forTypo: .h8),
            NSAttributedString.Key.foregroundColor: appearance.colors.appGreen
        ]
        
        let attribute2 = [
            NSAttributedString.Key.font: appearance.font.getFont(forTypo: .h7),
            NSAttributedString.Key.foregroundColor: appearance.colors.appGreen
        ]
        
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSAttributedString(string: "You'll earn: ", attributes: attribute1 as [NSAttributedString.Key : Any]))
        attributedString.append(NSAttributedString(string: isPercentage ? "\(earnings)%" : "\(earnings)  \(currencySymbol)", attributes: attribute2 as [NSAttributedString.Key : Any]))
        
        return attributedString
        
    }
    
    @objc func actionButtonTapped(){
        delegate?.didActionButtonTapped(index: self.tag)
    }
}
