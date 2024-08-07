//
//  RecordedStreamProductsView.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 25/12/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

protocol RecordedStreamProductsActionDelegate {
    func didProductTapped(index: Int)
    func addToCartButtonTapped(index: Int)
}

class RecordedStreamProductsView: UIView {

    // MARK: - PROPERTIES
    
//    var delegate: RecordedStreamProductsActionDelegate?
//    var productData: [StreamProductModel] = [] {
//        didSet {
//            self.productCollectionView.reloadData()
//        }
//    }
//    
//    lazy var productCollectionView: UICollectionView = {
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        collectionView.setCollectionViewLayout(layout, animated: true)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.register(RecordedStreamProductCollectionViewCell.self, forCellWithReuseIdentifier: "RecordedStreamProductCollectionViewCell")
//        collectionView.backgroundColor = .clear
//        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
//        return collectionView
//    }()
//    
//    // MARK: MAIN -
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setUpViews()
//        setUpConstraints()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: FUNCTIONS -
//    
//    func setUpViews(){
//        addSubview(productCollectionView)
//    }
//    
//    func setUpConstraints(){
//        productCollectionView.pin(to: self)
//    }
    
}
