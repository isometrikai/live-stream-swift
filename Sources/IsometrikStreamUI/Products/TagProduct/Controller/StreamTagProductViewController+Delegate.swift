//
//  StreamTagProductViewController+Delegate.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 21/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import MBProgressHUD

extension StreamTagProductViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productViewModel.taggedProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StreamTagProductTableViewCell", for: indexPath) as! StreamTagProductTableViewCell
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        cell.delegate = self
        cell.tag = indexPath.row
        cell.contentView.isUserInteractionEnabled = false
        
        cell.productViewModel = productViewModel
        let productList = productViewModel.taggedProductList
        if productList.count > 0 {
            let productData = productList[indexPath.row]
            cell.productData = productData
            print(productData)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        guard !productViewModel.taggedProductList.isEmpty else { return }
//        
//        let productData = productViewModel.taggedProductList[indexPath.row]
//        let productId = productData.childProductID ?? ""
//        let parentProductID = productData.parentProductID ?? ""
//        let storeId = productData.supplier?.id ?? ""
//        let streamerUserId = productViewModel.streamInfo?.userDetails?.id ?? ""
//        let offersData = productData.offers ?? []
//        
//        let pdpVC = ItemDetailVC.instantiate(storyBoardName: "Cart") as ItemDetailVC
//        pdpVC.productIds = ProductsIds(productId: productId, parentProductId: parentProductID)
//        pdpVC.storeId = storeId
//        pdpVC.isLiveUserHost = (streamerUserId == Utility.getUserid()) ? true : false
//        pdpVC.isFromLiveStream = true
//        
//        if offersData.count > 0 {
//            let offerData = try! JSONEncoder().encode(offersData.first)
//            if let offer = productViewModel.getOfferFromData(offerData: offerData) {
//                pdpVC.liveStreamoffer = offer
//            }
//        }
//        
//        pdpVC.hidesBottomBarWhenPushed = true
//        
//        self.navigationController?.pushViewController(pdpVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension StreamTagProductViewController: TaggedProductDelegate {
    
    func didPinItemTapped(index: Int) {
        
        if !(productViewModel.taggedProductList.count > 0) { return }
        let productId = productViewModel.taggedProductList[index].childProductID.unwrap
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        productViewModel.pinProduct(productId: productId) { success, error in
            MBProgressHUD.hide(for: self.view, animated: true)
            if success {
                let pinnedProductData = self.productViewModel.pinnedProductData
                print("Pinned Product Data :: \(self.productViewModel.pinnedProductData)")
                
                // pass data back and show the pinned product data
                self.productViewModel.pinnedProduct_Callback?(self.productViewModel)
                
                // dismiss the controller
                self.dismiss(animated: true)
                
            } else {
                print(error)
            }
            
        }
        
    }
    
}
