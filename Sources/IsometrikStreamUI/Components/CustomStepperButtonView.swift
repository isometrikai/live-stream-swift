//
//  CustomStepperButtonView.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 05/12/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

class CustomStepperButtonView: UIView, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .horizontal
        return stackView
    }()
    
    lazy var leadingActionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.plus.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.ismTapFeedBack()
        return button
    }()
    
    lazy var stepperCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = appearance.font.getFont(forTypo: .h6)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "0"
        return label
    }()
    
    lazy var trailingActionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.removeCircle.withRenderingMode(.alwaysTemplate), for: .normal)
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
        contentStackView.ism_pin(to: self)
        NSLayoutConstraint.activate([
            leadingActionButton.widthAnchor.constraint(equalToConstant: 50),
            leadingActionButton.heightAnchor.constraint(equalToConstant: 50),
            trailingActionButton.widthAnchor.constraint(equalToConstant: 50),
            trailingActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

}
