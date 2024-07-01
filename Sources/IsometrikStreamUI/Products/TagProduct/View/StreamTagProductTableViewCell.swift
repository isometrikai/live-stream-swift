//
//  StreamTagProductTableViewCell.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 21/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import Kingfisher
import IsometrikStream

protocol TaggedProductDelegate {
    func didPinItemTapped(index: Int)
}

class StreamTagProductTableViewCell: UITableViewCell {

    // MARK: - PROPERTIES
    
    var productViewModel: ProductViewModel?
    var delegate: TaggedProductDelegate?
    var productData: StreamProductModel? {
        didSet {
            manageData()
        }
    }
    
    let productImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .lightGray.withAlphaComponent(0.3)
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
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
    
    lazy var pinItemButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Pin Item".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Appearance.default.font.getFont(forTypo: .h7)
        button.ismTapFeedBack()
        button.backgroundColor = .black
        button.layer.cornerRadius = 15
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        button.addTarget(self, action: #selector(pinItemButtonTapped), for: .touchUpInside)
        button.layer.borderColor = UIColor.black.cgColor
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
        backgroundColor = .clear
        addSubview(productImage)
        
        addSubview(productInfoStackView)
        productInfoStackView.addArrangedSubview(productTitle)
        productInfoStackView.addArrangedSubview(productPrice)
        
        addSubview(pinItemButton)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            productImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            productImage.heightAnchor.constraint(equalToConstant: 80),
            productImage.widthAnchor.constraint(equalToConstant: 80),
            productImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            productInfoStackView.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 10),
            productInfoStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            productInfoStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            
            productPrice.heightAnchor.constraint(equalToConstant: 15),
            
            pinItemButton.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 10),
            pinItemButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            pinItemButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func manageData(){
        
        guard let productData, let productViewModel else { return }
        
        let productName = productData.productName ?? ""
        let imageStringUrl = productData.images?.first?.medium ?? ""
        let currencySymbol = productData.currencySymbol ?? ""
        
        let storeId = productData.supplier?.id ?? ""
        var originalPrice: Double = 0
        var finalPrice: Double = 0
        var discountedPercentage: Double = 0
        
        originalPrice = productData.liveStreamfinalPriceList?.basePrice ?? 0
        finalPrice = productData.liveStreamfinalPriceList?.finalPrice ?? 0
        discountedPercentage = productData.liveStreamfinalPriceList?.discountPercentage ?? 0
        
        
        if let imageUrl = URL(string: imageStringUrl) {
            productImage.kf.setImage(with: imageUrl)
        }
        productTitle.text = productName
        
        if discountedPercentage == 0 {
            productPrice.text = "\(originalPrice) \(currencySymbol)"
        } else {
            productPrice.attributedText = priceAttributedTitle(symbol: currencySymbol, price: Double(finalPrice), orginalPrice: Double(originalPrice), discount: discountedPercentage)
        }
        
        
        // change the pinned item status
        
        guard let pinnedProductData = productViewModel.pinnedProductData else { return }
        if pinnedProductData.childProductID == productData.childProductID {
            // it means current item is pinned
            pinItemButton.setTitle("Pinned".localized, for: .normal)
            pinItemButton.setTitleColor(.black, for: .normal)
            pinItemButton.backgroundColor = .white
            pinItemButton.layer.borderWidth = 1
        } else {
            pinItemButton.setTitle("Pin Item".localized, for: .normal)
            pinItemButton.setTitleColor(.white, for: .normal)
            pinItemButton.backgroundColor = .black
            pinItemButton.layer.borderWidth = 0
        }
        
    }
    
    func priceAttributedTitle(symbol: String, price: Double , orginalPrice: Double, discount: Double) -> NSAttributedString {
        
        let originalPrice = String(format: "%.2f", orginalPrice)
        let price = String(format: "%.2f", price)
        
        let attribute1 = [
            NSAttributedString.Key.font: Appearance.default.font.getFont(forTypo: .h7),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        let attribute2 = [
            NSAttributedString.Key.font: Appearance.default.font.getFont(forTypo: .h7),
            NSAttributedString.Key.foregroundColor: UIColor.colorWithHex(color: "#BCBCE5")
        ]
        
        let attribute3 = [
            NSAttributedString.Key.font: Appearance.default.font.getFont(forTypo: .h8),
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
    
    // MARK: - ACTIONS
    
    @objc func pinItemButtonTapped(){
        delegate?.didPinItemTapped(index: self.tag)
    }

}
