//
//  GoLiveProfileView.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 09/01/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit

class GoLiveProfileView: UIView, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var delegate: GoLiveHeaderActionDelegate?
    
    // PROFILE COVER VIEW
    
    let profileCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.backgroundColor = .white.withAlphaComponent(0.1)
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        view.layer.borderWidth = 1
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
    
    // MARK: MAIN -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        
        addSubview(profileCoverView)
        profileCoverView.addSubview(placeHolderImageView)
        profileCoverView.addSubview(placeHolderTitle)
        profileCoverView.addSubview(profileCoverImageView)
        profileCoverView.addSubview(profileActionButton)
        profileCoverView.addSubview(clearImageButton)
        
        addSubview(textCoverView)
        textCoverView.addSubview(streamTextView)
        
    }
    
    func setUpConstraints(){
        profileActionButton.ism_pin(to: profileCoverView)
        profileCoverImageView.ism_pin(to: profileCoverView)
        NSLayoutConstraint.activate([
            
            profileCoverView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileCoverView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
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
            placeHolderTitle.topAnchor.constraint(equalTo: placeHolderImageView.bottomAnchor, constant: 5),
            
            textCoverView.leadingAnchor.constraint(equalTo: profileCoverView.trailingAnchor, constant: 10),
            textCoverView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            textCoverView.heightAnchor.constraint(equalToConstant: 100 * 4/3),
            textCoverView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            streamTextView.leadingAnchor.constraint(equalTo: textCoverView.leadingAnchor, constant: 5),
            streamTextView.trailingAnchor.constraint(equalTo: textCoverView.trailingAnchor, constant: -5),
            streamTextView.topAnchor.constraint(equalTo: textCoverView.topAnchor),
            streamTextView.bottomAnchor.constraint(equalTo: textCoverView.bottomAnchor)
            
        ])
        
    }
    
    // MARK: - ACTIONS
    
    @objc func selectProfileTapped(){
        delegate?.didSelectProfileTapped()
    }
    
    @objc func clearImageTapped(){
        delegate?.didClearImageButtonTapped()
    }

}

extension GoLiveProfileView: UITextViewDelegate {
    
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
