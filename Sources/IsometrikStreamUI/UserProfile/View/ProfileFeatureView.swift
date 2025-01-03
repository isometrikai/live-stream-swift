//
//  ProfileFeatureView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 03/02/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

public class ProfileFeatureView: UIView, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    public let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    public lazy var followersView: CustomFeatureView = {
        let view = CustomFeatureView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.iconImageView.image = appearance.images.user
        view.featureLabel.text = "--"
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 15
        view.backgroundColor = appearance.colors.appLightBlue
        return view
    }()
    
    public lazy var coinView: CustomFeatureView = {
        let view = CustomFeatureView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.iconImageView.image = UIImage(named: "starYello")?.withRenderingMode(.alwaysTemplate)
        view.iconImageView.tintColor = UIColor.colorWithHex(color: "#FAB417")
        view.featureLabel.text = "--"
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 15
        view.backgroundColor = appearance.colors.appLightYellow
        return view
    }()
    
    // MARK: - MAIN
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        addSubview(infoStackView)
        infoStackView.addArrangedSubview(followersView)
        //infoStackView.addArrangedSubview(coinView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            infoStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            followersView.heightAnchor.constraint(equalToConstant: 30),
            coinView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

}

