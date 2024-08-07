//
//  CustomStreamLoaderView.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 31/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit
import IsometrikStream

class CustomStreamLoaderView: UIView, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    let circularLayer = CAShapeLayer()
    var timer = Timer()
    
    // MARK: - Thumbnail for pk
    
    let thumbStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.isHidden = true
        return stackView
    }()
    
    let thumb1ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let thumb2ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    //:
    
    
    lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = appearance.colors.appColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let backCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.8)
        return view
    }()
    
    lazy var closeActionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.close.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        return button
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let defaultProfileView: CustomDefaultProfileView = {
        let view = CustomDefaultProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        return view
    }()
    
    let layerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - MAIN
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setUpLayer()
        layerScaleAnimation(true)
        layerLineWidthAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        addSubview(thumbnailImageView)
        
        addSubview(thumbStack)
        thumbStack.addArrangedSubview(thumb1ImageView)
        thumbStack.addArrangedSubview(thumb2ImageView)
        
        addSubview(backCoverView)
        addSubview(closeActionButton)
        addSubview(layerView)
        addSubview(defaultProfileView)
        addSubview(profileImageView)
    }
    
    func setupConstraints(){
        backCoverView.ism_pin(to: self)
        thumbnailImageView.ism_pin(to: self)
        thumbStack.ism_pin(to: self)
        NSLayoutConstraint.activate([
            closeActionButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeActionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            closeActionButton.heightAnchor.constraint(equalToConstant: 40),
            closeActionButton.widthAnchor.constraint(equalToConstant: 40),
            
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            
            defaultProfileView.centerYAnchor.constraint(equalTo: centerYAnchor),
            defaultProfileView.centerXAnchor.constraint(equalTo: centerXAnchor),
            defaultProfileView.widthAnchor.constraint(equalToConstant: 50),
            defaultProfileView.heightAnchor.constraint(equalToConstant: 50),
            
            layerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            layerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            layerView.widthAnchor.constraint(equalToConstant: 50),
            layerView.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func setUpLayer(){
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 35, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        circularLayer.strokeColor = UIColor(red: 225/225, green: 48/255, blue: 108/255, alpha: 1).cgColor
        circularLayer.fillColor = UIColor.clear.cgColor
        circularLayer.lineWidth = 3
        circularLayer.path = circularPath.cgPath
        circularLayer.position = CGPoint(x: 25, y: 25)
        
        circularLayer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        circularLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        circularLayer.shadowOpacity = 1.0
        circularLayer.shadowRadius = 10.0
        
        layerView.layer.addSublayer(circularLayer)
    }
    
    func layerScaleAnimation( _ scale: Bool){
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        if scale {
            scaleAnimation.duration = 0.4
            scaleAnimation.fromValue = 1.0
            scaleAnimation.toValue = 1.1
            scaleAnimation.fillMode = .forwards
            scaleAnimation.isRemovedOnCompletion = false
            circularLayer.strokeColor = appearance.colors.appColor.withAlphaComponent(0.8).cgColor
        } else {
            scaleAnimation.duration = 0.2
            scaleAnimation.fromValue = 1.1
            scaleAnimation.toValue = 1.0
            scaleAnimation.fillMode = .backwards
            scaleAnimation.isRemovedOnCompletion = true
            circularLayer.strokeColor = UIColor.red.cgColor
        }
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        circularLayer.add(scaleAnimation, forKey: "scale")
    }
    
    func layerLineWidthAnimation(){
        let animation = CABasicAnimation(keyPath: "lineWidth")
        animation.duration = 0.7
        animation.fromValue = 1
        animation.toValue = 10
        animation.repeatCount = .greatestFiniteMagnitude
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.autoreverses = true
        circularLayer.add(animation, forKey: "width")
    }
    
    func manageData(streamData: ISMStream){
        
        let firstName = streamData.userDetails?.firstName ?? ""
        let lastName = streamData.userDetails?.lastName ?? ""
        let userName = streamData.userDetails?.userName ?? ""
        let memberImage = streamData.userDetails?.userProfile ?? ""
        
        if memberImage != UserDefaultsProvider.shared.getIsometrikDefaultProfile() {
            if let profileURL = URL(string: memberImage) {
                profileImageView.kf.setImage(with: profileURL)
            }
        } else {
            profileImageView.image = UIImage()
        }
        
        if !firstName.isEmpty && !lastName.isEmpty {
            defaultProfileView.initialsText.text = "\(firstName.prefix(1))\(lastName.prefix(1))".uppercased()
        } else {
            defaultProfileView.initialsText.text = "\(userName.prefix(2))".uppercased()
        }
        
        
        if let streamImageURlString = streamData.streamImage {
            if let url = URL(string: streamImageURlString) {
                thumbnailImageView.kf.setImage(with: url)
            }
        }
        
    }

}
