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
        guard let visibleCell = self.fullyVisibleCells(self.streamCollectionView) else { return }
        visibleCell.streamContainer.videoContainer.videoSessions.first {
            $0.uid == uid
        }?.liveKitVideoView?.track = track
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
        
        let isometrik = viewModel.isometrik
        let streamMembers = viewModel.streamMembers
        
        // update stream members data respective to there video sessions
        streamMembers.forEach {
            
            // for checking whether user is local or remote
            let memberuid = $0.userID?.ism_userIdUInt() ?? 0
            let localUserId = isometrik.getUserSession().getUserId().ism_userIdUInt() ?? 0
            let isLocal = localUserId == memberuid
            
            // check for existing session
            if let sessionIndex = isometrik.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSessions.firstIndex(where: {  $0.uid == memberuid
            }){
                isometrik.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSessions[sessionIndex].userData = $0
            }else{
                // session not exist
                isometrik.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSession(of:memberuid, isLocal ? .local : .remote).userData = $0
            }
            
        }
        updateVideoSessionLayout()
        
    }
    
    public func updateVideoSessionLayout(){
        
        let isometrik = viewModel.isometrik
        let streamsData = viewModel.streamsData
        
        guard let videoContainer = viewModel.videoContainer,
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
        
        // set stream thumbnail image to nil if more than one members or stream is rtmp
        if videoContainer.videoSessions.count > 1 || streamData.rtmpIngest.unwrap {
            visibleCell.streamThumbnailImage.image = UIImage()
        } else {
            if let streamImageUrl = URL(string: streamData.streamImage.unwrap) {
                visibleCell.streamThumbnailImage.kf.setImage(with: streamImageUrl)
            }
        }
        
    }
    
    func joinChannel(streamData: ISMStream?, cell: VerticalStreamCollectionViewCell?){
        
        guard let streamData,
              let cell
        else { return }
        
        let isometrik = viewModel.isometrik
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
        }
        
    }
    
    
}

extension StreamViewController: VideoContainerActionDelegate {
    
    func didMoreOptionTapped(index: Int, videoSession: VideoSession?) {
        
        guard let videoSession else { return }
        
        let isometrik = viewModel.isometrik
        let userData = videoSession.userData
        let userType = isometrik.getUserSession().getUserType()
        
        var settingData: [StreamSettingData] = []
        
        let moreSettingController = MoreSettingViewController(session: videoSession, selectedIndex: index)
        moreSettingController.delegate = self
        
        settingData = [
            StreamSettingData(settingLabel: !videoSession.isAudioMute ? "Mute \"\(userData?.userName ?? "")\" audio" : "Unmute \"\(userData?.userName ?? "")\" audio", settingImage: !videoSession.isAudioMute ? UIImage(systemName: "mic.fill")! : appearance.images.micMuted, streamSettingType: .audio),

            StreamSettingData(settingLabel: !videoSession.isVideoMute ? "Turn off \"\(userData?.userName ?? "")\" video" : "Turn on \"\(userData?.userName ?? "")\" video", settingImage: !videoSession.isVideoMute ? UIImage(systemName: "video.fill")! : appearance.images.videoCameraOff, streamSettingType: .camera)
        ]
        
        if userType == .host {
            let setting = StreamSettingData(settingLabel: "kickout \"\(userData?.userName ?? "")\" from stream", settingImage: appearance.images.removeCircle, labelColor: appearance.colors.appRed, streamSettingType: .kickout)
            settingData.insert(setting, at: 0)
        }
        
        moreSettingController.settingsData = settingData

        if let sheet = moreSettingController.sheetPresentationController {
            
            // Fixed height detent of 200 points
            if #available(iOS 16.0, *) {
                let fixedHeightDetent = UISheetPresentationController.Detent.custom(identifier: .init("fixedHeight")) { _ in
                    return 180 + ism_windowConstant.getBottomPadding
                }
                sheet.detents = [fixedHeightDetent]
            } else {
                // Fallback on earlier versions
                sheet.detents = [.medium()]
            }
            
            
        }
        
        present(moreSettingController, animated: true, completion: nil)
        
    }
    
    func didRTMPMemberViewTapped(index: Int) {
        
        let isometrik = viewModel.isometrik
        let userType = isometrik.getUserSession().getUserType()
        
        switch userType {
        case .viewer:
            sendRequest()
            break
        case .host:
            openGoLiveWith()
            break
        default:
            break
        }
        
    }
    
}
