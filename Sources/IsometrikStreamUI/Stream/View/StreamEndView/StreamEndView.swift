//
//  StreamEndView.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 02/09/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

class StreamEndView: UIView, ISMStreamUIAppearanceProvider {

    // MARK: - PROPERTIES
    
    let backCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.9)
        return view
    }()
    
    lazy var streamEndMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h3)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var continueButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue".localized, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = appearance.colors.appColor
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h4)
        button.layer.cornerRadius = 25
        button.ismTapFeedBack()
        return button
    }()
    
    // MARK: - MAIN
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        addSubview(backCoverView)
        backCoverView.addSubview(streamEndMessageLabel)
        backCoverView.addSubview(continueButton)
    }
    
    func setupConstraints(){
        backCoverView.ism_pin(to: self)
        NSLayoutConstraint.activate([
            streamEndMessageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            streamEndMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            streamEndMessageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            streamEndMessageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            continueButton.topAnchor.constraint(equalTo: streamEndMessageLabel.bottomAnchor, constant: 20),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            continueButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

}
