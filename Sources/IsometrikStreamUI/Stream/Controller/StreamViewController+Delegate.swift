//
//  StreamViewController+Delegate.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 07/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit
import IsometrikStream

extension StreamViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let streamsData = viewModel.streamsData
        if streamsData.count > 0 {
            return streamsData.count
        } else {
            return 1
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VerticalStreamCollectionViewCell", for: indexPath) as! VerticalStreamCollectionViewCell
        cell.viewModel = viewModel
        cell.delegate = self
        
        self.setStreamData(cell: cell, index: indexPath)
        
        cell.contentView.isUserInteractionEnabled = false
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: streamCollectionView.frame.width, height: streamCollectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        print("~~NEXT INDEX: \(indexPath)")
        
        let isometrik = viewModel.isometrik
        let streamsData = viewModel.streamsData
        
        // for viewers only
        guard viewModel.selectedStreamIndex == indexPath,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let currentStreamId = streamData.streamId.unwrap
        let currentUserId = isometrik.getUserSession().getUserId()
        let streamStatus = LiveStreamStatus(rawValue: streamData.status ?? "SCHEDULED")
        
        
        if streamStatus != .scheduled {
            if viewModel.streamUserType != .viewer { return }
        } else {
            viewModel.streamUserType = .viewer
        }
        
        if streamStatus != .ended {
            // leave a viewer from previous stream
            // reason for setting `exit` false, not exiting the controller
            // cause we are about to join next or previous stream
            leaveStreamByViewer(userId: currentUserId, streamId: currentStreamId, exit: false)
        }
        
        // remove the previous video sessions
        isometrik.getIsometrik().rtcWrapper.videoSessions.removeAll()
        
        // leave the channel from previous stream
        isometrik.getIsometrik().leaveChannel()
        
        // unsubscribing to the stream events
        viewModel.unsubscribeToStreamEvents(streamId: currentStreamId)
        
        // reseting the moderator access
        isometrik.getUserSession().resetValues()
        
        // invalidate all timers
        self.endTimer()
        viewModel.invalidateAllTimers()
        
        // deinit the preiview video player
        if let player = viewModel.videoPreviewPlayer {
            player.pause()
            viewModel.videoPreviewPlayer = nil
            self.removePlayerObserver()
        }
        
        // load next stream data
        if let visibleCell = fullyVisibleCells(streamCollectionView),
           let visibleIndex = fullyVisibleIndex(streamCollectionView),
           viewModel.selectedStreamIndex != visibleIndex {
            viewModel.selectedStreamIndex = visibleIndex
            self.setStreamData(cell: visibleCell, index: visibleIndex)
        }
        
    }
    
}


extension StreamViewController {
    
    func setStreamData(cell: VerticalStreamCollectionViewCell, index: IndexPath){
        
        let isometrik = viewModel.isometrik
        let streamsData = viewModel.streamsData
        
        guard streamsData.count > 0,
              viewModel.selectedStreamIndex == index
        else {
            // reseting thumbnails
            cell.streamThumbnailImage.image = UIImage()
            return
        }
        
        // This is need for gift transfer while in PK stream
        let hostId = isometrik.getHostUserId()
        if hostId == "" {
            if let streamData = streamsData[safe: index.row] {
                isometrik.setHostUserId(userId: streamData.userDetails?.id ?? "")
            }
        }
        
        cell.tag = index.row
        let streamData = streamsData[index.row]
        
        let streamId = streamData.streamId.unwrap
        let streamImage = streamData.streamImage.unwrap
        
        let videoContainer = cell.streamContainer.videoContainer
        videoContainer.delegate = self
        
        let streamLoader = cell.streamLoader
        let scheduleStreamView = cell.scheduleStreamView
        let streamEndView = cell.streamEndView
        let disclaimerView = cell.streamContainer.disclaimerView
        
        // set stream loader data
        
        streamLoader.manageData(streamData: streamData)
        if viewModel.streamUserType == .host {
            streamLoader.isHidden = true
            if streamData.rtmpIngest.unwrap {
                self.openRtmpIngestDetail()
            }
        } else if viewModel.streamUserType == .member {
            streamLoader.isHidden = true
        } else {
            streamLoader.isHidden = false
        }
        
        //:
        
        
        // load the video preview
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            self.setupVideoPlayer()
            self.addPlayerObserver()
        }
        
