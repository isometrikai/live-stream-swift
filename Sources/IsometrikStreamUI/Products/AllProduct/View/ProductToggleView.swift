//
//  ProductToggleView.swift
//  Shopr
//
//  Created by new user on 29/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

class ProductToggleView: UIView, ISMStreamUIAppearanceProvider {

    // MARK: - PROPERTIES
    
    let optionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var myStoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("My Store".localized, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h7)
        button.layer.borderColor = UIColor.colorWithHex(color: "#BCBCE5").cgColor
        button.layer.cornerRadius = 22.5
        return button
    }()
    
    lazy var otherStoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Other Stores".localized, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h7)
        button.layer.borderColor = UIColor.colorWithHex(color: "#BCBCE5").cgColor
        button.layer.cornerRadius = 22.5
        return button
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
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
        addSubview(optionStackView)
        optionStackView.addArrangedSubview(myStoreButton)
        optionStackView.addArrangedSubview(otherStoreButton)
        addSubview(dividerView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            optionStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            optionStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            optionStackView.heightAnchor.constraint(equalToConstant: 45),
            optionStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func updateUI(activeButton: StreamProductsForm = .myStore){
        
        switch activeButton {
        case .myStore:
            
            otherStoreButton.setTitleColor(UIColor.colorWithHex(color: "#BCBCE5"), for: .normal)
            otherStoreButton.layer.borderWidth = 1
            otherStoreButton.backgroundColor = .clear
            
            myStoreButton.setTitleColor(appearance.colors.appSecondary, for: .normal)
            myStoreButton.layer.borderWidth = 0
            myStoreButton.backgroundColor = appearance.colors.appColor
            
            break
        case .otherStore:
            
            myStoreButton.setTitleColor(UIColor.colorWithHex(color: "#BCBCE5"), for: .normal)
            myStoreButton.layer.borderWidth = 1
            myStoreButton.backgroundColor = .clear
            
            otherStoreButton.setTitleColor(appearance.colors.appSecondary, for: .normal)
            otherStoreButton.layer.borderWidth = 0
            otherStoreButton.backgroundColor = appearance.colors.appColor
            
            break
        }
        
    }

}
