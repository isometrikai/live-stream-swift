//
//  StreamViewController+ObserversActions.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 31/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit
import IsometrikStream

/**
    Extension to manage the `Observer Actions` used in the `StreamLiveViewController` class
 */

extension StreamViewController {
    
    // MARK: - OBSERVER ACTIONS FOR MQTT
    
    /**
     MQTT actions for `Member`
     */
    
    @objc func mqttMemberAdded(notification: NSNotification){
        
        let streamsData = viewModel.streamsData
        
        guard let memberData = notification.userInfo?["data"] as? MemberAddEvent,
              let visibleCell = fullyVisibleCells(streamCollectionView),
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row],
              streamData.streamId == memberData.streamId
        else { return }
        
        // if member in viewer list remove it from viewer list
        self.viewModel.streamViewers.removeAll { viewer in
            return viewer.viewerId == memberData.memberId
        }
        
        viewModel.fetchStreamMembers { error in
            
            if error == nil {
                DispatchQueue.main.async {
                    visibleCell.viewModel = self.viewModel
                    self.handleMemberChanges()
                }
            } else {
                print(error ?? "")
            }
            
        }
        
    }
    
    @objc func mqttMemberRemoved(notification: NSNotification){
        
        let streamsData = viewModel.streamsData
        
        guard let memberData = notification.userInfo?["data"] as? MemberRemoveEvent,
              let visibleCell = fullyVisibleCells(streamCollectionView),
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row],
              streamData.streamId == memberData.streamId
        else { return }
        
        let isometrik = viewModel.isometrik
        
        // locally remove session and refresh the sessions
        self.viewModel.isometrik.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSessions.removeAll { session in
            session.userData?.userID == memberData.memberId
        }

        // Removing video session from copublisher side when getting kickout
        viewModel.fetchStreamMembers { error in
            
            if error == nil {
                DispatchQueue.main.async {
                    visibleCell.viewModel = self.viewModel
                    self.handleMemberChanges()
                }
            } else {
                print(error ?? "")
            }
            
        }
        
        if memberData.memberId == isometrik.getUserSession().getUserId() {
            endTimer()
            isometrik.getIsometrik().leaveChannel()
            self.viewModel.isometrik.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSessions.removeAll()
            
            
            visibleCell.streamEndView.isHidden = false
            visibleCell.streamEndView.streamEndMessageLabel.text = "The host has kickout you from the stream."
            visibleCell.streamEndView.continueButton.addTarget(self, action: #selector(scrollToNextAvailableStream), for: .touchUpInside)
        }
        
    }
    
    @objc func mqttMemberLeft(notification: NSNotification) {
        
        guard let data = notification.userInfo?["data"] as? MemberLeaveEvent else {
            return
        }
        
        coPublisherLeft(data: data)
        
    }
    
    
    /**
     MQTT actions for `Viewer`
     */
    
    @objc func mqttViewerJoined(notification: NSNotification){
        
        let streamsData = viewModel.streamsData
        
        guard let visibleCell = fullyVisibleCells(streamCollectionView),
              let viewerData = notification.userInfo?["data"] as? ViewerJoinEvent,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        if viewerData.streamId.unwrap != streamData.streamId.unwrap {
            return
        }

        viewModel.addViewer(viewerData: viewerData)
        visibleCell.viewModel = viewModel
        
        let senderName = viewerData.viewerName.unwrap
        let timeStamp = viewerData.timestamp ?? 0
        let message = "\(senderName)" + " " + "joined the audience".localized
        
        let messageInfo = ISMComment(messageId: "", messageType: -2, message: message, senderIdentifier: "", senderImage: StreamUserEvents.joined.rawValue, senderName: "\(senderName)", senderId: "", sentAt: timeStamp)
        
        addStreamInfoMessage(message: messageInfo)
        
    }
    
    @objc func mqttViewerRemoved(notification: NSNotification){
        
        let streamsData = viewModel.streamsData
        
        guard let visibleCell = fullyVisibleCells(streamCollectionView),
              let viewerData = notification.userInfo?["data"] as? ViewerRemoveEvent,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let viewerId = viewerData.viewerId.unwrap
        
        if viewerData.streamId.unwrap != streamData.streamId.unwrap {
            return
        }
        
        viewModel.removeViewer(withId: viewerId)
        
        visibleCell.viewModel = viewModel
        
        let senderName = viewerData.viewerName.unwrap
        let timeStamp = viewerData.timestamp ?? 0
        let message = "\(senderName)" + " " + "left the audience".localized
        
        let messageInfo = ISMComment(messageId: "", messageType: -2, message: message, senderIdentifier: "", senderImage: StreamUserEvents.left.rawValue, senderName: "\(senderName)", senderId: "", sentAt: timeStamp)
        
        addStreamInfoMessage(message: messageInfo)
        
    }
    
    @objc func mqttViewerRemovedByInitiator(notification: NSNotification){
        
        let streamsData = viewModel.streamsData
        let isometrik = viewModel.isometrik
        
        guard let visibleCell = fullyVisibleCells(streamCollectionView),
              let viewerData = notification.userInfo?["data"] as? ViewerRemoveEvent,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        if viewerData.streamId.unwrap != streamData.streamId.unwrap {
            return
        }
        
        // if viewer that has been remove from stream is current viewer
        let currentUserId = isometrik.getUserSession().getUserId()
        if viewerData.viewerId.unwrap == currentUserId {
            
            isometrik.getIsometrik().leaveChannel()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                isometrik.getIsometrik().rtcWrapper.videoSessions = []
            }
            
            visibleCell.streamEndView.isHidden = false
            visibleCell.streamEndView.streamEndMessageLabel.text = "The host has removed you from the stream, you can watch other live videos" + "."
            visibleCell.streamEndView.continueButton.addTarget(self, action: #selector(scrollToNextAvailableStream), for: .touchUpInside)
        }
        
        // otherwise remove the viewer
        viewModel.removeViewer(withId: viewerData.viewerId.unwrap)
        visibleCell.viewModel = viewModel
        
        let senderName = viewerData.viewerName.unwrap
        let removedBy = viewerData.initiatorName.unwrap
        let timeStamp = viewerData.timestamp ?? 0
        let message = "\(senderName) " + " " + "has been kicked out of the audience by" + " \(removedBy)"
        
        let messageInfo = ISMComment(messageId: "", messageType: -2, message: message, senderIdentifier: "", senderImage: StreamUserEvents.kickout.rawValue, senderName: "\(senderName)", senderId: "", sentAt: timeStamp)
        
        addStreamInfoMessage(message: messageInfo)
        
    }
    
    /**
     MQTT actions for `Message`
     */
    
    @objc func mqttSentMessage(notification: NSNotification){
        
        let streamsData = viewModel.streamsData
        let isometrik = viewModel.isometrik
        
        guard streamsData.count > 0,
              let streamInfo = streamsData[safe: viewModel.selectedStreamIndex.row],
              let messageData = notification.userInfo?["data"] as? MessageAddEvent
        else { return }
        
        let streamId = messageData.streamId.unwrap
        let currentUserId = isometrik.getUserSession().getUserId()
        let messageOfType  = ISMStreamMessageType(rawValue: messageData.messageType.unwrap)
        
        switch messageOfType {
        case .changeStream:
            self.changeStreamForPKStatusRecieved(metaData: messageData.metaData)
            break
        case .pkStart:
            if isometrik.getUserSession().getUserType() == .viewer {
                startPKBattleForViewer(metaData: messageData.metaData)
            } else {
                startPKBattleForViewer(metaData: messageData.metaData)
            }
            break
        case .changeToPK:
            self.didChangeToPkEvent()
            break
        default:
            /// Convert json into message info data.
            let messageModel = ISMComment(
                messageId: messageData.messageId.unwrap,
                messageType: Int64(messageData.messageType.unwrap),
                message: messageData.body.unwrap,
                senderIdentifier: messageData.senderIdentifier.unwrap,
                senderImage: messageData.senderProfileImageUrl.unwrap,
                senderName: messageData.senderName.unwrap,
                senderId: messageData.senderId.unwrap,
                sentAt: messageData.sentAt.unwrap,
                metaData: messageData.metaData
            )
            
            // Append message only if streamIds matches
            if streamId == streamInfo.streamId.unwrap {
                DispatchQueue.main.async {
                    self.handleMessages(message: messageModel)
                }
            }
            
            print("messageSent event called for messageType \(messageData.messageType.unwrap)")
            
            break
        }
        
    }
    
    @objc func mqttMessageReply(notification: NSNotification){
        
    }
    
    @objc func mqttRemoveMessage(notification: NSNotification) {
        
        let isometrik = viewModel.isometrik
        let streamsData = viewModel.streamsData
        
        guard streamsData.count > 0,
              let messageData = notification.userInfo?["data"] as? ISMComment,
              let streamInfo = streamsData[safe:viewModel.selectedStreamIndex.row]
        else { return }
        
        let streamId = messageData.streamInfo?.streamId.unwrap
        
        if streamId == streamInfo.streamId.unwrap {
            DispatchQueue.main.async {
                self.handleMessages(message: messageData)
            }
        }
        
    }
    
    /**
     MQTT actions for `Stream`
     */
    
    @objc func mqttStreamStopped(notification: NSNotification){
        
        let streamsData = viewModel.streamsData
        let ignoreMqttEventsForStopStream = !(viewModel.ignoreMqttEventForStopStream.unwrap)
        
        guard ignoreMqttEventsForStopStream,
              let visibleIndex = fullyVisibleIndex(streamCollectionView),
              let _streamData = notification.userInfo?["data"] as? ISMStream,
              let streamData = streamsData[safe: visibleIndex.row],
              streamData.streamId.unwrap == _streamData.streamId
        else { return }
        
        let streamUserType = viewModel.streamUserType
        let isometrik = viewModel.isometrik
        let currentUserId = isometrik.getUserSession().getUserId()
        let streamId = streamData.streamId.unwrap
        
        switch streamUserType {
        case .viewer:
            hostNotOnline()
            break
        case .member:
            let wasPKMember = isometrik.getUserSession().getMemberForPKStatus()
            if wasPKMember {
                self.updateBroadCastingStatusAfterPKEnds(intentToStop: false)
            } else {
                hostNotOnline()
            }
            break
        case .host:
            
//            if ignoreMqttEventsForStopStream, currentUserId == _streamData.createdBy {
//                
//                let controller = StreamPopupViewController()
//                controller.titleLabel.text = "It looks like you have an active session on another device. You can't stream to multiple devices simultaneously."
//                controller.cancelButton.isHidden = true
//                controller.actionButton.setTitle("Cancel", for: .normal)
//                
//                controller.actionCallback = {[weak self] _ in
//                    controller.dismiss(animated: true)
//                    self?.stopLiveStream(streamId: streamId, userId: currentUserId)
//                }
//                
//                controller.modalPresentationStyle = .overCurrentContext
//                self.present(controller, animated: true)
//                
//            }
            
            break
        }
        
    }
    
    /**
     MQTT actions for `Publisher`
     */
    
    @objc func mqttPublisherTimeout(notification: NSNotification){
        
    }
    
    @objc func mqttPublisherStopped(notification: NSNotification){
        
        guard let data = notification.userInfo?["data"] as? MemberLeaveEvent else {
            return
        }
        
        let timeStamp = Int64(Date().timeIntervalSince1970)
        let message = "\(data.memberName ?? "") " + " " + "in the publisher group, is not live anymore".ism_localized
        
        let messageInfo = ISMComment(messageId: "", messageType: -2, message: message, senderIdentifier: "", senderImage: StreamUserEvents.left.rawValue, senderName: "\(data.memberName ?? "")", senderId: "", sentAt: timeStamp)
        
        addStreamInfoMessage(message: messageInfo)
        
        viewModel.fetchStreamMembers { error in
            if error == nil {
                self.handleMemberChanges()
            } else {
                print(error ?? "")
            }
        }
        
    }
    
    @objc func mqttRequestToBeCoPublisherAdded(notification: NSNotification){
        
        guard let userRequest = notification.userInfo?["data"] as? ISMRequest else {
            return
        }
        
//        checkUserRequestAlreadyExist(with: userRequest.userId ?? "") { [weak self] isExist in
//            guard let self = self else { return }
//            if !isExist {
//                if self.streamRequests.count == 0 {
//                    self.streamRequests = [userRequest]
//                } else {
//                    self.streamRequests.append(userRequest)
//                }
//            }
//        }
        
        let senderName = userRequest.userName ?? ""
        let timeStamp = Int64(userRequest.requestTime ?? 0)
        let message = "\(senderName) requested to be a copublisher in a stream."
        
        let messageInfo = ISMComment(messageId: "", messageType: -2, message: message, senderIdentifier: "", senderImage: StreamUserEvents.joined.rawValue, senderName: "\(senderName)", senderId: "", sentAt: timeStamp)
        
        addStreamInfoMessage(message: messageInfo)
        
    }
    
    @objc func mqttRequestToBeCoPublisherRemoved(notification: NSNotification){
        
    }
    
    @objc func mqttCopublishRequestAccepted(notification: NSNotification){
        
        guard let visibleCell = fullyVisibleCells(streamCollectionView),
              let userRequest = notification.userInfo?["data"] as? ISMRequest
        else { return }
        
        let isometrik = viewModel.isometrik
        let currentUserId = isometrik.getUserSession().getUserId()
        
        if userRequest.userId == currentUserId, viewModel.streamUserType == .viewer {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                self.viewModel.fetchStreamMembers { error in
                    if error == nil {
                        visibleCell.viewModel = self.viewModel
                        self.fetchStatusOfCoPublishRequest { success in
                            if success {
                                self.sendRequest()
                            }
                        }
                        self.handleMemberChanges()
                    }
                }
            }
        }
        
    }
    
    @objc func mqttCopublishRequestDenied(notification: NSNotification){
        
        guard let visibleCell = fullyVisibleCells(streamCollectionView),
              let userRequest = notification.userInfo?["data"] as? ISMRequest
        else { return }
        
        let isometrik = viewModel.isometrik
        let currentUserId = isometrik.getUserSession().getUserId()
        
        if userRequest.userId == currentUserId, viewModel.streamUserType == .viewer {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                self.viewModel.fetchStreamMembers { error in
                    if error == nil {
                        visibleCell.viewModel = self.viewModel
                        self.fetchStatusOfCoPublishRequest { success in
                            if success {
                                self.sendRequest()
                            }
                        }
                        visibleCell.viewModel = self.viewModel
                        self.handleMemberChanges()
                    }
                }
            }
        }
    }
    
    @objc func mqttProfileSwitched(notification: NSNotification){
        
        guard let visibleCell = fullyVisibleCells(streamCollectionView),
              let profileData = notification.userInfo?["data"] as? ProfileSwitched else {
            return
        }
        
        let userType = viewModel.streamUserType
        
        if userType == .host {
            if let switchedViewerIndex = viewModel.streamViewers.firstIndex(where: {
                $0.viewerId == profileData.userId
            }){
                viewModel.streamViewers.remove(at: switchedViewerIndex)
            }
        }
        
        viewModel.fetchStreamMembers { error in
            if error == nil {
                DispatchQueue.main.async {
                    visibleCell.viewModel = self.viewModel
                    self.handleMemberChanges()
                }
            } else {
                print(error ?? "")
            }
        }
        
        let senderName = profileData.userName ?? ""
        let timeStamp = Int64(profileData.timeStamp ?? "")
        let message = "\(senderName) added as a coPublisher to a stream."
        
        let messageInfo = ISMComment(messageId: "", messageType: -2, message: message, senderIdentifier: "", senderImage: StreamUserEvents.joined.rawValue, senderName: "\(senderName)", senderId: "", sentAt: timeStamp)
        
        addStreamInfoMessage(message: messageInfo)
        
    }
    
    /**
     MQTT actions for `Moderator`
     */
    
    @objc func mqttModeratorAdded(notification: NSNotification){
        
        let streamsData = viewModel.streamsData
        
        guard let userData = notification.userInfo?["data"] as? ModeratorEvent,
              let visibleCell = fullyVisibleCells(streamCollectionView),
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let isometrik = viewModel.isometrik
        
        // matching stream id
        if streamData.streamId == userData.streamId {
            let currentUserId = isometrik.getUserSession().getUserId()
            
            if userData.moderatorId == currentUserId {
                
                // Changing the stream user type
                viewModel.streamUserAccess = .moderator
                viewModel.streamMessageViewModel?.streamUserAccess = .moderator
                isometrik.getUserSession().setUserAccess(userAccess: .moderator)
                
                let title = "Added to moderator's group of broadcast".localized
                let subtitle = "\(userData.moderatorName ?? "") " + "has been added to the moderator's group of broadcast by"  + " \(userData.initiatorName ?? "")" + ".\n" + "Being a moderator one can kick out members and viewers, reply-to and delete messages".localized
                
                self.handleModalActions(title, subtitle)
                
                // updating moderator flag
                viewModel.streamsData[viewModel.selectedStreamIndex.row].isModerator = true
                
                // updating viewModel after changes
                visibleCell.viewModel = viewModel
                visibleCell.streamContainer.streamMessageView.messageTableView.reloadData()
            }
            
            // update the info message
            
            let senderName = userData.moderatorName ?? ""
            let timeStamp = Int64(userData.timestamp ?? 0)
            let message = "\(senderName) " + "has been added to the moderator's group of broadcast by" + " \(userData.initiatorName ?? "")"
            
            let messageInfo = ISMComment(messageId: "", messageType: -2, message: message, senderIdentifier: "", senderImage: StreamUserEvents.addAsModerator.rawValue, senderName: "\(senderName)", senderId: "", sentAt: timeStamp)
            
            addStreamInfoMessage(message: messageInfo)
            
        }
        
    }
    
    @objc func mqttModeratorRemoved(notification: NSNotification){
        
        let streamsData = viewModel.streamsData
        
        guard let userData = notification.userInfo?["data"] as? ModeratorEvent,
              let visibleCell = fullyVisibleCells(streamCollectionView),
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let isometrik = viewModel.isometrik
        
        // matching stream id
        if streamData.streamId == userData.streamId {
            let currentUserId = isometrik.getUserSession().getUserId()
            
            if userData.moderatorId == currentUserId {
                
                // Changing the stream user access
                viewModel.streamUserAccess = .user
                viewModel.streamMessageViewModel?.streamUserAccess = .user
                isometrik.getUserSession().setUserAccess(userAccess: .user)
                
                
                let title = "Removed from moderator's group of broadcast".localized
                let subtitle = "\(userData.moderatorName ?? "") " + "has been removed from moderator's group of broadcast by" + " \(userData.initiatorName ?? "").\n " + "without being a moderator one can no longer kick out members and viewers, reply-to and delete messages"
                
                self.handleModalActions(title, subtitle)
                
                // updating moderator flag
                viewModel.streamsData[viewModel.selectedStreamIndex.row].isModerator = false
                
                // updating viewModel after changes
                visibleCell.viewModel = viewModel
                visibleCell.streamContainer.streamMessageView.messageTableView.reloadData()
            }
            
            // update the info message
            
            let senderName = userData.moderatorName ?? ""
            let timeStamp = Int64(userData.timestamp ?? 0)
            let message = "\(senderName) " + "has been removed from the moderator's group of broadcast by" + " " + "\(userData.initiatorName ?? "")."
            
            let messageInfo = ISMComment(messageId: "", messageType: -2, message: message, senderIdentifier: "", senderImage: StreamUserEvents.removedAsModerator.rawValue, senderName: "\(senderName)", senderId: "", sentAt: timeStamp)
            
            addStreamInfoMessage(message: messageInfo)
            
        }
        
    }
    
    @objc func mqttModeratorLeft(notification: Notification){
        
        let streamsData = viewModel.streamsData
        
        guard let userData = notification.userInfo?["data"] as? ModeratorEvent,
              let visibleCell = fullyVisibleCells(streamCollectionView),
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let isometrik = viewModel.isometrik
        let streamerName = "\(streamData.userDetails?.firstName ?? "") \(streamData.userDetails?.lastName ?? "")"
        
        // matching stream id
        if streamData.streamId == userData.streamId {
            let currentUserId = isometrik.getUserSession().getUserId()
            
            if userData.moderatorId == currentUserId {
                
                // Changing the stream user type

                viewModel.streamUserAccess = .user
                viewModel.streamMessageViewModel?.streamUserAccess = .user
                isometrik.getUserSession().setUserAccess(userAccess: .user)
                
                // updating moderator flag
                viewModel.streamsData[viewModel.selectedStreamIndex.row].isModerator = false
                
                // updating viewModel after changes
                visibleCell.viewModel = viewModel
                visibleCell.streamContainer.streamMessageView.messageTableView.reloadData()
            }
            
            // update the info message
            
            let senderName = userData.moderatorName ?? ""
            let timeStamp = Int64(userData.timestamp ?? 0)
            let message = "\(senderName) " + "left from the moderator's group of broadcast."
            
            let messageInfo = ISMComment(messageId: "", messageType: -2, message: message, senderIdentifier: "", senderImage: StreamUserEvents.leftAsModerator.rawValue, senderName: "\(senderName)", senderId: "", sentAt: timeStamp)
            
            addStreamInfoMessage(message: messageInfo)
            
        }
        
    }
    
    /**
     MQTT actions for `Pubsub`
     */
    
    @objc func pubsubMessagePublished(notification: NSNotification){
        
        let isometrik = viewModel.isometrik
        
        guard let pubsubMessage = notification.userInfo?["data"] as? PubsubEvent,
              isometrik.getUserSession().getUserType() != .viewer
        else { return }
        
        if pubsubMessage.customType == "PkInvite" {
            
            // if invite id matches my id then ignore
            if pubsubMessage.userId != isometrik.getUserSession().getUserId() {
                pkInviteRecieved(data: pubsubMessage)
            }
            
        } else if pubsubMessage.customType == "statusInvite" {
            pkInviteStatusRecieved(data: pubsubMessage)
        }
        
    }
    
    @objc func pubsubMessageOnTopicPublished(notification: NSNotification){
        
        guard let data = notification.userInfo?["data"] as? PubsubPayloadResponse else {
            return
        }
        
        stopPkViewerEvent(data: data)
    }
    
    @objc func pubsubDirectMessagePublished(notification: NSNotification){
        
        guard let data = notification.userInfo?["data"] as? PubsubPayloadResponse else {
            return
        }
        
        stopPKBroadcasterEvent(data: data)
    }
    
    // MARK: - OBSERVER ACTIONS FOR APP LIFE CYCLE
    
    @objc func applicationDidEnterBackground(){
        guard let player = viewModel.videoPreviewPlayer else { return }
        player.pause()
    }
    
    @objc func applicationDidBecomeActive(){
        
    }
    
    @objc func applicationWillResignActive(){
        
    }
    
    @objc func applicationWillEnterForeground(){
        
        let isometrik = viewModel.isometrik
        
        guard let player = viewModel.videoPreviewPlayer else { return }
        player.play()
        
        if let liveKitManager =  isometrik.getIsometrik().rtcWrapper.getLiveKitManager(), !liveKitManager.isCameraMute {
            liveKitManager.updateLiveKitCameraStatus = true
        }
        
    }
    
}
