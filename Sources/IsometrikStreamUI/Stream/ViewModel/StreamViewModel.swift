//
//  StreamViewModel.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 25/10/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import AVKit
import IsometrikStream

public enum StreamUserType {
    case viewer
    case member
    case host
    case moderator
}

enum ScrollStatus {
    case started
    case ended
    case notReachedBottom
    case reachedBottom
}

enum PKStopAction: String {
    case forceStop = "FORCE_STOP"
    case stop = "STOP"
}

enum StreamUserEvents: String {
    case kickout
    case joined
    case left
    case addAsModerator
    case removedAsModerator
    case leftAsModerator
}

typealias streamResponse = ((String?) -> Void)
typealias productResponse = ((Result<Any?, IsometrikError>) -> Void)

final public class StreamViewModel: NSObject {
    
    var hours = 0
    var minutes = 0
    var seconds = 0
    var totalSeconds = 0
    
    var streamStatusTimer: Timer?
    var timerForCounter: Timer?
    var disclaimerTimer: Timer?
    var giftTimer: Timer?
    
    var streamAnimationPopupTimer: Timer?
    
    var pkBattleTimer: Timer?
    var pkBattleTimeInSec: Int = 0
    var isPKInvitationActive: Bool = false
    var copublisherViewer: Bool = false
    var ghostStreamUserId: String = ""
    var ghostStreamId: String = ""
    var ghostUserId: String = ""
    var pkGiftData: ISM_PK_LocalGiftModel?
    
    var counter = 3
    
    public var isometrik: IsometrikSDK?
    public var streamsData: [ISMStream]?
    var streamOptions: [StreamOption] = []
    public var streamUserType: StreamUserType = .viewer
    var streamMessageViewModel: StreamMessageViewModel?
    var streamProductViewModel: ProductViewModel?
//    var profileViewModel = ProfileViewModel()
    var streamMembers: [ISMMember] = []
    var streamViewers: [ISMViewer] = []
    var streamViewerCount: Int = 0
    //var scheduleStreamMessageViewModel: ScheduleStreamMessageViewModel?
    var publisher: ISMPublisher?
    
    var videoPreviewPlayer: AVPlayer?
    
    var youAreLiveCallbackAfterCounter:(() -> Void)?
    public var selectedStreamIndex: IndexPath = IndexPath(row: 0, section: 0)
    var videoContainer: CustomVideoContainer?
    
    
    func setStreaming(){
        
        guard let streamsData, streamsData.count > 0 else { return }
        let rtcToken = streamsData.first?.rtcToken.unwrap
        
        // Configure RTC token
        configureRTCToken(rtcToken: rtcToken)
        
        // Subscribing streaming events
        subscribeToMqttEvents()
        
    }
    
    func configureRTCToken(rtcToken: String?){
        
        guard let isometrik, let rtcToken else { return }
        
        let configuration = isometrik.getIsometrik().configuration
        configuration.rtcToken = rtcToken
        
        print("<>RTC TOKEN ::: \(rtcToken)")
        
        isometrik.getIsometrik().configuration = configuration
        isometrik.getIsometrik().rtcWrapper.configuration = configuration
        
        // hardcoded for now as we only using liveKit
        isometrik.getIsometrik().rtcWrapper.rtcUsing = .livekit
        
    }
    
    func joinChannel(channelName: String, userId: UInt?){
        
        guard let isometrik,
              let userId
        else { return }
        
        switch streamUserType {
        case .viewer:
            isometrik.getIsometrik().setUserRoleInStream(.Audience)
        case .member:
            isometrik.getIsometrik().setUserRoleInStream(.Broadcaster)
        case .host:
            isometrik.getIsometrik().setUserRoleInStream(.Broadcaster)
        case .moderator:
            break
        }
        
        isometrik.getIsometrik().joinChannel(userId: userId)
        
    }
    
    
    
    func fetchStreamMembers(_ completionHandler: @escaping streamResponse){
        
        guard let isometrik,
              let streamsData,
              streamsData.count > 0,
              let streamData = streamsData[safe: selectedStreamIndex.row]
        else { return }
        
        let streamId = streamData.streamId.unwrap
        
        isometrik.getIsometrik().fetchMembers(streamId: streamId) { members in
            self.streamMembers = members
            completionHandler(nil)
        } failure: { error in
            completionHandler(error.localizedDescription)
        }
        
    }
    
    func fetchStreamViewerCount(_ completionHandler: @escaping streamResponse) {
        
        guard let isometrik,
              let streamsData,
              streamsData.count > 0,
              let streamData = streamsData[safe: selectedStreamIndex.row]
        else { return }
        
        let streamId = streamData.streamId.unwrap
        
        isometrik.getIsometrik().fetchViewersCount(streamId: streamId) { viewers in
            
            self.streamViewerCount = viewers.numberOfViewers ?? 0
            completionHandler(nil)
            
        } failure: { error in
            completionHandler(error.localizedDescription)
        }
        
    }
    
