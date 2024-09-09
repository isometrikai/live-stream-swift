//
//  GoLiveViewController+Observers.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 08/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

extension GoLiveViewController {
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func willEnterForeground(){
        guard let captureSession = viewModel.captureSession else { return }
        
        if viewModel.currenStreamType == .guestLive {
            DispatchQueue.global(qos: .userInitiated).async {
                captureSession.startRunning()
            }
        }
    }
    
}
