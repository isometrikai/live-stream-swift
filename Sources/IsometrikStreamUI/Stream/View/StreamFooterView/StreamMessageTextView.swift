//
//  StreamMessageTextView.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 07/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

class StreamMessageTextView: UIView, AppearanceProvider {

    // MARK: - PROPERTIES
    
    let coverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var emojiButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.emoji.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        button.backgroundColor = UIColor.colorWithHex(color: "#676767")
        button.layer.cornerRadius = 17.5
        button.ismTapFeedBack()
        button.addTarget(self, action: #selector(emojiTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var messageTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .white
        textField.tintColor = .white
        textField.font = appearance.font.getFont(forTypo: .h6)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Say Something".localized + "..",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: appearance.font.getFont(forTypo: .h6)!
            ]
        )
        return textField
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.send, for: .normal)
        button.ismTapFeedBack()
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
        addSubview(coverView)
        coverView.addSubview(emojiButton)
        coverView.addSubview(messageTextField)
        coverView.addSubview(sendButton)
    }
    
    func setupConstraints(){
        coverView.ism_pin(to: self)
        NSLayoutConstraint.activate([
            emojiButton.leadingAnchor.constraint(equalTo: coverView.leadingAnchor, constant: 7.5),
            emojiButton.widthAnchor.constraint(equalToConstant: 35),
            emojiButton.heightAnchor.constraint(equalToConstant: 35),
            emojiButton.centerYAnchor.constraint(equalTo: coverView.centerYAnchor),
            
            messageTextField.centerYAnchor.constraint(equalTo: coverView.centerYAnchor),
            messageTextField.leadingAnchor.constraint(equalTo: emojiButton.trailingAnchor, constant: 3),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -3),
            
            sendButton.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -7.5),
            sendButton.widthAnchor.constraint(equalToConstant: 35),
            sendButton.heightAnchor.constraint(equalToConstant: 35),
            sendButton.centerYAnchor.constraint(equalTo: coverView.centerYAnchor),
        ])
    }
    
    // MARK: - ACTIONS
    
    @objc func emojiTapped(){
        
    }

}
