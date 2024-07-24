//
//  StreamFooterView.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 07/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

enum BottomActionsUI {
    case text
    case button
}

class StreamFooterView: UIView, ISMAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    let messageTextInputView: StreamMessageTextView = {
        let messageTextView = StreamMessageTextView()
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        messageTextView.isHidden = true
        messageTextView.coverView.layer.cornerRadius = 25
        return messageTextView
    }()
    
    // - Bottom Action Buttons
    
    let actionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var chatActionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Say Something".localized + "..", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h6)
        button.backgroundColor = .black.withAlphaComponent(0.4)
        button.layer.cornerRadius = 25
        button.ismTapFeedBack()
        button.addTarget(self, action: #selector(chatActionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let stepperButton: CustomStepperButtonView = {
        let view = CustomStepperButtonView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.isHidden = true
        return view
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h6)
        button.layer.cornerRadius = 25
        button.imageView?.tintColor = .black
        button.ismTapFeedBack()
        return button
    }()
    
    let loaderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .medium
        view.color = .black
        return view
    }()
    
    //:
    
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
        addSubview(actionStackView)
        actionStackView.addArrangedSubview(chatActionButton)
        actionStackView.addArrangedSubview(actionButton)
        
        addSubview(loaderView)
        loaderView.addSubview(activityIndicatorView)
        
        addSubview(stepperButton)
        addSubview(messageTextInputView)
        
    }
    
    func setupConstraints(){
        activityIndicatorView.ism_pin(to: loaderView)
        NSLayoutConstraint.activate([
            messageTextInputView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            messageTextInputView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            messageTextInputView.heightAnchor.constraint(equalToConstant: 50),
            messageTextInputView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            actionStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            actionStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            actionStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionStackView.heightAnchor.constraint(equalToConstant: 50),
            
            loaderView.leadingAnchor.constraint(equalTo: actionButton.leadingAnchor),
            loaderView.trailingAnchor.constraint(equalTo: actionButton.trailingAnchor),
            loaderView.topAnchor.constraint(equalTo: actionButton.topAnchor),
            loaderView.bottomAnchor.constraint(equalTo: actionButton.bottomAnchor),
            
            stepperButton.leadingAnchor.constraint(equalTo: actionButton.leadingAnchor),
            stepperButton.trailingAnchor.constraint(equalTo: actionButton.trailingAnchor),
            stepperButton.topAnchor.constraint(equalTo: actionButton.topAnchor),
            stepperButton.bottomAnchor.constraint(equalTo: actionButton.bottomAnchor)
        ])
    }
    
    func toggleBottomActionUI(for action: BottomActionsUI, isTextFieldActive active: Bool = true){
        switch action {
        case .text:
            messageTextInputView.isHidden = false
            actionStackView.isHidden = true
            if active {
                messageTextInputView.messageTextField.becomeFirstResponder()
            }
        case .button:
            messageTextInputView.isHidden = true
            actionStackView.isHidden = false
        }
    }
    
    func startLoader(){
        loaderView.isHidden = false
        activityIndicatorView.isHidden = false
        actionButton.isEnabled = false
        activityIndicatorView.startAnimating()
    }
    
    func stopLoader(){
        loaderView.isHidden = true
        activityIndicatorView.isHidden = true
        actionButton.isEnabled = true
        activityIndicatorView.stopAnimating()
    }
    
    // MARK: - ACTIONS
    
    @objc func chatActionButtonTapped(){
        toggleBottomActionUI(for: .text)
    }
    
}
