//
//  RecordedStreamOptionView.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 25/12/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

enum RecordedStreamOptions: Int {
    case product = 0
    case share
    case more
}

protocol RecordedStreamOptionDelegate {
    func didRecordedStreamOptionTapped(option: RecordedStreamOptions?)
}

class RecordedStreamOptionView: UIView, ISMAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    var delegate: RecordedStreamOptionDelegate?
    
    let optionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 15
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var productOptionView: OptionView = {
        let view = OptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.optionImageView.image = appearance.images.product
        view.optionLabel.text = "Products".localized
        view.actionButton.tag = RecordedStreamOptions.product.rawValue
        view.actionButton.addTarget(self, action: #selector(didActionButtonTapped(_:)), for: .touchUpInside)
        view.isHidden = true
        return view
    }()
    
    lazy var shareOptionView: OptionView = {
        let view = OptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.optionImageView.image = appearance.images.share2
        view.optionLabel.text = "Share".localized
        view.actionButton.tag = RecordedStreamOptions.share.rawValue
        view.actionButton.addTarget(self, action: #selector(didActionButtonTapped(_:)), for: .touchUpInside)
        return view
    }()
    
    lazy var moreOptionView: OptionView = {
        let view = OptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.optionImageView.image = appearance.images.more2
        view.optionLabel.text = "More".localized
        view.actionButton.tag = RecordedStreamOptions.more.rawValue
        view.actionButton.addTarget(self, action: #selector(didActionButtonTapped(_:)), for: .touchUpInside)
        return view
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
        addSubview(optionStackView)
        optionStackView.addArrangedSubview(productOptionView)
        optionStackView.addArrangedSubview(shareOptionView)
        optionStackView.addArrangedSubview(moreOptionView)
    }
    
    func setUpConstraints(){
        optionStackView.pin(to: self)
    }
    
    // MARK: - ACTIONS
    
    @objc func didActionButtonTapped(_ sender: UIButton) {
        let option = RecordedStreamOptions(rawValue: sender.tag)
        delegate?.didRecordedStreamOptionTapped(option: option)
    }

}


class OptionView: UIView, ISMAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 2
        return stackView
    }()
    
    let optionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var optionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h9)
        label.textAlignment = .center
        return label
    }()
    
    lazy var badgeView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h9) ?? .systemFont(ofSize: 12)
        button.isHidden = true
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        button.layer.cornerRadius = 10
        return button
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        addSubview(stackView)
        stackView.addArrangedSubview(optionImageView)
        stackView.addArrangedSubview(optionLabel)
        addSubview(badgeView)
        
        addSubview(actionButton)
    }
    
    func setUpConstraints(){
        stackView.pin(to: self)
        actionButton.pin(to: self)
        NSLayoutConstraint.activate([
            optionImageView.heightAnchor.constraint(equalToConstant: 45),
            optionImageView.widthAnchor.constraint(equalToConstant: 45),
            
            badgeView.trailingAnchor.constraint(equalTo: trailingAnchor),
            badgeView.topAnchor.constraint(equalTo: topAnchor, constant: -10),
            badgeView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func addBadge(withCount: Int) {
        if withCount == 0 {
            badgeView.isHidden = true
        } else {
            badgeView.isHidden = false
            badgeView.setTitle("\(withCount)", for: .normal)
        }
    }
    
}


