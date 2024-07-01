//
//  CustomStepperButtonView.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 05/12/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

class CustomStepperButtonView: UIView {

    // MARK: - PROPERTIES
    
    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .horizontal
        return stackView
    }()
    
    let leadingActionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Appearance.default.images.plus.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.ismTapFeedBack()
        return button
    }()
    
    let stepperCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Appearance.default.font.getFont(forTypo: .h6)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "0"
        return label
    }()
    
    let trailingActionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Appearance.default.images.removeCircle.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
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
        addSubview(contentStackView)
        contentStackView.addArrangedSubview(leadingActionButton)
        contentStackView.addArrangedSubview(stepperCountLabel)
        contentStackView.addArrangedSubview(trailingActionButton)
    }
    
    func setupConstraints(){
        contentStackView.pin(to: self)
        NSLayoutConstraint.activate([
            leadingActionButton.widthAnchor.constraint(equalToConstant: 50),
            leadingActionButton.heightAnchor.constraint(equalToConstant: 50),
            trailingActionButton.widthAnchor.constraint(equalToConstant: 50),
            trailingActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

}
