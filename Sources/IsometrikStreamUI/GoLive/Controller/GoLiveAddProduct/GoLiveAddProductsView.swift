//
//  GoLiveAddProductsView.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 23/10/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

protocol GoLiveAddProductActionDelegate {
    func didAddProductTapped()
    func didRemoveProductTapped(index: Int)
}

class GoLiveAddProductsView: UIView, ISMStreamUIAppearanceProvider {

    // MARK: - PROPERTIES
    
    var delegate: GoLiveAddProductActionDelegate?
    var productData: [StreamProductModel] = [] {
        didSet {
            self.productCollectionView.reloadData()
        }
    }
    
    let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var headerTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add Products".localized + "*"
        label.font = appearance.font.getFont(forTypo: .h5)
        label.textColor = .white
        return label
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+" + "Add".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h4)
        button.ismTapFeedBack()
        button.isHidden = true
        return button
    }()
    
    lazy var productCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AddProductCollectionViewCell.self, forCellWithReuseIdentifier: "AddProductCollectionViewCell")
        collectionView.register(DefaultAddProductCollectionViewCell.self, forCellWithReuseIdentifier: "DefaultAddProductCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.backgroundColor = .clear
        return collectionView
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
        addSubview(headerView)
        headerView.addSubview(headerTitle)
        headerView.addSubview(addButton)
        addSubview(productCollectionView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 20),
            
            headerTitle.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headerTitle.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            addButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            addButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            productCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            productCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            productCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            productCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
    }
}
