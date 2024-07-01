//
//  StreamViewController+StreamVideoContainer.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 31/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit
import LiveKit
import IsometrikStream

extension StreamViewController: RtcWrapperProtocol {
    
    public func didUserJoinedAsCohost(withId Id: String) {}
    
    public func didUserGoesOffline(user: ISMMember) {}
    
    public func didUpdateVideoTrack(track: VideoTrack?, uid: UInt) {
        
        guard let visibleCell = fullyVisibleCells(streamCollectionView) else { return }
        DispatchQueue.main.async{
            visibleCell.streamContainer.videoContainer.videoSessions.first {
                $0.uid == uid
            }?.liveKitVideoView?.track = track
        }
        
    }
    
    public func videoSessionsDidSet() {
        
//        guard let isometrik = viewModel.isometrik,
//              let videoContainer = viewModel.videoContainer
//        else { return }
//        
//        let videoSession = isometrik.getIsometrik().rtcWrapper.videoSessions
//        videoSession.first?.userData = viewModel.streamMembers.first
//        videoContainer.videoSessions = videoSession
        
    }
    
    public func updateVideoSessions() {
        
        guard let isometrik = viewModel.isometrik
        else { return }
        
        let streamMembers = viewModel.streamMembers
        
        // update stream members data respective to there video sessions
        streamMembers.forEach {
            let memberuid = $0.userID?.ism_userIdUInt() ?? 0
            // check for existing session
            if let sessionIndex = isometrik.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSessions.firstIndex(where: {  $0.uid == memberuid
            }){
                isometrik.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSessions[sessionIndex].userData = $0
            }else{
                // session not exist
                isometrik.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSession(of:memberuid).userData = $0
            }
        }
        updateVideoSessionLayout()
        
    }
    
    public func updateVideoSessionLayout(){
        
        // video views layout
        guard let isometrik = viewModel.isometrik,
              let videoContainer = viewModel.videoContainer,
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
    
        videoContainer.videoSessions = isometrik.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSessions ?? []
        videoContainer.refreshLayout(streamInfo: streamData)
        
        /// refreshing UI elements when videos session updates
        
        guard let visibleCell = self.fullyVisibleCells(self.streamCollectionView) else { return }
        ///refresh PK Views
        visibleCell.streamContainer.videoContainer.streamInfo = streamData
        visibleCell.streamContainer.videoContainer.refreshPKView()
        
        //visibleCell.mainDataContainerView.animatedGiftView.videoDidEnd()
        
    }
    
    func joinChannel(streamData: ISMStream?, cell: VerticalStreamCollectionViewCell?){
        
        guard let isometrik = viewModel.isometrik,
              let streamData,
              let cell
        else { return }
        
        let userId = isometrik.getUserSession().getUserId()
        let streamId = streamData.streamId.unwrap
        
        switch viewModel.streamUserType {
        case .viewer:
            self.startTimer()
            joinStreamAsViewer(streamData: streamData, cell: cell) { (success, errorString) in
                if success != nil {
                    self.fetchStreamData(cell: cell)
                } else {
                    cell.streamEndView.isHidden = false
                    cell.streamEndView.streamEndMessageLabel.text = "The host is not online now. You can watch other live videos".localized + "."
                    cell.streamEndView.continueButton.addTarget(self, action: #selector(self.scrollToNextAvailableStream), for: .touchUpInside)
                }
            }
            break
        case .member:
            DispatchQueue.main.async {
                self.viewModel.joinChannel(channelName: streamId, userId: userId.ism_userIdUInt())
                self.fetchStreamData(cell: cell)
            }
            break
        case .host:
            self.startTimer()
            DispatchQueue.main.async {
                self.viewModel.joinChannel(channelName: streamId, userId: userId.ism_userIdUInt())
                self.fetchStreamData(cell: cell)
            }
            break
        case .moderator:
            break
        }
        
    }
    
    
}
