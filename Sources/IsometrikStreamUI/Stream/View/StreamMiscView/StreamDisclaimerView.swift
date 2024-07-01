//
//  StreamDisclaimerView.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 10/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

class DisclaimerView: UIView, AppearanceProvider {
    
    // MARK: - PROPERTIES
    
    lazy var disclaimerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "We moderate Live Broadcasts. Smoking Vulgarity, porn,indecent exposure, child Pornograpgy is NOT Allowedand will be Banned. Live broadcasts are monitored 24 Hours a day. \n\nWarning: Third-party Top-up or recharge Is subject to account closure, suspension, Or permanent ban".localized + "."
        label.textColor = .black
        label.numberOfLines = 0
        label.font = appearance.font.getFont(forTypo: .h5)
        return label
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 22.5
        button.setTitle("Got it".localized + "!", for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h5)
        button.ismTapFeedBack()
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.backgroundColor = .black
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
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
        addSubview(bubbleView)
        addSubview(disclaimerLabel)
        addSubview(closeButton)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            disclaimerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            disclaimerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            disclaimerLabel.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -15),
            disclaimerLabel.topAnchor.constraint(equalTo: topAnchor),
            
            bubbleView.leadingAnchor.constraint(equalTo: disclaimerLabel.leadingAnchor, constant: -10),
            bubbleView.trailingAnchor.constraint(equalTo: disclaimerLabel.trailingAnchor, constant: 10),
            bubbleView.bottomAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10),
            bubbleView.topAnchor.constraint(equalTo: disclaimerLabel.topAnchor, constant: -10),
            
            closeButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    @objc func closeButtonTapped(){
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        } completion: { finished in
            self.isHidden = true
            self.alpha = 1
        }

    }
    
}