        //:
        
        // Check whether stream ended or not
        
        if streamData.status == LiveStreamStatus.ended.rawValue {
            streamEndView.isHidden = false
            streamEndView.streamEndMessageLabel.text = "Stream is not live anymore".localized
            streamEndView.continueButton.setTitle("continue", for: .normal)
            streamEndView.continueButton.addTarget(self, action: #selector(scrollToNextAvailableStream), for: .touchUpInside)
            return
        } else {
            streamEndView.isHidden = true
        }
        
        //:
        
        if viewModel.streamMembers.count > 1 {
            cell.streamThumbnailImage.image = UIImage()
        } else {
            if let url = URL(string: streamImage) {
                cell.streamThumbnailImage.kf.setImage(with: url)
            } else {
                cell.streamThumbnailImage.image = UIImage()
            }
        }
        
        
        // Verify scheduled stream scenarios
        
        let isScheduledStream = streamData.isScheduledStream ?? false
        let streamStatus = LiveStreamStatus(rawValue: streamData.status ?? "")
        if isScheduledStream && streamStatus == .scheduled {
            
            streamLoader.isHidden = true
            
            // if schedule stream is of current user changing the viewType to host
            
            let streamUserId = streamData.userDetails?.isomatricChatUserId ?? ""
            let currentUserId = isometrik.getUserSession().getUserId()
            
            if streamUserId == currentUserId {
                viewModel.streamUserType = .host
            } else {
                viewModel.streamUserType = .viewer
            }
            
            // Update cart count
            self.updateCart()
            //
            
//            if let metaData = streamData.metaData, let conversationId = metaData.conversationId {
//                
//                // assign schedule stream message view model
//                viewModel.scheduleStreamMessageViewModel = ScheduleStreamMessageViewModel(conversationId: conversationId, isometrik: viewModel.isometrik!)
//                
//                viewModel.scheduleStreamMessageViewModel?.getMessages({ success in
//                    
//                    let messages = self.viewModel.scheduleStreamMessageViewModel?.streamMessages ?? []
//                    
//                    // creating new instance for stream message model
//                    let messageViewModel = StreamMessageViewModel()
//                    messageViewModel.isometrik = self.viewModel.isometrik
//                    messageViewModel.streamInfo = streamData
//                    messageViewModel.streamUserType = self.viewModel.streamUserType
//                    messageViewModel.resetToDefault()
//                    messageViewModel.messages = messages
//                    self.viewModel.streamMessageViewModel = messageViewModel
//                    
//                    let streamMessageView = cell.streamContainer.streamMessageView
//                    streamMessageView.viewModel = self.viewModel.streamMessageViewModel
//                    streamMessageView.messageTableView.reloadData()
//                    self.setHeightForMessages()
//                    
//                })
//                
//                viewModel.scheduleStreamMessageViewModel?.conversationAction(.join)
//                
//            }
            
            cell.viewModel = viewModel
            disclaimerView.isHidden = true
            
            return
            
        } else {
            scheduleStreamView.isHidden = true
            scheduleStreamView.streamData = nil
        }
        
        //:
        
        //Subscribing to the stream events
        
        viewModel.unsubscribeToStreamEvents(streamId: streamId)
        viewModel.subscribeToStreamEvents(streamId: streamId)
        viewModel.videoContainer = videoContainer
        
        // initiate count down in host
        self.initiateCountDown()
        
        joinChannel(streamData: streamData, cell: cell)
        
        // disclaimer timer
        viewModel.disclaimerTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(hideDisclaimer), userInfo: nil, repeats: true)
        
        // handle for pk scenarios if PK
        
        if streamData.isPkChallenge.unwrap {
            self.handlePKChanges()
        }
        
        
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    @objc func hideDisclaimer(){
        guard let visibleCell = fullyVisibleCells(streamCollectionView)
        else { return }
        
        UIView.animate(withDuration: 0.4, delay: 0) {
            visibleCell.streamContainer.disclaimerView.alpha = 0
        } completion: { finished in
            visibleCell.streamContainer.disclaimerView.isHidden = true
        }
        
        viewModel.disclaimerTimer?.invalidate()
        viewModel.disclaimerTimer = nil
    }
    
}
