//
//  StreamGiftContentHeaderView.swift
//  PicoAdda
//
//  Created by Appscrip 3Embed on 11/03/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit

class StreamGiftContentHeaderView: UIView, ISMStreamUIAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.close.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        return button
    }()
    
    lazy var coinImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = appearance.images.coin
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let coinInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    lazy var coinAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0 Coins"
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h5)
        return label
    }()
    
    lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your balance"
        label.textColor = .lightGray.withAlphaComponent(0.7)
        label.font = appearance.font.getFont(forTypo: .h8)
        return label
    }()
    
    lazy var getMoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Get more", for: .normal)
        button.setTitleColor(appearance.colors.appSecondary, for: .normal)
        button.backgroundColor = appearance.colors.appColor
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h8)
        button.layer.cornerRadius = 17.5
        return button
    }()
    
    let dividerView: UIView = {
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
        
        addSubview(closeButton)
        addSubview(coinImage)
        
        addSubview(coinInfoStackView)
        coinInfoStackView.addArrangedSubview(coinAmount)
        coinInfoStackView.addArrangedSubview(balanceLabel)
        
        addSubview(getMoreButton)
        addSubview(dividerView)
        
    }
    
    func setUpConstraints(){
        
        NSLayoutConstraint.activate([
            
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            closeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 25),
            closeButton.heightAnchor.constraint(equalToConstant: 25),
            
            coinImage.leadingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: 10),
            coinImage.widthAnchor.constraint(equalToConstant: 27),
            coinImage.heightAnchor.constraint(equalToConstant: 27),
            coinImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            coinInfoStackView.leadingAnchor.constraint(equalTo: coinImage.trailingAnchor, constant: 12),
            coinInfoStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            getMoreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            getMoreButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            getMoreButton.heightAnchor.constraint(equalToConstant: 35),
            
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
        
    }
    
}
