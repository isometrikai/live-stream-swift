//
//  StreamPopupViewController.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 31/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

enum StreamPopupAction {
    case cancel
    case ok
}

class StreamPopupViewController: UIViewController, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var actionCallback: ((StreamPopupAction) -> Void)?
    
    let backCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    
    lazy var popupCardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = appearance.colors.appGrayBackground
        view.layer.cornerRadius = 5
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h3)
        label.numberOfLines = 0
        return label
    }()
    
    let buttonStackView: UIStackView = {
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
        button.setTitleColor(appearance.colors.appColor, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderColor = appearance.colors.appColor.cgColor
        button.layer.borderWidth = 1.5
        button.backgroundColor = .black
        button.ismTapFeedBack()
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h4)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = appearance.colors.appColor
        button.ismTapFeedBack()
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h4)
        button.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
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
        view.addSubview(popupCardView)
        
        popupCardView.addSubview(titleLabel)
        popupCardView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(actionButton)
    }
    
    func setupConstraints(){
        backCoverView.ism_pin(to: view)
        NSLayoutConstraint.activate([
            
            popupCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            popupCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            popupCardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            buttonStackView.leadingAnchor.constraint(equalTo: popupCardView.leadingAnchor, constant: 15),
            buttonStackView.trailingAnchor.constraint(equalTo: popupCardView.trailingAnchor, constant: -15),
            buttonStackView.bottomAnchor.constraint(equalTo: popupCardView.bottomAnchor, constant: -15),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.leadingAnchor.constraint(equalTo: popupCardView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: popupCardView.trailingAnchor, constant: -15),
            titleLabel.topAnchor.constraint(equalTo: popupCardView.topAnchor, constant: 15),
            titleLabel.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -20)
            
        ])
    }
    
    // MARK: - ACTIONS
    
    @objc func cancelButtonTapped() {
        actionCallback?(.cancel)
        self.dismiss(animated: true)
    }
    
    @objc func okButtonTapped(){
        actionCallback?(.ok)
        self.dismiss(animated: true)
    }

}
