//
//  CustomSearchTextBarView.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 05/03/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit

class CustomSearchTextBarView: UIView {

    // MARK: - PROPERTIES
    
    let searchBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Appearance.default.colors.appLightGray
        view.layer.cornerRadius = 20.0
        return view
    }()
    
    let searchImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = Appearance.default.images.search
        image.contentMode = .center
        return image
    }()
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Search"
        textField.font = Appearance.default.font.getFont(forTypo: .h6)
        textField.textColor = .black
        textField.clearButtonMode = .whileEditing
        return textField
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
        addSubview(searchBackgroundView)
        searchBackgroundView.addSubview(searchImage)
        searchBackgroundView.addSubview(searchTextField)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            searchBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            searchBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            searchBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            searchBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            searchImage.leadingAnchor.constraint(equalTo: searchBackgroundView.leadingAnchor, constant: 10),
            searchImage.widthAnchor.constraint(equalToConstant: 30),
            searchImage.bottomAnchor.constraint(equalTo: searchBackgroundView.bottomAnchor),
            searchImage.topAnchor.constraint(equalTo: searchBackgroundView.topAnchor),
            
            searchTextField.leadingAnchor.constraint(equalTo: searchImage.trailingAnchor, constant: 3),
            searchTextField.trailingAnchor.constraint(equalTo: searchBackgroundView.trailingAnchor, constant: -10),
            searchTextField.centerYAnchor.constraint(equalTo: searchBackgroundView.centerYAnchor)
        ])
    }

}
