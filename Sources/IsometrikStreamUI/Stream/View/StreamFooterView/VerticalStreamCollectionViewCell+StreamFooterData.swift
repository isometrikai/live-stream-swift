//
//  VerticalStreamCollectionViewCell+StreamFooterData.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 04/09/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit
import IsometrikStream

extension VerticalStreamCollectionViewCell {
    
    func setStreamFooterView(){
        
        guard let viewModel else { return }
        
        let isometrik = viewModel.isometrik
        let streamsData = viewModel.streamsData
        
        guard let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let isProductEnabled = isometrik.getStreamOptionsConfiguration().isProductInStreamEnabled
        
        let streamUserType = viewModel.streamUserType
        let streamStatus = LiveStreamStatus(rawValue: streamData.status ?? "SCHEDULED")
        
        let scheduleStartTime = streamData.scheduleStartTime ?? 0
        let scheduleDate = Date(timeIntervalSince1970: Double(scheduleStartTime))
        let scheduleDateString = scheduleDate.ism_getCustomMessageTime(dateFormat: "d MMM, hh:mm a").uppercased()
        
        let footerView = streamContainer.streamFooterView
        let footerActionButton = footerView.actionButton

        switch streamUserType {
        case .viewer:
            
            if streamStatus == .scheduled {
                
                self.streamContainer.streamFooterView.toggleBottomActionUI(for: .button)
                footerActionButton.setTitle("RSVP - \(scheduleDateString)".localized, for: .normal)
                footerActionButton.setImage(UIImage(), for: .normal)
                
            } else {
                footerView.toggleBottomActionUI(for: .text, isTextFieldActive: false)
            }
            
            
//            if isProductEnabled {
//                footerView.toggleBottomActionUI(for: .button)
//            } else {
//                footerView.toggleBottomActionUI(for: .text, isTextFieldActive: false)
//            }
            
//            if streamStatus == .scheduled {
//                
//                self.streamContainer.streamFooterView.toggleBottomActionUI(for: .button)
//                dynamicActionButton.setTitle("RSVP - \(scheduleDateString)".localized, for: .normal)
//                dynamicActionButton.setImage(UIImage(), for: .normal)
//                
//            } else {
//                
//                if let productViewModel = viewModel.streamProductViewModel,
//                   let productData = productViewModel.pinnedProductData {
//                    
//                    let isProductOutOfStock = productData.outOfStock ?? false
//                    
//                    // show bottom buttons
//                    self.streamContainer.streamFooterView.toggleBottomActionUI(for: .button)
//                    
//                    if isProductOutOfStock {
//                        dynamicActionButton.setTitle("Out of Stock", for: .normal)
//                        dynamicActionButton.setTitleColor(.red, for: .normal)
//                        dynamicActionButton.isEnabled = false
//                    } else {
//                        dynamicActionButton.setTitle("Buy Now".localized, for: .normal)
//                        dynamicActionButton.setTitleColor(.black, for: .normal)
//                        dynamicActionButton.isEnabled = true
//                    }
//                    
//                    dynamicActionButton.setImage(UIImage(), for: .normal)
//                    
//                } else {
//                    // show message Input view
//                    self.streamContainer.streamFooterView.toggleBottomActionUI(for: .text, isTextFieldActive: false)
//                }
//                
//            }
            
            break
        case .host:
            
            if streamStatus == .scheduled {
                
                self.streamContainer.streamFooterView.toggleBottomActionUI(for: .button)
                
                // Enable the goLive 5 minutes before starting time
                let difference = Date().minuteDifferenceBetween(scheduleDate)
                if difference < 5 {
                    footerActionButton.setTitle("Go Live".localized, for: .normal)
                } else {
                    footerActionButton.setTitle("\(scheduleDateString)".localized, for: .normal)
                }
                footerActionButton.setImage(UIImage(), for: .normal)
                
            } else {
                if isProductEnabled {
                    footerView.toggleBottomActionUI(for: .button)
                    
                    footerActionButton.setTitle("Pin Product", for: .normal)
                    footerActionButton.setImage(UIImage(), for: .normal)
                } else {
                    footerView.toggleBottomActionUI(for: .text, isTextFieldActive: false)
                }
            }
            
//            if streamStatus == .scheduled {
//                
//                self.streamContainer.streamFooterView.toggleBottomActionUI(for: .button)
//                
//                // Enable the goLive 5 minutes before starting time
//                let difference = Date().minuteDifferenceBetween(scheduleDate)
//                if difference < 5 {
//                    dynamicActionButton.setTitle("Go Live".localized, for: .normal)
//                } else {
//                    dynamicActionButton.setTitle("\(scheduleDateString)".localized, for: .normal)
//                }
//                dynamicActionButton.setImage(UIImage(), for: .normal)
//                
//            } else {
//                if let productViewModel = viewModel.streamProductViewModel,
//                   let _ = productViewModel.pinnedProductData {
//                    
//                    // show bottom buttons
//                    self.streamContainer.streamFooterView.toggleBottomActionUI(for: .button)
//                    
//                    dynamicActionButton.setTitle("Next Item".localized + " ", for: .normal)
//                    dynamicActionButton.setImage(UIImage(named: "ic_double_arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
//                    dynamicActionButton.semanticContentAttribute = .forceRightToLeft
//                    
//                } else {
//                    self.streamContainer.streamFooterView.toggleBottomActionUI(for: .button)
//                    dynamicActionButton.setTitle("Pin Product".localized + " ", for: .normal)
//                    dynamicActionButton.setImage(UIImage(), for: .normal)
//                }
//            }

            break
        default:
            print("")
        }

    }
    
}
