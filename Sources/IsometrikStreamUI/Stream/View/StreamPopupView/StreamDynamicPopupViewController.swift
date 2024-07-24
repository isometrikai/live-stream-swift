//
//  StreamDynamicPopupViewController.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 07/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

enum StreamDynamicPopupTap{
    case cancel
    case ok
}

class StreamDynamicPopupViewController: UIViewController, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var action_callback: ((_ action:  StreamDynamicPopupTap) -> Void)?
    
    lazy var backCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backCoverViewTapped))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()
    
    lazy var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = appearance.colors.appDarkGray
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h4)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = appearance.font.getFont(forTypo: .h4)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let actionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.axis = .horizontal
        return stackView
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.setTitle("Cancel".localized, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h6)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray.withAlphaComponent(0.5)
        button.layer.cornerRadius = 25
        button.ismTapFeedBack()
        return button
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action:
                            #selector(actionButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h6)
        button.setTitleColor(appearance.colors.appSecondary, for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundColor = appearance.colors.appColor
        button.layer.masksToBounds = true
        button.ismTapFeedBack()
        return button
    }()
    
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        
        view.addSubview(backCoverView)
        view.addSubview(cardView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(infoLabel)
        cardView.addSubview(actionStackView)
        actionStackView.addArrangedSubview(cancelButton)
        actionStackView.addArrangedSubview(actionButton)
        
    }
    
    func setupConstraints(){
        backCoverView.ism_pin(to: view)
        NSLayoutConstraint.activate([
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            infoLabel.bottomAnchor.constraint(equalTo: actionStackView.topAnchor, constant: -20),
            
            actionStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            actionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            actionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            actionStackView.heightAnchor.constraint(equalToConstant: 50),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - ACTIONS
    
    @objc func cancelButtonTapped(){
        action_callback?(.cancel)
    }
    
    @objc func actionButtonTapped(){
        action_callback?(.ok)
    }
    
    @objc func backCoverViewTapped(){
        self.dismiss(animated: true)
    }

}

