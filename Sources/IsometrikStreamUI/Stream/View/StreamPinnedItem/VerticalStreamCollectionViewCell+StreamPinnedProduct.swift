//
//  VerticalStreamCollectionViewCell+StreamPinnedProduct.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 04/10/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

extension VerticalStreamCollectionViewCell {
    
    func setStreamPinnedProduct(){
        
//        guard let viewModel,
//              let streamsData = viewModel.streamsData,
//              streamsData.count > 0
//        else { return }
//        
//        let streamData = streamsData[self.tag],
//        let saleType = streamData.saleType
//
//        let streamSaleType = StreamSaleType(rawValue: saleType)
//        let streamUserType = viewModel.streamUserType
//
//        // setting default UI changes
//        let pinnedItemTimerButton = streamContainer.streamItemPinnedView.timerButton
//        pinnedItemTimerButton.setTitleColor(.white, for: .normal)
//
//        switch streamUserType {
//        case .viewer:
//            let bottomOptionView = streamContainer.streamFooterView.messageSellerView
//            bottomOptionView.streamMessageTextView.isHidden = true
//            switch streamSaleType {
//            case .sell:
//
//                if viewModel.pinnedPoductDetail != nil {
//                    bottomOptionView.alternateActionButton.setTitle("Buy now", for: .normal)
//
//                    bottomOptionView.alternateActionButton.isEnabled = true
//                    bottomOptionView.alternateActionButton.alpha = 1
//
//                    bottomOptionView.chatButton.titleLabel?.font = UIFont(name: Rubik.SemiBold, size: 10)
//                    bottomOptionView.chatButton.setTitle("Chat With Seller!", for: .normal)
//                } else {
//                    bottomOptionView.alternateActionButton.setTitle("Awaiting Next Item", for: .normal)
//
//                    bottomOptionView.alternateActionButton.isEnabled = false
//                    bottomOptionView.alternateActionButton.alpha = 0.5
//
//                    bottomOptionView.chatButton.titleLabel?.font = UIFont(name: Rubik.SemiBold, size: 10)
//                    bottomOptionView.chatButton.setTitle("Chat With Seller!", for: .normal)
//                }
//
//                break
//            case .auction:
//
//                guard let pinnedProductDetails = viewModel.pinnedPoductDetail,
//                      let pinnedProductData = viewModel.pinnedProductData
//                else { return }
//
//                // Actions and other UI Changes
//                let bidPrice = "Starting Bid: \(pinnedProductData.currencySymbol.unwrap)\(pinnedProductDetails.startBidPrice ?? 0)"
//
//                bottomOptionView.animateMessageTextToChatUI()
//                bottomOptionView.alternateActionButton.setTitle(bidPrice, for: .normal)
//
//                bottomOptionView.chatButton.titleLabel?.font = UIFont(name: Rubik.SemiBold, size: 10)
//                bottomOptionView.chatButton.setTitle("Chat With Seller!", for: .normal)
//
//                break
//            case .none:
//                break
//            }
//            break
//        case .member:
//            break
//        case .host:
//
//            switch streamSaleType {
//            case .sell:
//
//                // Enable bottom options after time expires
//                let bottomActionButton = streamContainer.streamFooterView.messageSellerView.alternateActionButton
//                bottomActionButton.setTitle("Change Item", for: .normal)
//
//                break
//            case .auction:
//                let bottomActionButton = streamContainer.streamFooterView.messageSellerView.alternateActionButton
//                bottomActionButton.setTitle("Change Item", for: .normal)
//                break
//            case .none:
//                break
//            }
//
//            break
//        }
        
    }
    
}
