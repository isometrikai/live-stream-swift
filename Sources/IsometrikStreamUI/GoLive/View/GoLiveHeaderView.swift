//
//  NewGoLiveHeaderView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 07/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

enum GoLiveActionType {
    case paid
    case free
}

protocol GoLiveHeaderActionDelegate {
    func didCloseButtonTapped()
    func didActionButtonTapped(with actionType: GoLiveActionType)
    func didSelectProfileTapped()
    func didClearImageButtonTapped()
}

class GoLiveHeaderView: UIView, ISMStreamUIAppearanceProvider {

    // MARK: - PROPERTIES
    
    var delegate: GoLiveHeaderActionDelegate?

    // HEADER VIEW
    
    let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var headerTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Go Live".localized
        label.textColor = .white
        label.textAlignment = .center
        label.font = appearance.font.getFont(forTypo: .h3)
        return label
    }()
    
    lazy var warningButtonView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Broadcasters under 18 are not permitted".localized + ".", for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h8)
        button.layer.cornerRadius = 17.5
        button.backgroundColor = UIColor.ism_hexStringToUIColor(hex: "#FF5858")
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.isHidden = true
        return button
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.close.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //:
    
    // PAID ACTION BUTTONS

    let premiumOptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.isHidden = true
        return stackView
    }()
    
    lazy var freeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.tintColor = .white
        button.setTitle("Free".ism_localized, for: .normal)
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = .white.withAlphaComponent(0.3)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h8)
        button.tag = 1
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(paidStreamButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var premiumButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.tintColor = .white
        button.setTitle("Premium".ism_localized, for: .normal)
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = .white.withAlphaComponent(0.3)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h8)
        button.tag = 2
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(paidStreamButton(_:)), for: .touchUpInside)

        return button
    }()
    
    //:
    
    // PROFILE COVER VIEW
    
    let profileCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.backgroundColor = .white.withAlphaComponent(0.1)
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        view.layer.borderWidth = 1
        view.isHidden = true
        return view
    }()
    
    lazy var placeHolderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = appearance.images.add.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        return imageView
    }()
    
    lazy var placeHolderTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "+" + " " + "Add Cover".localized
        label.textColor = .white
        label.textAlignment = .center
        label.font = appearance.font.getFont(forTypo: .h8)
        return label
    }()
    
    let profileCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var profileActionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(selectProfileTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var clearImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.close, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.ismTapFeedBack()
        button.isHidden = true
        button.addTarget(self, action: #selector(clearImageTapped), for: .touchUpInside)
        return button
    }()
    
    //:
    
    // STREAM TITLE VIEW
    
    let textCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.isHidden = true
        return view
    }()
    
    lazy var streamTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.text = "My Stream description...".localized
        textView.textColor = .lightGray
        textView.backgroundColor = .clear
        textView.tintColor = .white
        textView.font = appearance.font.getFont(forTypo: .h8)
        return textView
    }()
    
    //:
    
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
        
        addSubview(headerView)
        headerView.addSubview(headerTitle)
        headerView.addSubview(warningButtonView)
        headerView.addSubview(closeButton)
        
        addSubview(premiumOptionStackView)
        premiumOptionStackView.addArrangedSubview(freeButton)
        premiumOptionStackView.addArrangedSubview(premiumButton)
        
        addSubview(profileCoverView)
        profileCoverView.addSubview(placeHolderImageView)
        profileCoverView.addSubview(placeHolderTitle)
        profileCoverView.addSubview(profileCoverImageView)
        profileCoverView.addSubview(profileActionButton)
        profileCoverView.addSubview(clearImageButton)
        
        addSubview(textCoverView)
        textCoverView.addSubview(streamTextView)
    }
    
    func setupConstraints(){
        
        profileCoverImageView.ism_pin(to: profileCoverView)
        profileActionButton.ism_pin(to: profileCoverView)
        
        NSLayoutConstraint.activate([
            
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            headerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            
            headerTitle.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            headerTitle.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            headerTitle.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            closeButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            closeButton.widthAnchor.constraint(equalToConstant: 35),
            closeButton.heightAnchor.constraint(equalToConstant: 35),
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            warningButtonView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            warningButtonView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            warningButtonView.heightAnchor.constraint(equalToConstant: 35),
            
            premiumOptionStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            premiumOptionStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            premiumOptionStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 5),
            premiumOptionStackView.heightAnchor.constraint(equalToConstant: 45),
            
            profileCoverView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileCoverView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            profileCoverView.widthAnchor.constraint(equalToConstant: 100),
            profileCoverView.heightAnchor.constraint(equalToConstant: 100 * 4/3),
            
            clearImageButton.trailingAnchor.constraint(equalTo: profileCoverView.trailingAnchor, constant: -7),
            clearImageButton.topAnchor.constraint(equalTo: profileCoverView.topAnchor, constant: 7),
            clearImageButton.widthAnchor.constraint(equalToConstant: 20),
            clearImageButton.heightAnchor.constraint(equalToConstant: 20),
            
            placeHolderImageView.centerXAnchor.constraint(equalTo: profileCoverView.centerXAnchor),
            placeHolderImageView.centerYAnchor.constraint(equalTo: profileCoverView.centerYAnchor, constant: -8),
            placeHolderImageView.widthAnchor.constraint(equalToConstant: 30),
            placeHolderImageView.heightAnchor.constraint(equalToConstant: 30),
            
            placeHolderTitle.leadingAnchor.constraint(equalTo: profileCoverView.leadingAnchor, constant: 2),
            placeHolderTitle.trailingAnchor.constraint(equalTo: profileCoverView.trailingAnchor, constant: -2),
            placeHolderTitle.topAnchor.constraint(equalTo: placeHolderImageView.bottomAnchor, constant: 8),
            
            textCoverView.leadingAnchor.constraint(equalTo: profileCoverView.trailingAnchor, constant: 10),
            textCoverView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            textCoverView.heightAnchor.constraint(equalToConstant: 100 * 4/3),
            textCoverView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            
            streamTextView.leadingAnchor.constraint(equalTo: textCoverView.leadingAnchor, constant: 5),
            streamTextView.trailingAnchor.constraint(equalTo: textCoverView.trailingAnchor, constant: -5),
            streamTextView.topAnchor.constraint(equalTo: textCoverView.topAnchor),
            streamTextView.bottomAnchor.constraint(equalTo: textCoverView.bottomAnchor)
            
        ])
        
    }
    
    func animatePaidStreamsButton(isPremium: Bool) {
        if isPremium {
            premiumButton.backgroundColor = appearance.colors.appColor
            premiumButton.layer.borderWidth = 0
            
            freeButton.backgroundColor = .white.withAlphaComponent(0.3)
            freeButton.layer.borderWidth = 1.5
        } else {
            freeButton.backgroundColor = appearance.colors.appColor
            freeButton.layer.borderWidth = 0
            
            premiumButton.backgroundColor = .white.withAlphaComponent(0.3)
            premiumButton.layer.borderWidth = 1.5
            
            // change the title too
            premiumButton.setTitle(" " + "Premium".ism_localized, for: .normal)
            //premiumButton.setImage(UIImage(named: "ism_Classic"), for: .normal)
        }
    }
    
    // MARK: - ACTIONS
    
    @objc func closeButtonTapped(){
        delegate?.didCloseButtonTapped()
    }
    
    @objc func paidStreamButton(_ sender: UIButton){
        
        var actionType: GoLiveActionType = .free
        actionType = sender.tag == 1 ? .free : .paid
        delegate?.didActionButtonTapped(with: actionType)
        
        let isPremium = sender.tag == 2
        animatePaidStreamsButton(isPremium: isPremium)
        
    }
    
    @objc func selectProfileTapped(){
        delegate?.didSelectProfileTapped()
    }
    
    @objc func clearImageTapped(){
        delegate?.didClearImageButtonTapped()
    }

}

extension GoLiveHeaderView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "My Stream description...".localized
            textView.textColor = UIColor.lightGray
        }
    }
    
}
