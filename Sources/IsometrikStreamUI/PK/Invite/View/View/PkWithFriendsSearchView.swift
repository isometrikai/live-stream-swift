//
//  PkWithFriendsSearchView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 24/11/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import UIKit

class PkWithFriendsSearchView: UIView {

    // MARK: - PROPERTIES
    
    let searchBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Appearance.default.colors.appLightGray.withAlphaComponent(0.1)
        view.layer.borderColor = Appearance.default.colors.appLightGray.withAlphaComponent(0.4).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        return view
    }()
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Search"
        textField.font = Appearance.default.font.getFont(forTypo: .h5)
        textField.textColor = .white
        textField.tintColor = .white
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        return textField
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
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        addSubview(searchBarView)
        searchBarView.addSubview(searchTextField)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            searchBarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            searchBarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            searchBarView.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchBarView.heightAnchor.constraint(equalToConstant: 45),
            
            searchTextField.leadingAnchor.constraint(equalTo: searchBarView.leadingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: searchBarView.trailingAnchor, constant: -10),
            searchTextField.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor)
        ])
    }
}
