//
//  CustomHeaderView.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 23/10/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

public class CustomHeaderView: UIView, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    public lazy var headerTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = appearance.font.getFont(forTypo: .h4)
        return label
    }()
    
    // Leading action button
    
    public let leadingActionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.axis = .horizontal
        return stackView
    }()
    
    public let leadingActionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.ismTapFeedBack()
        button.isHidden = true
        return button
    }()
    
    //:
    
    // Trailing action button
    
    public let trailingActionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.axis = .horizontal
        return stackView
    }()
    
    public let trailingActionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.ismTapFeedBack()
        button.isHidden = true
        return button
    }()
    
    //:
    
    // Trailing action button
    
    public let trailingActionButton2: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.ismTapFeedBack()
        button.isHidden = true
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        button.layer.cornerRadius = 17.5
        return button
    }()
    
    //:
    
    public let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return view
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
        addSubview(headerTitle)
        
        addSubview(trailingActionStackView)
        trailingActionStackView.addArrangedSubview(trailingActionButton)
        
        addSubview(leadingActionStackView)
        leadingActionStackView.addArrangedSubview(leadingActionButton)
        
        addSubview(trailingActionButton2)
        addSubview(dividerView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            headerTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
            headerTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            headerTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            leadingActionStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            leadingActionStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            leadingActionStackView.heightAnchor.constraint(equalToConstant: 35),
            
            leadingActionButton.heightAnchor.constraint(equalToConstant: 35),
            leadingActionButton.widthAnchor.constraint(equalToConstant: 35),
            
            trailingActionStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            trailingActionStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingActionStackView.heightAnchor.constraint(equalToConstant: 40),
            
            trailingActionButton.heightAnchor.constraint(equalToConstant: 40),
            trailingActionButton.widthAnchor.constraint(equalToConstant: 40),
            
            trailingActionButton2.heightAnchor.constraint(equalToConstant: 35),
            trailingActionButton2.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingActionButton2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            dividerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1.5)
        ])
    }
    
    public func attributedHeaderTitle(title: String, subtitle: String) -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(title)\n", attributes: [
            NSAttributedString.Key.font: appearance.font.getFont(forTypo: .h8)!,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]))
        
        attributedString.append(NSAttributedString(string: "\(subtitle)", attributes: [
            NSAttributedString.Key.font: appearance.font.getFont(forTypo: .h3)!,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]))
        
        return attributedString
        
    }

}
