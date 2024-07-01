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

class StreamPopupViewController: UIViewController {

    // MARK: - PROPERTIES
    
    var actionCallback: ((StreamPopupAction) -> Void)?
    
    let backCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    
    let popupCardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Appearance.default.colors.appGrayBackground
        view.layer.cornerRadius = 5
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Are you sure that you want to end your live video".localized + "?"
        label.textColor = .white
        label.font = Appearance.default.font.getFont(forTypo: .h3)
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
        button.setTitle("Cancel".localized, for: .normal)
        button.setTitleColor(Appearance.default.colors.appColor, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderColor = Appearance.default.colors.appColor.cgColor
        button.layer.borderWidth = 1.5
        button.backgroundColor = .black
        button.ismTapFeedBack()
        button.titleLabel?.font = Appearance.default.font.getFont(forTypo: .h4)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var yesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Yes", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = Appearance.default.colors.appColor
        button.ismTapFeedBack()
        button.titleLabel?.font = Appearance.default.font.getFont(forTypo: .h4)
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
        buttonStackView.addArrangedSubview(yesButton)
    }
    
    func setupConstraints(){
        backCoverView.pin(to: view)
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
