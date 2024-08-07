//
//  RecordedStreamProductsView+Delegate.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 25/12/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import Foundation

//extension RecordedStreamProductsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return productData.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordedStreamProductCollectionViewCell", for: indexPath) as! RecordedStreamProductCollectionViewCell
//        cell.data = productData[indexPath.row]
//        cell.tag = indexPath.row
//        cell.delegate = self
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        delegate?.didProductTapped(index: indexPath.row)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: UIScreen.main.bounds.width * 0.85, height: 100)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//    
//}
//
//extension RecordedStreamProductsView: RecordedStreamProductsActionDelegate {
//    
//    func didProductTapped(index: Int) {}
//    
//    func addToCartButtonTapped(index: Int) {
//        delegate?.addToCartButtonTapped(index: index)
//    }
//    
//}
