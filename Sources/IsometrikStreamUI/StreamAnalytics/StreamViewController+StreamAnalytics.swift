//
//  StreamViewController+StreamAnalytics.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 04/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import Foundation

extension StreamViewController {
    
    func openStreamAnalytics(inStream: Bool = true, streamId: String){
        
        guard let isometrik = viewModel.isometrik else { return }
        
        let analyticsViewModel = StreamAnalyticViewModel(isometrik: isometrik, streamId: streamId)
        let analyticsController = StreamAnalyticsController(viewModel: analyticsViewModel)
        
        //analyticsController.viewModel = analyticsViewModel
        
        if inStream {
            
            analyticsViewModel.durationValue = Int64(viewModel.totalSeconds) * 1000 // converting to milisecs
            
            analyticsController.actionButton.isHidden = false
            analyticsController.closeButton.isHidden = true
            
            analyticsController.titleLabel.text = "Live Now".localized + "!"
            analyticsController.viewerContainer.isHidden = true
            analyticsController.modalPresentationStyle = .pageSheet
            
            if #available(iOS 15.0, *) {
                if #available(iOS 16.0, *) {
                    analyticsController.sheetPresentationController?.prefersGrabberVisible = false
                    
                    //analyticsController.sheetPresentationController?.detents = [.large(), .medium()]
                    analyticsController.sheetPresentationController?.detents = [
                        .custom(resolver: { context in
                            return 550 + ism_windowConstant.getBottomPadding
                        })
                    ]
                }
            }
            
        } else {
            
            analyticsController.actionButton.isHidden = true
            analyticsController.closeButton.isHidden = false
            
            analyticsController.viewerContainer.isHidden = false
            analyticsController.modalPresentationStyle = .fullScreen
            
            // dismiss completly only if stream ended
            analyticsViewModel.dismissCallBack = {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    self.dismissViewController()
                }
            }
            
            analyticsController.titleLabel.text = "Live Stream Ended".localized + "!"
            analyticsController.isModalInPresentation = true
            analyticsController.viewerContainer.isHidden = false
            
        }
        
        
        
        
        self.present(analyticsController, animated: true)
        
    }
    
}
