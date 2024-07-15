//
//  YouAreLivePopUpViewController.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 03/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

// End view tap.
enum YouAreTap {
    case cancelTap
    case okTap
}

/// You are  video view controller protocols.
protocol YouAreLivePopUpViewControllerProtocol: AnyObject {
    func tapButtonClick(tap: YouAreTap)
}

class YouAreLivePopUpViewController: UIViewController, ISMStreamUIAppearanceProvider {

    // MARK: - PROPERTIES
    
    weak var delegate: YouAreLivePopUpViewControllerProtocol?
    
    lazy var backCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()
    
    lazy var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = appearance.colors.appDarkGray
        return view
    }()
    
    lazy var crownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = appearance.images.live
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You’re LIVE"
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h4)
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "We’ve sent a notification to your followers. Your fans will start to join soon"
        label.font = appearance.font.getFont(forTypo: .h6)
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var okButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OK".localized, for: .normal)
        button.setTitleColor(appearance.colors.appSecondary, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h6)
        button.backgroundColor = appearance.colors.appColor
        button.ismTapFeedBack()
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 26.5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var safeAreaCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = appearance.colors.appDarkGray
        return view
    }()
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        view.backgroundColor = .clear
        view.addSubview(backCoverView)
        view.addSubview(cardView)
        cardView.addSubview(crownImageView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(subtitleLabel)
        cardView.addSubview(okButton)
        view.addSubview(safeAreaCoverView)
    }
    
    func setupConstraints(){
        backCoverView.ism_pin(to: view)
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 250),
            cardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            safeAreaCoverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            safeAreaCoverView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            safeAreaCoverView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            safeAreaCoverView.heightAnchor.constraint(equalToConstant: ism_windowConstant.getBottomPadding),
            
            crownImageView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            crownImageView.widthAnchor.constraint(equalToConstant: 110),
            crownImageView.heightAnchor.constraint(equalToConstant: 110),
            crownImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: -55),
            
            titleLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: crownImageView.bottomAnchor, constant: 5),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            
            okButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 30),
            okButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -30),
            okButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -30),
            okButton.heightAnchor.constraint(equalToConstant: 53)
        ])
    }
    
    // MARK: - ACTION
    
    @objc func okButtonTapped(){
        if delegate != nil {
            delegate?.tapButtonClick(tap: .okTap)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func dismissController(){
        dismiss(animated: true, completion: nil)
    }

}
