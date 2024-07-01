//
//  GoLiveUploaderLoaderView.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 06/02/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit

class GoLiveUploaderLoaderView: UIView {

    // MARK: - PROPERTIES
    
    let coverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Uploading..."
        label.font = Appearance.default.font.getFont(forTypo: .h6)
        return label
    }()

    let progressView: UIProgressView = {
        let view = UIProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.progressTintColor = .black
        view.progress = 0.2
        return view
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .medium
        indicator.startAnimating()
        indicator.color = .black
        return indicator
    }()
    
    
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
        addSubview(coverView)
        addSubview(cardView)
        cardView.addSubview(infoLabel)
        cardView.addSubview(progressView)
        cardView.addSubview(activityIndicator)
    }
    
    func setUpConstraints(){
        coverView.pin(to: self)
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            cardView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            infoLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 30),
            infoLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -30),
            infoLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 35),

            progressView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 30),
            progressView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -30),
            progressView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 15),
            progressView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -35),
            
            activityIndicator.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            activityIndicator.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
        ])
    }

}
