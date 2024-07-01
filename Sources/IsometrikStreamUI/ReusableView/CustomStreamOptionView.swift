//
//  CustomStreamOptionView.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 08/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

class CustomStreamOptionView: UIView {

    // MARK: - PROPERTIES
    
    let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    
    let optionImageView: UIImageView = {
        let optionImageView = UIImageView()
        optionImageView.translatesAutoresizingMaskIntoConstraints = false
        optionImageView.contentMode = .scaleAspectFit
        optionImageView.clipsToBounds = true
        return optionImageView
    }()
    
    let optionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.layer.cornerRadius = 6
        view.isHidden = true
        return view
    }()
    
    // MARK: - MAIN
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.backgroundView.layer.cornerRadius = self.frame.width / 2
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        addSubview(backgroundView)
        addSubview(optionImageView)
        addSubview(optionButton)
        addSubview(indicatorView)
    }
    
    func setupConstraints(){
        backgroundView.pin(to: self)
        optionButton.pin(to: self)
        NSLayoutConstraint.activate([
            optionImageView.widthAnchor.constraint(equalToConstant: 24),
            optionImageView.heightAnchor.constraint(equalToConstant: 24),
            optionImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            optionImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            indicatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            indicatorView.topAnchor.constraint(equalTo: topAnchor),
            indicatorView.widthAnchor.constraint(equalToConstant: 12),
            indicatorView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }

}
