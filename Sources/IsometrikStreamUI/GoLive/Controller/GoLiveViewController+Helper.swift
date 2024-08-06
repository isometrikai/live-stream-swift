//
//  GoLiveViewController+Helper.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 07/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import AVFoundation

extension GoLiveViewController {
    
    func openCoinDialog(){
        
        let premiumButton = contentView.goLiveContentContainerView.premiumButton
        
        let viewController = PaidStreamCardViewController()
        viewController.coinTextField.becomeFirstResponder()
        viewController.selectedCoin = { (coins) in
            if coins != 0 {
                self.viewModel.selectedCoins = coins
                premiumButton.setImage(self.appearance.images.coin, for: .normal)
                premiumButton.setTitle(" \(coins) coins", for: .normal)
            } else {
                if self.viewModel.selectedCoins == 0 {
                    premiumButton.setTitle(" " + "Premium", for: .normal)
                    premiumButton.setImage(self.appearance.images.premiumBadge, for: .normal)
                }
            }
        }

        if let sheet = viewController.sheetPresentationController {
            
            if #available(iOS 16.0, *) {
                let fixedHeightDetent = UISheetPresentationController.Detent.custom(identifier: .init("fixedHeight")) { _ in
                    return 350 + ism_windowConstant.getBottomPadding
                }
                sheet.detents = [fixedHeightDetent]
            } else {
                // Fallback on earlier versions
                sheet.detents = [.medium(), .large()]
            }
            
        }
        
        present(viewController, animated: true, completion: nil)

    }
    
}
