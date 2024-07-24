//
//  StreamStatusView.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 24/03/22.
//

import UIKit

class StreamStatusView: UIView, ISMAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()
    
    lazy var liveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Live".localized, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h7)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 2
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        return button
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    let memberCountView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    lazy var memberIconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = appearance.images.user.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var memberCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h8)
        return label
    }()
    
    let memberCountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Linked product view
    
    let linkedProductsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray.withAlphaComponent(0.5)
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 5
        view.isHidden = true
        return view
    }()
    
    let shoppingBagIconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "ism_ic_shopping_bag")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        return imageView
    }()
    
    lazy var linkedProductCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h8)
        label.text = ""
        label.textAlignment = .center
        return label
    }()
    
    let linkedProductButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //:
    
    // MARK: - Hourly ranking button
    
    lazy var hourlyRankingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("  " + "Hourly Ranking".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = appearance.colors.appColor
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h8)
        button.layer.cornerCurve = .continuous
        button.setImage(UIImage(systemName: "flame")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = appearance.colors.appColor
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        button.layer.cornerRadius = 5
        button.ismTapFeedBack()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        button.layer.cornerRadius = 12.5
        button.backgroundColor = .black.withAlphaComponent(0.4)
        button.isHidden = true
        return button
    }()
    
    //:
    
    // MARK: - Now featuring product Button
    
    lazy var nowFeaturingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Now Featuring", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = appearance.colors.appColor
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h7)
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 5
        button.isHidden = true
        button.ismTapFeedBack()
        return button
    }()
    
    //:
    
    // MARK: - Paid stream
    
    lazy var paidStreamButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.coin, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h7)
        button.ismTapFeedBack()
        return button
    }()
    
    //:
    
    // MARK: - Moderator
    
    lazy var moderatorButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.moderator.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        button.ismTapFeedBack()
        button.backgroundColor = .black.withAlphaComponent(0.4)
        button.layer.cornerRadius = 12.5
        return button
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
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(liveButton)
        stackView.addArrangedSubview(timeLabel)
        
//        stackView.addArrangedSubview(memberCountView)
//        memberCountView.addSubview(memberIconImage)
//        memberCountView.addSubview(memberCountLabel)
//        memberCountView.addSubview(memberCountButton)
        
        //stackView.addArrangedSubview(hourlyRankingButton)
        
//        stackView.addArrangedSubview(linkedProductsView)
//        linkedProductsView.addSubview(shoppingBagIconImage)
//        linkedProductsView.addSubview(linkedProductCountLabel)
//        linkedProductsView.addSubview(linkedProductButton)
        
        //stackView.addArrangedSubview(nowFeaturingButton)
        
        //stackView.addArrangedSubview(paidStreamButton)
        stackView.addArrangedSubview(moderatorButton)
        
    }
    
    func setupConstraints(){
        //memberCountButton.ism_pin(to: memberCountView)
        //linkedProductButton.ism_pin(to: linkedProductsView)
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            liveButton.heightAnchor.constraint(equalToConstant: 18),
            
//            memberIconImage.leadingAnchor.constraint(equalTo: memberCountView.leadingAnchor, constant: 5),
//            memberIconImage.widthAnchor.constraint(equalToConstant: 15),
//            memberIconImage.heightAnchor.constraint(equalToConstant: 15),
//            memberIconImage.centerYAnchor.constraint(equalTo: memberCountView.centerYAnchor),
//
//            memberCountLabel.leadingAnchor.constraint(equalTo: memberIconImage.trailingAnchor, constant: 5),
//            memberCountLabel.trailingAnchor.constraint(equalTo: memberCountView.trailingAnchor, constant: -5),
//            memberCountLabel.centerYAnchor.constraint(equalTo: memberCountView.centerYAnchor),
            
//            hourlyRankingButton.leadingAnchor.constraint(equalTo: memberCountLabel.trailingAnchor, constant: 8),
//            hourlyRankingButton.heightAnchor.constraint(equalToConstant: 25),
//            hourlyRankingButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
//            linkedProductsView.heightAnchor.constraint(equalToConstant: 30),
//            linkedProductsView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
//
//            shoppingBagIconImage.leadingAnchor.constraint(equalTo: linkedProductsView.leadingAnchor, constant: 5),
//            shoppingBagIconImage.widthAnchor.constraint(equalToConstant: 20),
//            shoppingBagIconImage.heightAnchor.constraint(equalToConstant: 20),
//            shoppingBagIconImage.centerYAnchor.constraint(equalTo: linkedProductsView.centerYAnchor),
//
//            linkedProductCountLabel.leadingAnchor.constraint(equalTo: shoppingBagIconImage.trailingAnchor, constant: 5),
//            linkedProductCountLabel.trailingAnchor.constraint(equalTo: linkedProductsView.trailingAnchor, constant: -5),
//            linkedProductCountLabel.centerYAnchor.constraint(equalTo: linkedProductsView.centerYAnchor),
//
//            nowFeaturingButton.widthAnchor.constraint(equalToConstant: 100),
//            nowFeaturingButton.heightAnchor.constraint(equalToConstant: 30),
//
//            paidStreamButton.heightAnchor.constraint(equalToConstant: 30),
            
            moderatorButton.heightAnchor.constraint(equalToConstant: 25),
            moderatorButton.widthAnchor.constraint(equalToConstant: 35)
            
        ])
    }
    
}
