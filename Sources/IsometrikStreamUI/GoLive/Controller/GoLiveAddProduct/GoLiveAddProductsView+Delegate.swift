//
//  GoLiveAddProductsView+Delegate.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 23/10/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

extension GoLiveAddProductsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if productData.count == 0 {
           return 1
        }
        return productData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if productData.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultAddProductCollectionViewCell", for: indexPath) as! DefaultAddProductCollectionViewCell
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddProductCollectionViewCell", for: indexPath) as! AddProductCollectionViewCell
        cell.data = productData[indexPath.row]
        cell.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if productData.count == 0 {
            return CGSize(width: self.frame.width - 40, height: 130)
        }
        return CGSize(width: 160, height: 235)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if productData.count == 0 {
            delegate?.didAddProductTapped()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

extension GoLiveAddProductsView: AddProductActionDelegate {
    
    func didClearTapped(index: Int) {
        delegate?.didRemoveProductTapped(index: index)
    }
    
}
