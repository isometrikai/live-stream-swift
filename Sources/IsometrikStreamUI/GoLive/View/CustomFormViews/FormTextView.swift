//
//  FormTextView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 08/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

final public class FormTextView: UIView, ISMAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    var textLabelLeadingAnchor: NSLayoutConstraint?
    
    let formTextImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    let outerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        view.layer.cornerRadius = 5
        return view
    }()
    
    public lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter Something..",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.7),
                NSAttributedString.Key.font: appearance.font.getFont(forTypo: .h8)
            ]
        )
        textField.tintColor = .white
        textField.font = appearance.font.getFont(forTypo: .h8)
        textField.isHidden = true
        textField.textColor = .white
        return textField
    }()
    
    public lazy var customTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dummy form text label"
        label.font = appearance.font.getFont(forTypo: .h8)
        label.textColor = .lightGray.withAlphaComponent(0.7)
        return label
    }()
    
    let tapActionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    public lazy var copyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.copyLink.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        button.ismTapFeedBack()
        button.isHidden = true
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
        addSubview(outerView)
        outerView.addSubview(customTextLabel)
        outerView.addSubview(inputTextField)
        outerView.addSubview(tapActionButton)
        outerView.addSubview(copyButton)
        outerView.addSubview(formTextImageView)
    }
    
    func setupConstraints(){
        outerView.ism_pin(to: self)
        tapActionButton.ism_pin(to: self)
        NSLayoutConstraint.activate([
            
            customTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            customTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            inputTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            inputTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            copyButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            copyButton.heightAnchor.constraint(equalToConstant: 45),
            copyButton.widthAnchor.constraint(equalToConstant: 45),
            copyButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            formTextImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            formTextImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            formTextImageView.widthAnchor.constraint(equalToConstant: 35),
            formTextImageView.heightAnchor.constraint(equalToConstant: 35)
            
        ])
        
        textLabelLeadingAnchor = customTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15)
        textLabelLeadingAnchor?.isActive = true
        
    }

}
