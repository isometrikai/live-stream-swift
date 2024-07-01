//
//  SelectedProductCollectionViewCell.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 26/10/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

protocol SelectedProductActionDelegate {
    func didProductRemoved(with index: Int)
}

class SelectedProductCollectionViewCell: UICollectionViewCell, AppearanceProvider {
    
    // MARK: - PROPERTIES
    
    var delegate: SelectedProductActionDelegate?
    var data: StreamProductModel? {
        didSet {
            manageData()
        }
    }
    
    let productCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        view.layer.borderWidth = 1
        view.layer.masksToBounds = true
        return view
    }()
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let infoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
//        Fonts.setFont(label, fontFamiy: .monstserrat(.Medium), size: .custom(10) ,color: .white)
        label.textAlignment = .center
        return label
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.close, for: .normal)
        button.backgroundColor = .black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.ismTapFeedBack()
        return button
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
        addSubview(productCoverView)
        productCoverView.addSubview(productImageView)
        
        productCoverView.addSubview(infoView)
        infoView.addSubview(infoLabel)
        
        addSubview(closeButton)
    }
    
    func setupConstraints(){
        productCoverView.ism_pin(to: self)
        productImageView.ism_pin(to: productCoverView)
        NSLayoutConstraint.activate([
            infoView.leadingAnchor.constraint(equalTo: productCoverView.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: productCoverView.trailingAnchor),
            infoView.bottomAnchor.constraint(equalTo: productCoverView.bottomAnchor),
            infoView.heightAnchor.constraint(equalToConstant: 22),
            
            infoLabel.centerYAnchor.constraint(equalTo: infoView.centerYAnchor),
            infoLabel.centerXAnchor.constraint(equalTo: infoView.centerXAnchor),
            
            closeButton.trailingAnchor.constraint(equalTo: productCoverView.trailingAnchor, constant: -5),
            closeButton.widthAnchor.constraint(equalToConstant: 20),
            closeButton.heightAnchor.constraint(equalToConstant: 20),
            closeButton.topAnchor.constraint(equalTo: productCoverView.topAnchor, constant: 5)
        ])
    }
    
    func manageData(){
        guard let data else { return }
        
        let imageStringURL = data.images?.first?.small ?? ""
        
        if let imgURL = URL(string: imageStringURL) {
            productImageView.kf.setImage(with: imgURL)
        }
        
        infoView.isHidden = Int(data.liveStreamfinalPriceList?.discountPercentage ?? 0) == 0 ? true : false
        infoLabel.text = "\(data.liveStreamfinalPriceList?.discountPercentage ?? 0)% off"
        
    }
    
    @objc func closeButtonTapped(){
        delegate?.didProductRemoved(with: self.tag)
    }
    
}