    func fetchStreamViewers(_ completionHandler: @escaping streamResponse) {
        
        guard let isometrik,
              let streamsData,
              streamsData.count > 0,
              let streamData = streamsData[safe: selectedStreamIndex.row]
        else { return }
        
        let streamId = streamData.streamId.unwrap
        
        isometrik.getIsometrik().fetchViewers(streamId: streamId){ viewerData in
            
            self.streamViewers = viewerData.viewers ?? []
            completionHandler(nil)
            
        } failure: { error in
            completionHandler(error.localizedDescription)
        }
        
    }
    
    func fetchStreamMessages(_ completionHandler: @escaping streamResponse){
        
        guard let isometrik,
              let streamsData,
              streamsData.count > 0,
              let streamData = streamsData[safe: selectedStreamIndex.row]
        else { return }
        
        // setting stream message view model
        let messageViewModel = StreamMessageViewModel()
        
        messageViewModel.isometrik = isometrik
        messageViewModel.streamInfo = streamData
        messageViewModel.streamUserType = streamUserType
        messageViewModel.resetToDefault()
        
        self.streamMessageViewModel = messageViewModel
        
        guard let streamMessageViewModel else { return }
        
        // fetchMessages
        streamMessageViewModel.fetchMessages { error in
            
            if error == nil {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            } else {
                guard let error else {
                    completionHandler("Unknown error")
                    return
                }
                let errorMessage = "\(error.errorMessage)"
                completionHandler(errorMessage)
            }
        }
        
    }
    
    func deleteStreamMessage(messageInfo: ISMComment?, completionHandler: @escaping streamResponse) {
        
        guard let messageInfo,
              let isometrik,
              let streamsData,
              streamsData.count > 0,
              let streamData = streamsData[safe: self.selectedStreamIndex.row]
        else { return }
        
        let streamId = streamData.streamId ?? ""
        let messageId = messageInfo.messageId ?? ""

        
        isometrik.getIsometrik().removeMessage(streamId: streamId, messageId: messageId) { message in
            completionHandler(nil)
        } failure: { error in
            let errorMessage = "\(error.localizedDescription)"
            completionHandler(errorMessage)
        }
        
        
    }
    
    func invalidateTimers(){
        
        streamStatusTimer?.invalidate()
        streamStatusTimer = nil
        
        timerForCounter?.invalidate()
        timerForCounter = nil
        
        disclaimerTimer?.invalidate()
        disclaimerTimer = nil
        
    }
    
    func isViewerExist(withId viewerId: String) -> Bool {
        
        let isViewerExist = streamViewers.filter { viewer in
            viewer.viewerId == viewerId
        }
        
        return isViewerExist.count > 0
        
    }
    
    func addViewer(viewerData: ViewerJoinEvent) {
        
        let viewerId = viewerData.viewerId.unwrap
        let viewerName = viewerData.viewerName.unwrap
        
        let viewerExist = isViewerExist(withId: viewerId)
        
        if !viewerExist {
            let viewer = ISMViewer(viewerId: viewerId, name: viewerName)
            streamViewers.append(viewer)
        }
        
    }
    
    func removeViewer(withId viewerId: String) {
        
        let viewerExist = isViewerExist(withId: viewerId)
        
        if viewerExist {
            streamViewers.removeAll { viewer in
                viewer.viewerId == viewerId
            }
        }
        
    }
    
    /// `USERS FUNCTIONS`
    
    func followUser(_ completion: @escaping () -> Void){
        
        guard let streamsData,
              let streamData = streamsData[safe: selectedStreamIndex.row],
              let userDetails = streamData.userDetails
        else {
            completion()
            return
        }
        
        let userId = userDetails.id ?? ""
        let privacy = userDetails.privacy ?? 0
        let followStatus = userDetails.followStatus ?? 0
        let isFollow = getIsFollowStatus(followStatus: followStatus)
        
//        profileViewModel.FollowPeopleService(isFollow: !isFollow, peopleId: userId, privicy: privacy)
        
        // updating models after change
        if privacy == 0 {
            if followStatus == 0 {
                self.streamsData?[selectedStreamIndex.row].userDetails?.followStatus = 1
            } else {
                self.streamsData?[selectedStreamIndex.row].userDetails?.followStatus = 0
            }
        } else {
            if followStatus == 0 {
                self.streamsData?[selectedStreamIndex.row].userDetails?.followStatus = 2
            } else {
                self.streamsData?[selectedStreamIndex.row].userDetails?.followStatus = 0
            }
        }
        
        completion()
        
    }
    
    func getIsFollowStatus(followStatus: Int) -> Bool {
//        let followStatusEnum = FollowStatusCode(rawValue: followStatus)
//        
//        switch followStatusEnum {
//        case .follow, .requested:
//            return false
//        case .following:
//            return true
//        case nil:
//            return false
//        }
        return false
    }
    
    
}
