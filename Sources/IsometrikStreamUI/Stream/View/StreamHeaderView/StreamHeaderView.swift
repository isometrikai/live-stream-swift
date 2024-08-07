//
//  StreamHeaderView.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 07/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

class StreamHeaderView: UIView, ISMAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    lazy var profileView: StreamProfileView = {
        let view = StreamProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var streamStatusView: StreamStatusView = {
        let view = StreamStatusView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //: - trailing action views
    
    let trailingActionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let cartView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let cartImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isHidden = true
        return image
    }()
    
    lazy var cartBadge: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h8)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.isHidden = true
        return button
    }()
    
    let cartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    lazy var viewerCountView: CustomFeatureView = {
        let view = CustomFeatureView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.iconImageView.image = appearance.images.eye.withRenderingMode(.alwaysTemplate)
        view.iconImageView.tintColor = .white
        view.featureLabel.text = "0"
        view.featureLabel.textColor = .white
        view.featureLabel.font = appearance.font.getFont(forTypo: .h8)
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 12.5
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.close.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        button.ismTapFeedBack()
        button.layer.cornerRadius = 15
        return button
    }()
    
    //:
    
    lazy var streamTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .white
        label.numberOfLines = 2
        label.font = appearance.font.getFont(forTypo: .h8)
        return label
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
        backgroundColor = .clear
        addSubview(profileView)
        addSubview(streamStatusView)
        
        addSubview(trailingActionView)
        
        trailingActionView.addSubview(cartView)
        cartView.addSubview(cartImage)
        cartView.addSubview(cartBadge)
        
        trailingActionView.addSubview(cartButton)
        trailingActionView.addSubview(viewerCountView)
        trailingActionView.addSubview(closeButton)
        
        addSubview(streamTitleLabel)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            profileView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            profileView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            profileView.heightAnchor.constraint(equalToConstant: 40),
            
            trailingActionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            trailingActionView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            trailingActionView.heightAnchor.constraint(equalToConstant: 40),
            trailingActionView.leadingAnchor.constraint(equalTo: cartView.leadingAnchor),
            
            cartButton.leadingAnchor.constraint(equalTo: cartView.leadingAnchor),
            cartButton.trailingAnchor.constraint(equalTo: cartView.trailingAnchor),
            cartButton.topAnchor.constraint(equalTo: cartView.topAnchor),
            cartButton.bottomAnchor.constraint(equalTo: cartView.bottomAnchor),
            
            closeButton.trailingAnchor.constraint(equalTo: trailingActionView.trailingAnchor, constant: -12),
            closeButton.centerYAnchor.constraint(equalTo: trailingActionView.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            
            viewerCountView.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -5),
            viewerCountView.heightAnchor.constraint(equalToConstant: 25),
            viewerCountView.centerYAnchor.constraint(equalTo: trailingActionView.centerYAnchor),
            
            cartView.trailingAnchor.constraint(equalTo: viewerCountView.leadingAnchor, constant: -10),
            cartView.heightAnchor.constraint(equalToConstant: 35),
            cartView.widthAnchor.constraint(equalToConstant: 35),
            cartView.centerYAnchor.constraint(equalTo: trailingActionView.centerYAnchor),
            
            cartImage.widthAnchor.constraint(equalToConstant: 25),
            cartImage.heightAnchor.constraint(equalToConstant: 25),
            cartImage.centerXAnchor.constraint(equalTo: cartView.centerXAnchor),
            cartImage.centerYAnchor.constraint(equalTo: cartView.centerYAnchor),
            
            cartBadge.leadingAnchor.constraint(equalTo: cartImage.trailingAnchor, constant: -10),
            cartBadge.topAnchor.constraint(equalTo: cartImage.topAnchor, constant: -10),
            cartBadge.heightAnchor.constraint(equalToConstant: 20),
            cartBadge.widthAnchor.constraint(equalToConstant: 20),
            
            streamStatusView.leadingAnchor.constraint(equalTo: leadingAnchor),
            streamStatusView.topAnchor.constraint(equalTo: profileView.bottomAnchor),
            streamStatusView.heightAnchor.constraint(equalToConstant: 40),
            
            streamTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            streamTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            streamTitleLabel.topAnchor.constraint(equalTo: streamStatusView.bottomAnchor)
        ])
    }
    
    func animateViewersCount(withText count: Int) {
        
        let formattedValue = count.ism_roundedWithAbbreviations
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self else { return }
            self.viewerCountView.featureLabel.transform = .init(scaleX: 1.2, y: 1.2)
        }) { [weak self] (finished: Bool) in
            guard let self else { return }
            self.viewerCountView.featureLabel.text = formattedValue
            UIView.animate(withDuration: 0.1, animations: { [weak self] in
                guard let self else { return }
                self.viewerCountView.featureLabel.transform = .identity
            })
        }
        
    }
    
    func cartButton(canBeShown: Bool){
        cartView.isHidden = !canBeShown
        cartButton.isHidden = !canBeShown
        cartImage.isHidden = !canBeShown
        cartBadge.isHidden = !canBeShown
    }

}
