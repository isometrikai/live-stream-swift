//
//  StreamViewController+StreamPreviewVideo.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 06/02/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit
import AVKit

extension StreamViewController {
    
    func addPlayerObserver(){
        
        guard let player = viewModel.videoPreviewPlayer
        else { return }
        
        /// It plays the video again once it reached its end
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { [weak self] _ in
            player.seek(to: CMTime.zero)
            player.play()
        }
        
    }
    
    func removePlayerObserver(){
        
        guard let player = viewModel.videoPreviewPlayer
        else { return }
        
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
    }
    
    func setupVideoPlayer(){
        
        guard let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row],
              let visibleCell = fullyVisibleCells(streamCollectionView)
        else { return }
    
        let previewPlayerView = visibleCell.previewPlayerView
        
        if !(streamData.isScheduledStream ?? false) {
            return
        }

        if let previewUrl = streamData.streamPreviewUrl, !previewUrl.isEmpty {
            
            previewPlayerView.isHidden = false
            
            guard let videoURL = URL(string: previewUrl) else { return }
            viewModel.videoPreviewPlayer = AVPlayer(url: videoURL)
            let playerLayer = AVPlayerLayer(player: viewModel.videoPreviewPlayer)
            playerLayer.videoGravity = .resizeAspectFill
            
            playerLayer.frame = previewPlayerView.bounds
            previewPlayerView.layer.addSublayer(playerLayer)
            viewModel.videoPreviewPlayer?.isMuted = true
            viewModel.videoPreviewPlayer?.play()
            
        } else {
            previewPlayerView.isHidden = true
        }
        
    }
    
}
