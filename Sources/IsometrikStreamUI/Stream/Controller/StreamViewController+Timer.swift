//
//  StreamViewController+Timer.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 03/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import Foundation

/**
    Extension to manage the `Timer` used in the `StreamViewController` class
 */

extension StreamViewController {
   
    // MARK: - COUNTER TIMER
    
    /// Counter time func.
    @objc func counterTime() {
        
        viewModel.counter -= 1
        if viewModel.counter == 1 {
            endCountDownTimer()
            removeCountdownView()
            return
        }
    }
    
    /// Stop timer of count down view.
    private func endCountDownTimer() {
        viewModel.timerForCounter?.invalidate()
        viewModel.timerForCounter = nil
    }
    
    
    /// Remove countdown view.
    private func removeCountdownView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.viewModel.youAreLiveCallbackAfterCounter?()
        })
    }
    
    // MARK: - STREAM TIMER
    
    func startTimer() {
        
        guard let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        viewModel.hours = 0
        viewModel.minutes = 0
        viewModel.seconds = 0
        
        viewModel.streamStatusTimer?.invalidate()
        
        if viewModel.streamUserType != .host {
            guard let startTime = streamData.startTime else {return}
            
            let time = Int(Double(startTime) / 1000)
            let currentTime = Date().timeIntervalSince1970
            let difference = abs(Int(Double(currentTime) - Double(time)))
            self.viewModel.seconds = (difference % 3600) % 60
            self.viewModel.minutes = (difference % 3600) / 60
            self.viewModel.hours = difference / 3600
        }
        
        viewModel.streamStatusTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.showTimer), userInfo: nil, repeats: true)
        
    }
    
    func endTimer() {
        viewModel.streamStatusTimer?.invalidate()
    }
    
    func showJobTimerValues() -> String {
        
        guard let isometrik = viewModel.isometrik
        else { return "" }
        
        var hoursValue          = ""
        var minutesValue        = ""
        var secondsValue        = ""
        
        if viewModel.seconds < 10 {
            secondsValue = "0\(viewModel.seconds)"
        } else {
            secondsValue = "\(viewModel.seconds)"
        }
        
        if viewModel.minutes < 10 {
            minutesValue = "0\(viewModel.minutes)"
        } else {
            minutesValue = "\(viewModel.minutes)"
        }
        
        if viewModel.hours < 10 {
            hoursValue = "0\(viewModel.hours)"
        } else {
            hoursValue = "\(viewModel.hours)"
        }
        
        if let visibleCell = self.fullyVisibleCells(streamCollectionView) {
            
            visibleCell.streamContainer.streamHeaderView.streamStatusView.timeLabel.text = "\(hoursValue):\(minutesValue):\(secondsValue)"
            
            let connectionStatus = isometrik.getMqttSession().isConnected
            visibleCell.updateLiveConnectionStatus(connectionStatus: connectionStatus)
            
        }
        
        return "\(hoursValue):\(minutesValue):\(secondsValue)"
    }
    
    @objc func showTimer() {
        
        guard let isometrik = viewModel.isometrik
        else { return }
        
        viewModel.seconds += 1
        viewModel.totalSeconds += 1
        if viewModel.seconds == 60 {
            viewModel.minutes += 1
            viewModel.seconds = 0
        }
        if viewModel.minutes == 60 {
            viewModel.hours += 1
            viewModel.minutes = 0
        }
        _ = showJobTimerValues()
        
        isometrik.getIsometrik().updateCameraStatus()
        
    }
    
}
