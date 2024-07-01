//
//  SelectedProductCustomHeaderView.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 26/10/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

class SelectedProductCustomHeaderView: UIView {

    // MARK: - PROPERTIES
    
    var delegate: SelectedProductActionDelegate?
    
    var productData: [StreamProductModel] = [] {
        didSet {
            selectedProductLabel.text = "Selected".localized + " (\(productData.count))"
            self.productCollectionView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                if self.productData.count > 0 {
                    let index = self.productData.count - 1
                    self.productCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .bottom, animated: true)
                }
            }
        }
    }
    
    let selectedProductLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0 " + "Selected".localized
//        Fonts.setFont(label, fontFamiy: .monstserrat(.Medium), size: .custom(15), color: .black)
        return label
    }()
    
    lazy var productCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SelectedProductCollectionViewCell.self, forCellWithReuseIdentifier: "SelectedProductCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return collectionView
    }()
    
    let dividerView: UIView = {
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
        backgroundColor = .white
        addSubview(productCollectionView)
        addSubview(selectedProductLabel)
        addSubview(dividerView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            
            selectedProductLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            selectedProductLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            selectedProductLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            productCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            productCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            productCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            productCollectionView.heightAnchor.constraint(equalToConstant: 90),
            
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            dividerView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }

}

extension SelectedProductCustomHeaderView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedProductCollectionViewCell", for: indexPath) as! SelectedProductCollectionViewCell
        cell.data = productData[indexPath.row]
        cell.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}

extension SelectedProductCustomHeaderView: SelectedProductActionDelegate {
    
    func didProductRemoved(with index: Int) {
        delegate?.didProductRemoved(with: index)
    }
    
}
