//
//  TaggedProductListTableViewCell.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 24/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import Kingfisher
import IsometrikStream

protocol TaggedProductListActionDelegate {
    func didAddToCartTapped(_ index: Int)
    func didMessageTapped(_ index: Int)
}

class TaggedProductListTableViewCell: UITableViewCell {

    // MARK: - PROPERTIES
    var isFromRecordedStream: Bool = false
    var isFromScheduleStream: Bool = false
    var delegate: TaggedProductListActionDelegate?
    var data: StreamProductModel? {
        didSet {
            manageData()
        }
    }
    
    let backCoverCard: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        return view
    }()
    
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
        label.numberOfLines = 2
        return label
    }()
    
    let productPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        Fonts.setFont(label, fontFamiy: .monstserrat(.Bold), size: .custom(14), color: .black)
        return label
    }()
    
    //:
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.titleLabel?.font = Appearance.default.font.getFont(forTypo: .h8)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 17.5
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        button.ismTapFeedBack()
        button.isHidden = true
        return button
    }()
    
    lazy var chatButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Appearance.default.images.message.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        button.backgroundColor = .black
        button.layer.cornerRadius = 17.5
        button.ismTapFeedBack()
        button.addTarget(self, action: #selector(messageButtonTapped), for: .touchUpInside)
        button.isHidden = true
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
        addSubview(backCoverCard)
        backCoverCard.addSubview(productImage)
        backCoverCard.addSubview(productInfoStackView)
        
        productInfoStackView.addArrangedSubview(productTitle)
        productInfoStackView.addArrangedSubview(productPrice)
        
        backCoverCard.addSubview(actionButton)
        backCoverCard.addSubview(chatButton)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            backCoverCard.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            backCoverCard.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            backCoverCard.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            backCoverCard.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            productImage.leadingAnchor.constraint(equalTo: backCoverCard.leadingAnchor, constant: 10),
            productImage.centerYAnchor.constraint(equalTo: backCoverCard.centerYAnchor),
            productImage.widthAnchor.constraint(equalToConstant: 85),
            productImage.heightAnchor.constraint(equalToConstant: 85),
            
            productInfoStackView.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 10),
            productInfoStackView.trailingAnchor.constraint(equalTo: backCoverCard.trailingAnchor, constant: -10),
            productInfoStackView.topAnchor.constraint(equalTo: backCoverCard.topAnchor, constant: 10),
            
            actionButton.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 10),
            actionButton.bottomAnchor.constraint(equalTo: backCoverCard.bottomAnchor, constant: -10),
            actionButton.heightAnchor.constraint(equalToConstant: 35),
            
            chatButton.widthAnchor.constraint(equalToConstant: 35),
            chatButton.heightAnchor.constraint(equalToConstant: 35),
            chatButton.bottomAnchor.constraint(equalTo: backCoverCard.bottomAnchor, constant: -10),
            chatButton.leadingAnchor.constraint(equalTo: actionButton.trailingAnchor, constant: 8)
        ])
    }
    
    func manageData(){
        guard let productData = data else { return }
        
        let productCategory = productData.brandName ?? ""
        let productName = productData.productName ?? ""
        let imageStringUrl = productData.images?.first?.medium ?? ""
        let currencySymbol = productData.currencySymbol ?? ""
        let originalPrice = (isFromRecordedStream || isFromScheduleStream) ? productData.finalPriceList?.basePrice ?? 0 : productData.liveStreamfinalPriceList?.basePrice ?? 0
        let finalPrice = (isFromRecordedStream || isFromScheduleStream) ? productData.finalPriceList?.finalPrice ?? 0 : productData.liveStreamfinalPriceList?.finalPrice ?? 0
        let discountedPercentage = (isFromRecordedStream || isFromScheduleStream) ? productData.finalPriceList?.discountPercentage ?? 0 : productData.liveStreamfinalPriceList?.discountPercentage ?? 0
        let storeId = data?.supplier?.id ?? ""
        let outOfStock = productData.outOfStock ?? false
        
        if let imageUrl = URL(string: imageStringUrl) {
            productImage.kf.setImage(with: imageUrl)
        }
        
        productTitle.text = productName
        
        if discountedPercentage == 0 {
            productPrice.text = "\(originalPrice) \(currencySymbol)"
        } else {
            productPrice.attributedText = priceAttributedTitle(symbol: currencySymbol, price: Double(finalPrice), orginalPrice: Double(originalPrice), discount: discountedPercentage)
        }
        
        if outOfStock {
            actionButton.isHidden = false
            actionButton.isEnabled = false
            actionButton.setTitle("SOLD OUT".localized, for: .normal)
            actionButton.setTitleColor(.red, for: .normal)
            actionButton.backgroundColor = .lightGray.withAlphaComponent(0.2)
        } else {
            actionButton.isEnabled = true
            actionButton.setTitleColor(.white, for: .normal)
            actionButton.backgroundColor = .black
            if isFromRecordedStream || isFromScheduleStream {
//                if storeId == Utility.getCurrentStoreId() {
//                    actionButton.isHidden = true
//                } else {
//                    actionButton.isHidden = false
//                    actionButton.setTitle("Add to cart".localized, for: .normal)
//                }
            } else {
                actionButton.isHidden = false
                actionButton.setTitle("Buy now".localized, for: .normal)
            }
        }
        
        
        
    }
    
    func priceAttributedTitle(symbol: String, price: Double , orginalPrice: Double, discount: Double) -> NSAttributedString {
        
        let origPrice = String(format: "%.2f", orginalPrice)
        let price = String(format: "%.2f", price)
        
        let attribute1 = [
            NSAttributedString.Key.font: Appearance.default.font.getFont(forTypo: .h5),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        let attribute2 = [
            NSAttributedString.Key.font: Appearance.default.font.getFont(forTypo: .h5),
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
            attributedString.append(NSAttributedString(string: "\(origPrice) \(symbol)", attributes: attribute2 as [NSAttributedString.Key : Any]).withStrikeThrough(1))
        }
        
        attributedString.append(NSAttributedString(string: " "))
         
        attributedString.append(NSAttributedString(string: "\(discount)% OFF", attributes: attribute3 as [NSAttributedString.Key : Any]))
        
        return attributedString
        
    }
    
    // MARK: - ACTIONS
    
    @objc func actionButtonTapped(){
        delegate?.didAddToCartTapped(self.tag)
    }
    
    @objc func messageButtonTapped() {
        delegate?.didMessageTapped(self.tag)
    }

}
