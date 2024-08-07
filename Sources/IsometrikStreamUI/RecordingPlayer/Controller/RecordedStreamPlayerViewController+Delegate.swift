//
//  RecordedStreamPlayerViewController+Delegate.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 29/12/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import AVFoundation

extension RecordedStreamPlayerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.streamsData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordingPlayerCollectionViewCell", for: indexPath) as! RecordingPlayerCollectionViewCell
        cell.delegate = self
        cell.tag = indexPath.row
        cell.manageData(isometrik: viewModel.isometrik, streamData: viewModel.streamsData[indexPath.row])
        self.setupPlayer(cell: cell, index: indexPath)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: recordingPlayerCollectionView.frame.width, height: recordingPlayerCollectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        viewModel.player?.pause()
        viewModel.player = nil
        self.removePlayerObserver()
        
        guard let selectedIndex = viewModel.selectedIndex, selectedIndex == indexPath , viewModel.streamsData.count > 0 else {
            return
        }
        
        // load next stream data
        if let visibleCell = fullyVisibleCells(recordingPlayerCollectionView),
           let visibleIndex = fullyVisibleIndex(recordingPlayerCollectionView),
           viewModel.selectedIndex != visibleIndex {
            viewModel.selectedIndex = visibleIndex
            self.setupPlayer(cell: visibleCell, index: visibleIndex)
        }
        
    }
    
}

extension RecordedStreamPlayerViewController {
    
    func setupPlayer(cell: RecordingPlayerCollectionViewCell, index: IndexPath){
        
        // removing all previous layers from playerview
        cell.playerView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        cell.thumbnailImageView.image = UIImage()
        
        //cell.productView.productData = []
        //viewModel.productViewModel.taggedProductList = []
        //viewModel.productViewModel.page = 1
        
        
        guard viewModel.streamsData.count > 0, let streamData = viewModel.streamsData[safe: index.row], viewModel.selectedIndex == index
        else {
            return
        }
        
        let recordingUrls = streamData.recordedUrl ?? []
        
        DispatchQueue.main.async{ [weak self] in
            guard let self else { return }
            cell.playButton.isHidden = true
            viewModel.playerState = .play
            self.setUpVideoPlayer(withUrl: recordingUrls.first.unwrap, cell: cell)
            self.addPlayerObserver()
        }
        
        // load the produts tagged during stream
        //viewModel.productViewModel.streamInfo = streamData
        
//        viewModel.productViewModel.fetchTaggedProducts(clearBeforeCall: true) { success, error in
//            if success {
//                let taggedProduct = self.viewModel.productViewModel.taggedProductList
//                cell.productView.productData = taggedProduct
//                cell.streamOptionView.productOptionView.addBadge(withCount: self.viewModel.productViewModel.totalTaggedProductCount)
//            }
//        }
      
        // update slider
        //slider.isContinuous = false
        
        // increment the view count
        let streamId = streamData._id ?? ""
        
//        viewModel.viewedStream(streamId: streamId) { success, errorString in
//            let currentViewCount = streamData.recordViewCount ?? 0
//            if success {
//                self.viewModel.streamsData[index.row].recordViewCount = currentViewCount + 1
//                
//                // update header view
//                cell.streamData = self.viewModel.streamsData[index.row]
//            }
//        }
        
    }
    
    func setUpVideoPlayer(withUrl videoUrl: String, cell: RecordingPlayerCollectionViewCell){
        guard let videoURL = URL(string: videoUrl) else {
            return
        }
        
        viewModel.player = AVPlayer(url: videoURL)
        let playerLayer = AVPlayerLayer(player: viewModel.player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = cell.playerView.bounds
        cell.playerView.layer.addSublayer(playerLayer)
        viewModel.player?.play()
        
        // Adding player observer for changes
        if let duration = viewModel.player?.currentItem?.duration {
            let seconds = CMTimeGetSeconds(duration)

            var secondText = "--"
            var minuteText = "--"
            
            if !seconds.isNaN {
                secondText = String(format: "%02d", Int(seconds) % 60)
                minuteText = String(format: "%02d", Int(seconds) / 60)
            }
            
            cell.sliderView.playerTimerLabel.text = "\(minuteText):\(secondText)"
        }
        
        // Tracking slider base on video progress
        let interval = CMTime(value: 1, timescale: 2)
        viewModel.player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { time in
            let seconds = CMTimeGetSeconds(time)

            let secondString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
            let minuteString = String(format: "%02d", Int(seconds / 60))

            cell.sliderView.playerTimerLabel.text = "\(minuteString):\(secondString)"

            if let duration = self.viewModel.player?.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                cell.sliderView.playerSlider.value = Float(seconds / durationSeconds)
            }
            
        })
    }
    
    func didScrub(_ playbackSlider: UISlider, event: UIEvent) {
        
        guard let duration = viewModel.player?.currentItem?.duration else { return }
        
        let sliderValue = Double(playbackSlider.value)
        var totalSeconds = CMTimeGetSeconds(duration)
        
        if let duration = viewModel.player?.currentItem?.duration, duration.isValid, duration.isIndefinite == false {
            let seconds = CMTimeGetSeconds(duration)
            totalSeconds = seconds
            print("Duration in seconds: \(seconds)")
        } else {
            print("Invalid or indefinite duration")
            return
        }

        let value = Float64(sliderValue * totalSeconds)
        var seekTo = CMTime()
        if value.isFinite{
             seekTo = CMTime(value: Int64(value), timescale: 1)
        }
        
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                // handle drag began
                //Remove observer when dragging is in progress
                viewModel.player?.pause()
                break
            case .moved:
                // handle drag moved
                
                break
            case .ended:
                // handle drag ended
                
                //Add Observer back when seeking got completed
                viewModel.player?.seek(to: seekTo, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] (value) in
                    self?.viewModel.player?.play()
                }
                
                break
            default:
                break
            }
        }
        
    }
    

    
}
