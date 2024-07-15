//
//  StreamTaggedProductList+Delegate.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 24/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

extension StreamTaggedProductList: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let productViewModel else { return Int() }
        return productViewModel.taggedProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let productViewModel else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaggedProductListTableViewCell", for: indexPath) as! TaggedProductListTableViewCell
        cell.isFromScheduleStream = productViewModel.isStreamScheduled()
        if productViewModel.taggedProductList.count > 0 {
            cell.data = productViewModel.taggedProductList[indexPath.row]
        }
        cell.selectionStyle = .none
        cell.delegate = self
        cell.tag = indexPath.row
        cell.contentView.isUserInteractionEnabled = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        guard let productViewModel, !productViewModel.taggedProductList.isEmpty else { return }
//        
//        let productData = productViewModel.taggedProductList[indexPath.row]
//        let productId = productData.childProductID ?? ""
//        let parentProductID = productData.parentProductID ?? ""
//        let storeId = productData.supplier?.id ?? ""
//        let streamerUserId = productViewModel.streamInfo?.userDetails?.id ?? ""
//        let offersData = productData.offers ?? []
//        
//        let pdpVC = ItemDetailVC.instantiate(storyBoardName: "Cart") as ItemDetailVC
//        
//        pdpVC.productIds = ProductsIds(productId: productId, parentProductId: parentProductID)
//        pdpVC.storeId = storeId
//        pdpVC.isFromLiveStream = true
//        
//        if productViewModel.isStreamScheduled() {
//            pdpVC.isFromScheduledStream = true
//        } else {
//            pdpVC.isLiveUserHost = streamerUserId == Utility.getUserid() ? true : false
//            
//            if offersData.count > 0 {
//                let offerData = try! JSONEncoder().encode(offersData.first)
//                if let offer = productViewModel.getOfferFromData(offerData: offerData) {
//                    pdpVC.liveStreamoffer = offer
//                }
//            }
//        }
//        
//        pdpVC.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(pdpVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}

extension StreamTaggedProductList: TaggedProductListActionDelegate {
    
    func didAddToCartTapped(_ index: Int) {
        guard let productViewModel else { return  }
        let productData = productViewModel.taggedProductList[index]
        let productId = productData.childProductID
        
        // if scheduled stream, add to cart
        if productViewModel.isStreamScheduled() {
            
            productViewModel.addProductToCart(productId: productId, buyNow: false, withLiveStreamOffer: false) { success, error in
                if success {
                    UIDevice.vibrate()
                    print("Added to cart")
                    // callback for cart count updates
                    productViewModel.cartUpdates_callback?()
                }
            }
            
            return
        }
        
        // normal flow for buy from live stream
        DispatchQueue.main.async {
            CustomLoader.shared.startLoading()
        }
        productViewModel.addProductToCart(productData: productData, buyNow: true) { success, error in
            CustomLoader.shared.stopLoading()
            if success {
//                // update cart badge
//                //visibleCell.setHeaderCartBadgeUpdates()
//                if productViewModel.savedAddressVM.addressData.count == 0 {
//                    let manageAddressVC = SavedAddressVC.instantiate(storyBoardName: "EComm") as SavedAddressVC
//                    manageAddressVC.vcType = .checkOut
//                    manageAddressVC.hidesBottomBarWhenPushed = true
//                    manageAddressVC.isBuyNowFlow = true
//                    manageAddressVC.callback = { (status) -> Void in
//                        self.placeOrder()
//                    }
//                    let navVC = UINavigationController(rootViewController: manageAddressVC)
//                    self.navigationController?.present(navVC, animated: true)
//                }else {
//                    self.placeOrder()
//                }
                
                
            } else {
                self.ism_showAlert("Error", message: "\(error ?? "")")
            }
        }
    }
    
    func placeOrder() {
//        let cartVC = CartVC.instantiate(storyBoardName: "Cart") as CartVC
//        cartVC.cartType = .checkOut
//        cartVC.isBuyNowFlow = true
//        cartVC.updatedAddress = true
//        cartVC.dismissPreviousController = false
//        cartVC.hidesBottomBarWhenPushed = true
//        
//        let navVC = UINavigationController(rootViewController: cartVC)
//        self.navigationController?.present(navVC, animated: true)
    }
    
    func didMessageTapped(_ index: Int) {
        
    }
    
}
