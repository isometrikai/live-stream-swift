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

class GlobalSearchBarView: UIView {

    // MARK: - PROPERTIES
    
    var delegate: GlobalSearchBarActionDelegate?
    
    let searchCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor.colorWithHex(color: "#F3F2F2")
        return view
    }()
    
    let searchIconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Appearance.default.images.search
        return imageView
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = UIColor.colorWithHex(color:"#5E5E5E")
        textField.tintColor = .black
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search Users".localized,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.colorWithHex(color:"#5E5E5E"),
                NSAttributedString.Key.font: Appearance.default.font.getFont(forTypo: .h6)
            ]
        )
        
        textField.font = Appearance.default.font.getFont(forTypo: .h6)
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
        addSubview(searchIconImage)
        addSubview(searchTextField)
        addSubview(searchIndicatorView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            
            searchCoverView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            searchCoverView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            searchCoverView.heightAnchor.constraint(equalToConstant: 45),
            searchCoverView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            searchIconImage.widthAnchor.constraint(equalToConstant: 20),
            searchIconImage.heightAnchor.constraint(equalToConstant: 20),
            searchIconImage.leadingAnchor.constraint(equalTo: searchCoverView.leadingAnchor, constant: 10),
            searchIconImage.centerYAnchor.constraint(equalTo: searchCoverView.centerYAnchor),
            
            searchTextField.leadingAnchor.constraint(equalTo: searchIconImage.trailingAnchor, constant: 5),
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
