//
//  PKHostChangeViewController.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 29/11/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import UIKit

class PKHostChangeViewController: UIViewController {

    // MARK: - PROPERTIES
    
    var hostChange_Callback: (()->Void)?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Are you sure that you want to change the host?"
        label.textColor = .white
        label.font = Appearance.default.font.getFont(forTypo: .h3)
        label.numberOfLines = 0
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var noButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("No", for: .normal)
        button.titleLabel?.font = Appearance.default.font.getFont(forTypo: .h5)
        button.setTitleColor(.lightGray, for: .normal)
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var yesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Yes", for: .normal)
        button.titleLabel?.font = Appearance.default.font.getFont(forTypo: .h5)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundColor = Appearance.default.colors.appColor
        button.ismTapFeedBack()
        button.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        view.backgroundColor = Appearance.default.colors.appDarkGray
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        stackView.addArrangedSubview(noButton)
        stackView.addArrangedSubview(yesButton)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15)
        ])
    }
    
    // MARK: - ACTIONS
    
    @objc func yesButtonTapped(){
        self.dismiss(animated: true)
        hostChange_Callback?()
    }
    
    @objc func noButtonTapped(){
        self.dismiss(animated: true)
    }

}
