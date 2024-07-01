//
//  CustomInputFieldView.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 25/07/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

enum InputFieldType {
    case textField
    case dropdown
}

class CustomInputFieldView: UIView, AppearanceProvider {
    
    // MARK: - PROPERTIES
    
    var inputType: InputFieldType = .textField {
        didSet {
            reloadUI()
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "titleField".localized + "*"
        label.font = appearance.font.getFont(forTypo: .h8)
        label.textColor = .lightGray
        return label
    }()
    
    let inputCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.ism_hexStringToUIColor(hex: "404040").cgColor
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Placeholder".localized,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.ism_hexStringToUIColor(hex: "BBC6D2"),
                NSAttributedString.Key.font: appearance.font.getFont(forTypo: .h4)!
            ]
        )
        textField.textColor = .white
        textField.text = ""
        textField.font = appearance.font.getFont(forTypo: .h4)
        return textField
    }()
    
    lazy var inputTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Selected Item".localized
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h4)
        label.isHidden = true
        return label
    }()
    
    let trailingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var trailingText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "USD".localized
        label.font = appearance.font.getFont(forTypo: .h4)
        label.textColor = UIColor.white
        label.isHidden = true
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        addSubview(titleLabel)
        addSubview(inputCoverView)
        inputCoverView.addSubview(inputTextField)
        inputCoverView.addSubview(inputTextLabel)
        addSubview(trailingImage)
        addSubview(trailingText)
        addSubview(actionButton)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            inputCoverView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            inputCoverView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            inputCoverView.heightAnchor.constraint(equalToConstant: 45),
            inputCoverView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            actionButton.heightAnchor.constraint(equalToConstant: 45),
            actionButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            
            inputTextField.leadingAnchor.constraint(equalTo: inputCoverView.leadingAnchor, constant: 10),
            inputTextField.trailingAnchor.constraint(equalTo: inputCoverView.trailingAnchor, constant: -10),
            inputTextField.centerYAnchor.constraint(equalTo: inputCoverView.centerYAnchor),
            
            inputTextLabel.leadingAnchor.constraint(equalTo: inputCoverView.leadingAnchor, constant: 10),
            inputTextLabel.trailingAnchor.constraint(equalTo: inputCoverView.trailingAnchor, constant: -10),
            inputTextLabel.centerYAnchor.constraint(equalTo: inputCoverView.centerYAnchor),
            
            trailingImage.trailingAnchor.constraint(equalTo: inputCoverView.trailingAnchor, constant: -10),
            trailingImage.widthAnchor.constraint(equalToConstant: 25),
            trailingImage.heightAnchor.constraint(equalToConstant: 25),
            trailingImage.centerYAnchor.constraint(equalTo: inputCoverView.centerYAnchor),
            
            trailingText.trailingAnchor.constraint(equalTo: inputCoverView.trailingAnchor, constant: -10),
            trailingText.heightAnchor.constraint(equalToConstant: 25),
            trailingText.centerYAnchor.constraint(equalTo: inputCoverView.centerYAnchor)
            
        ])
    }
    
    func reloadUI() {
        
        switch self.inputType {
        case .dropdown:
            inputTextField.isHidden = true
            inputTextLabel.isHidden = false
            trailingImage.isHidden = false
            break
        case .textField:
            inputTextField.isHidden = false
            inputTextLabel.isHidden = true
            trailingImage.isHidden = true
            break
        }
        
    }
    
}
