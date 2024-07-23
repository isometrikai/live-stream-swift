//
//  VerticalStreamCollectionViewCell+PK.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 24/06/24.
//

import Foundation

extension VerticalStreamCollectionViewCell {
    
    func updatePKBattleTimer(){
        
        guard let viewModel else { return }
        
        DispatchQueue.main.async {
            // unhide the pk timer view
            self.showPKTimerView()
            
            // stop timer for previous PK is any
            viewModel.pkBattleTimer?.invalidate()
            
            viewModel.pkBattleTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.pkBattleTimerAction), userInfo: nil, repeats: true)
            
        }
        
    }
    
    @objc func pkBattleTimerAction(){
        
        guard let viewModel else { return }
        
        let timerLabel = streamContainer.videoContainer.pkOverlayView.battleTimerView.timerLabel
        timerLabel.text = self.pkTimerFormatted(viewModel.pkBattleTimeInSec)
        
        if viewModel.pkBattleTimeInSec != 0 {
            // decrease counter timer
            viewModel.pkBattleTimeInSec -= 1
            // show animation for last 5 sec
            if viewModel.pkBattleTimeInSec == 5 {
                streamContainer.videoContainer.pkOverlayView.countDownView.count = 6
                streamContainer.videoContainer.pkOverlayView.startCountDown()
            }
            
        } else {
            if let pkBattleTimer = viewModel.pkBattleTimer {
                pkBattleTimer.invalidate()
                viewModel.pkBattleTimer = nil
                
                // call to stopPK
                delegate?.StopPKBattleAsTimerFinishes()
            }
        }
        
    }
    
    func pkTimerFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func showPKTimerView(){
        let timerView = streamContainer.videoContainer.pkOverlayView.battleTimerView
        timerView.isHidden = false
        // hide start button
        streamContainer.videoContainer.pkOverlayView.startPKBattleButton.isHidden = true
    }
    
    func hidePKTimerView(){
        
        guard let viewModel else { return }
        
        let isometrik = viewModel.isometrik
        let timerView = streamContainer.videoContainer.pkOverlayView.battleTimerView
        let timerLabel = streamContainer.videoContainer.pkOverlayView.battleTimerView.timerLabel
        timerView.isHidden = true
        timerLabel.text = ""
        
        streamContainer.videoContainer.pkOverlayView.countDownView.timer.invalidate()
        streamContainer.videoContainer.pkOverlayView.countDownView.isHidden = true
        
        // show start button only to host
        if isometrik.getUserSession().getUserType() == .host {
            streamContainer.videoContainer.pkOverlayView.startPKBattleButton.isHidden = false
        }
    }
    
}
