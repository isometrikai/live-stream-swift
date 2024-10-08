//
//  PKChallengeCustomBannerView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 29/11/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import UIKit

class PKChallengeCustomBannerView: UIView, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    lazy var bannerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = appearance.images.winnersCup
        return imageView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Winner takes all".localized
        label.font = appearance.font.getFont(forTypo: .h4)
        label.textColor = appearance.colors.appGreen
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This would transfer all the gifts earned by the looser to the winner".localized
        label.numberOfLines = 0
        label.textColor = .black
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
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        backgroundColor = appearance.colors.appLightGreen
        addSubview(bannerImage)
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            bannerImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bannerImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            bannerImage.widthAnchor.constraint(equalToConstant: 60),
            bannerImage.heightAnchor.constraint(equalToConstant: 80),
            
            stackView.leadingAnchor.constraint(equalTo: bannerImage.trailingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}
