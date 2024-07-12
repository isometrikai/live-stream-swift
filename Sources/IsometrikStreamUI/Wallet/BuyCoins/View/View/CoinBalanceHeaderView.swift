//
//  File.swift
//  
//
//  Created by Appscrip 3Embed on 10/07/24.
//

import UIKit
import IsometrikStream

class CoinBalanceHeaderView: UIView, AppearanceProvider {
    
    // MARK: - PROPERTIES
    
    lazy var coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = appearance.images.coin
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .leading
        return stackView
    }()
    
    lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = appearance.font.getFont(forTypo: .h3)
        return label
    }()
    
    lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "My Balance"
        label.textColor = .lightGray
        label.font = appearance.font.getFont(forTypo: .h6)
        return label
    }()
    
    lazy var transactionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Transaction", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        button.backgroundColor = appearance.colors.appColor
        button.setTitleColor(appearance.colors.appSecondary, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h6)
        button.layer.cornerRadius = 4
        return button
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
        addSubview(coinImageView)
        addSubview(infoStackView)
        infoStackView.addArrangedSubview(balanceLabel)
        infoStackView.addArrangedSubview(placeHolderLabel)
        addSubview(transactionButton)
        addSubview(dividerView)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            coinImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            coinImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            coinImageView.widthAnchor.constraint(equalToConstant: 40),
            coinImageView.heightAnchor.constraint(equalToConstant: 40),
            
            infoStackView.leadingAnchor.constraint(equalTo: coinImageView.trailingAnchor, constant: 12),
            infoStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: transactionButton.leadingAnchor, constant: -8),
            
            transactionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            transactionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            transactionButton.heightAnchor.constraint(equalToConstant: 40),
            
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func configureView(balance: Float64){
        balanceLabel.text = "\(Int64(balance)) coins"
    }
    
}
