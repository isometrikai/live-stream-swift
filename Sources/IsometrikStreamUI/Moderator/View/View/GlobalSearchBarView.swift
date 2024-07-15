//
//  GlobalSearchBarView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 26/04/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

protocol GlobalSearchBarActionDelegate {
    func didSearchTextFieldDidChange(withText: String)
}

class GlobalSearchBarView: UIView, ISMStreamUIAppearanceProvider {

    // MARK: - PROPERTIES
    
    var delegate: GlobalSearchBarActionDelegate?
    
    lazy var searchCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = appearance.colors.appLightGray.withAlphaComponent(0.1)
        view.layer.borderColor = appearance.colors.appLightGray.withAlphaComponent(0.4).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        return view
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Search"
        textField.font = appearance.font.getFont(forTypo: .h5)
        textField.textColor = .white
        textField.tintColor = .white
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search Users",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        return textField
    }()
    
    let searchIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .medium
        indicator.color = .darkGray
        indicator.isHidden = true
        return indicator
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
        addSubview(searchCoverView)
        searchCoverView.addSubview(searchTextField)
        addSubview(searchIndicatorView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            
            searchCoverView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            searchCoverView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            searchCoverView.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchCoverView.heightAnchor.constraint(equalToConstant: 45),
            
            searchTextField.leadingAnchor.constraint(equalTo: searchCoverView.leadingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: searchCoverView.trailingAnchor, constant: -10),
            searchTextField.centerYAnchor.constraint(equalTo: searchCoverView.centerYAnchor),
            
            searchIndicatorView.centerYAnchor.constraint(equalTo: searchCoverView.centerYAnchor),
            searchIndicatorView.trailingAnchor.constraint(equalTo: searchCoverView.trailingAnchor, constant: -15)
            
        ])
    }
    
    func startAnimating(){
        self.searchIndicatorView.isHidden = false
        self.searchIndicatorView.startAnimating()
    }
    
    func stopAnimating(){
        self.searchIndicatorView.isHidden = true
        self.searchIndicatorView.stopAnimating()
    }
    
    // MARK: - ACTIONS
    
    @objc func textFieldDidChange(_ textField: UITextField){
        delegate?.didSearchTextFieldDidChange(withText: textField.text ?? "")
    }
    
    
}
