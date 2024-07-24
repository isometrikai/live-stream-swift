//
//  GoLiveFooterView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 07/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

protocol GoLiveFooterActionDelegate {
    func didGoLiveButtonTapped()
    func didGoLiveStreamTypeActionTapped(with actionType: GoLiveStreamType)
}

class GoLiveFooterView: UIView, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var delegate: GoLiveFooterActionDelegate?
    var goLiveButtonBottomConstraint: NSLayoutConstraint?
    
    lazy var warningCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = appearance.colors.appRed
        view.layer.cornerRadius = 22
        return view
    }()
    
    lazy var warningButtonView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Broadcasters under 18 are not permitted".localized + ".", for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h8)
        return button
    }()
    
    lazy var goLiveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.ism_hexStringToUIColor(hex: "#242424")
        button.setTitle("Go Live".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h4)
        button.addTarget(self, action: #selector(goliveButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.ismTapFeedBack()
        return button
    }()

    let bottomActionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.7)
        return view
    }()
    
    let bottomActionStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var guestLiveButton: CustomToggleButton = {
        let button = CustomToggleButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.buttonTitle.text = "Single/Multi Guest Live".localized
        button.actionButton.tag = 1
        button.actionButton.addTarget(self, action: #selector(streamActionTapped(_:)), for: .touchUpInside)
        button.dashIndicatorView.isHidden = true
        return button
    }()
    
    lazy var liveFromDeviceButton: CustomToggleButton = {
        let button = CustomToggleButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.buttonTitle.text = "Live From Device".localized
        button.actionButton.tag = 2
        button.actionButton.addTarget(self, action: #selector(streamActionTapped(_:)), for: .touchUpInside)
        button.dashIndicatorView.isHidden = true
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
        
        addSubview(warningCoverView)
        addSubview(warningButtonView)
        addSubview(goLiveButton)
        
        addSubview(bottomActionView)
        
        bottomActionView.addSubview(bottomActionStack)
        bottomActionView.addSubview(dividerView)
    }
    
    func setupConstraints(){
        bottomActionStack.ism_pin(to: bottomActionView)
        NSLayoutConstraint.activate([
            
            bottomActionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomActionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomActionView.heightAnchor.constraint(equalToConstant: 45),
            bottomActionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            dividerView.leadingAnchor.constraint(equalTo: bottomActionView.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: bottomActionView.trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            dividerView.topAnchor.constraint(equalTo: bottomActionView.topAnchor),
            
            goLiveButton.heightAnchor.constraint(equalToConstant: 50),
            goLiveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            goLiveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            warningCoverView.leadingAnchor.constraint(equalTo: goLiveButton.leadingAnchor),
            warningCoverView.trailingAnchor.constraint(equalTo: goLiveButton.trailingAnchor),
            warningCoverView.heightAnchor.constraint(equalToConstant: 56),
            warningCoverView.topAnchor.constraint(equalTo: goLiveButton.topAnchor, constant: -25),
            
            warningButtonView.centerXAnchor.constraint(equalTo: centerXAnchor),
            warningButtonView.bottomAnchor.constraint(equalTo: goLiveButton.topAnchor),
            warningButtonView.heightAnchor.constraint(equalToConstant: 25)
            
        ])
        
        goLiveButtonBottomConstraint = goLiveButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -60)
        goLiveButtonBottomConstraint?.isActive = true
        
        
    }
    
    func animateStreamTypeActions(action: GoLiveStreamType){
        
        switch action {
        case .guestLive:
            
            guestLiveButton.buttonTitle.textColor = .white
            guestLiveButton.buttonTitle.font = appearance.font.getFont(forTypo: .h8)
            guestLiveButton.dashIndicatorView.isHidden = false
            
            liveFromDeviceButton.buttonTitle.font = appearance.font.getFont(forTypo: .h8)
            liveFromDeviceButton.buttonTitle.textColor = .lightGray
            liveFromDeviceButton.dashIndicatorView.isHidden = true
            
            break
        case .fromDevice:
            
            guestLiveButton.buttonTitle.textColor = .lightGray
            guestLiveButton.dashIndicatorView.isHidden = true
            guestLiveButton.buttonTitle.font = appearance.font.getFont(forTypo: .h8)
            
            liveFromDeviceButton.buttonTitle.font = appearance.font.getFont(forTypo: .h8)
            liveFromDeviceButton.buttonTitle.textColor = .white
            liveFromDeviceButton.dashIndicatorView.isHidden = false
            
            break
        }
        
    }
    
    // MARK: - ACTIONS
    
    @objc func goliveButtonTapped(){
        delegate?.didGoLiveButtonTapped()
    }
    
    @objc func streamActionTapped(_ sender: UIButton){
        
        let streamType = GoLiveStreamType(rawValue: sender.tag) ?? .guestLive
        
        // UI updates
        animateStreamTypeActions(action: streamType)
        
        // action delegate
        delegate?.didGoLiveStreamTypeActionTapped(with: streamType)
        
    }
}

class CustomToggleButton: UIView, ISMAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    lazy var buttonTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.text = "Single/Multi Guest Live".localized
        label.font = appearance.font.getFont(forTypo: .h8)
        label.textAlignment = .center
        return label
    }()
    
    let dashIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 2
        return view
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
        addSubview(buttonTitle)
        addSubview(dashIndicatorView)
        addSubview(actionButton)
    }
    
    func setupConstraints(){
        actionButton.ism_pin(to: self)
        NSLayoutConstraint.activate([
            buttonTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            buttonTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            buttonTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            dashIndicatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1),
            dashIndicatorView.heightAnchor.constraint(equalToConstant: 4),
            dashIndicatorView.widthAnchor.constraint(equalToConstant: 20),
            dashIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
}
