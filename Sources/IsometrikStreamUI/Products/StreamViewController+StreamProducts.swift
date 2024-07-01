//
//  StreamViewController+StreamProducts.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 22/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

extension StreamViewController {
    
    func openStreamTagProducts(){
        
        guard let isometrik = viewModel.isometrik,
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let streamUserType = viewModel.streamUserType
        let streamStatus = LiveStreamStatus(rawValue: streamData.status ?? "SCHEDULED")
        
        switch streamStatus {
        case .started:
            switch streamUserType {
            case .viewer:
                let controller = StreamTaggedProductList()
                controller.modalPresentationStyle = .pageSheet

                let productViewModel = ProductViewModel(isometrik: isometrik)
                productViewModel.streamInfo = streamData
                controller.productViewModel = productViewModel
                
                let navVC = UINavigationController(rootViewController: controller)
                
                navVC.modalPresentationStyle = .pageSheet
                navVC.modalTransitionStyle = .coverVertical
                
                if #available(iOS 15.0, *) {
                    if #available(iOS 16.0, *) {
                        navVC.sheetPresentationController?.prefersGrabberVisible = false
                        navVC.sheetPresentationController?.detents = [
                            .custom(resolver: { context in
                                return UIScreen.main.bounds.height * 0.7
                            })
                        ]
                    }
                }
                
                self.present(navVC, animated: true)
                break
            case .host:
                
                guard let isometrik = viewModel.isometrik else { return }
                var productViewModel = ProductViewModel(isometrik: isometrik)
                productViewModel.streamInfo = streamData
                productViewModel.pinnedProductData = viewModel.streamProductViewModel?.pinnedProductData
                
                productViewModel.pinnedProduct_Callback = { [weak self] productViewModel in

                    guard let self else { return }
                    viewModel.streamProductViewModel = productViewModel
                    self.setPinnedItemData()
                    
                    
//                    guard let productViewModel = viewModel.streamProductViewModel,
//                          let pinnedProductData = productViewModel.pinnedProductData
//                    else { return }
//
//                    let pinnedProductId = pinnedProductData.childProductID ?? ""
//                    self.fetchPinnedProductDetails(pinnedProductId: pinnedProductId)
//
                }
                
                let controller = StreamTagProductViewController(productViewModel: productViewModel)
                controller.modalPresentationStyle = .pageSheet
                
                let navVC = UINavigationController(rootViewController: controller)
                
                navVC.modalPresentationStyle = .pageSheet
                navVC.modalTransitionStyle = .coverVertical
                navVC.isModalInPresentation = true
                navVC.sheetPresentationController?.prefersGrabberVisible = false
                navVC.sheetPresentationController?.detents = [
                    .custom(resolver: { context in
                        return UIScreen.main.bounds.height * 0.7
                    })
                ]
                self.present(navVC, animated: true)
                
                break
            default:
                print("")
            }
            break
        case .scheduled:
            
            guard let isometrik = viewModel.isometrik else { return }
            let productViewModel = ProductViewModel(isometrik: isometrik)
            productViewModel.streamInfo = streamData
            
            let controller = StreamTaggedProductList()
            controller.modalPresentationStyle = .pageSheet
            controller.productViewModel = productViewModel
            
            controller.productViewModel?.cartUpdates_callback = { [weak self] in
                guard let self else { return }
                self.updateCart()
            }
            
            let navVC = UINavigationController(rootViewController: controller)
            
            navVC.modalPresentationStyle = .pageSheet
            navVC.modalTransitionStyle = .coverVertical
            
            navVC.sheetPresentationController?.prefersGrabberVisible = false
            navVC.sheetPresentationController?.detents = [
                .custom(resolver: { context in
                    return UIScreen.main.bounds.height * 0.7
                })
            ]
            
            self.present(navVC, animated: true)
            break
        default:
            print("")
        }
        
    }
    
    func fetchPinnedProductDetails(pinnedProductId: String){
        
        guard let isometrik = viewModel.isometrik else { return }
        
        if viewModel.streamProductViewModel == nil {
            // assign new object if nil
            let productViewModel = ProductViewModel(isometrik: isometrik)
            viewModel.streamProductViewModel = productViewModel
        }
        
        guard let productViewModel = viewModel.streamProductViewModel else { return }
        
        productViewModel.fetchProductDetails(productId: pinnedProductId) { productData, errorString in
            if productData != nil {
                self.viewModel.streamProductViewModel?.pinnedProductData = productData
                self.setPinnedItemData()
            } else {
                print("LOG:[ProductDetails] - Unable to fetch product details!!")
            }
        }
        
    }
    
    func setPinnedItemData(){
        
        guard let productViewModel = viewModel.streamProductViewModel,
              let visibleCell = fullyVisibleCells(streamCollectionView),
              let pinnedProductData = productViewModel.pinnedProductData
        else { return }
        
        let streamUserType = viewModel.streamUserType
        let streamPinnedItemView = visibleCell.streamContainer.streamItemPinnedView
        
        // unhide the pinned product view
        streamPinnedItemView.isHidden = false
        
        // configure the view
        streamPinnedItemView.configureView(productData: pinnedProductData, userType: streamUserType)
        visibleCell.viewModel = self.viewModel
        
    }
    
    func fetchPinnedProductInStream(){
        
        guard let isometrik = viewModel.isometrik,
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row],
              let visibleCell = fullyVisibleCells(self.streamCollectionView)
        else { return }
        
        var productViewModelRef: ProductViewModel?
        
        if let productViewModel = viewModel.streamProductViewModel {
            productViewModelRef = productViewModel
            productViewModel.streamInfo = streamData
        } else {
            let productViewModel = ProductViewModel(isometrik: isometrik)
            viewModel.streamProductViewModel = productViewModel
            productViewModel.streamInfo = streamData
            productViewModelRef = viewModel.streamProductViewModel
        }
        
        guard let productViewModelRef else { return }
        
        // refresh and reset the pinned item view
        let streamPinnedItemView = visibleCell.streamContainer.streamItemPinnedView
        streamPinnedItemView.isHidden = true
        viewModel.streamProductViewModel?.pinnedProductData = nil
        
        productViewModelRef.fetchPinnedProductInStream { pinnedProductId, errorString in
            if pinnedProductId != nil && pinnedProductId != "000000000000000000000000" {
                let pinnedProductId = pinnedProductId ?? ""
                self.fetchPinnedProductDetails(pinnedProductId: pinnedProductId)
            }
        }
        
    }
    
}

//extension StreamViewController: ResponseDelegate {
//    func responseWithMultiPurpose(response: Response, purpose: String) {
//        guard let visibleCell = fullyVisibleCells(streamCollectionView),
//              let productViewModel = viewModel.streamProductViewModel
//        else { return }
//        
//        
//        switch purpose {
//        case "cart_response":
//            switch response {
//            case .success:
//                visibleCell.setHeaderCartBadgeUpdates()
//                break
//            case .error(let errorCode):
//                print(errorCode)
//                if errorCode == .NotFound{
//                    visibleCell.setHeaderCartBadgeUpdates()
//                    CartVM.cartProducts.removeAll()
//                }
//            case .errorInDataParsing:
//                break
//            }
//            Helper.hideLoader()
//        default:
//            break
//        }
//    }
//}
