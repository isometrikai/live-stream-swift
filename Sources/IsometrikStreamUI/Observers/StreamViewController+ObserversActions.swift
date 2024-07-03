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
        
        guard let memberData = notification.userInfo?["data"] as? MemberAddEvent,
              let visibleCell = fullyVisibleCells(streamCollectionView),
              let streamsData = viewModel.streamsData,
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
        
        guard let memberData = notification.userInfo?["data"] as? MemberRemoveEvent,
              let isometrik = viewModel.isometrik,
              let visibleCell = fullyVisibleCells(streamCollectionView),
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row],
              streamData.streamId == memberData.streamId
        else { return }
        
        // locally remove session and refresh the sessions
        self.viewModel.isometrik?.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSessions.removeAll { session in
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
            self.viewModel.isometrik?.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSessions.removeAll()
            
            
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
        
        guard let visibleCell = fullyVisibleCells(streamCollectionView),
              let viewerData = notification.userInfo?["data"] as? ViewerJoinEvent,
              let streamsData = viewModel.streamsData,
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
        
        guard let visibleCell = fullyVisibleCells(streamCollectionView),
              let viewerData = notification.userInfo?["data"] as? ViewerRemoveEvent,
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let viewerId = viewerData.viewerId.unwrap
        
        if viewerData.streamId.unwrap != streamData.streamId.unwrap {
            return
        }
        
        viewModel.removeViewer(withId: viewerId)
        
        print("mqttViewerRemoved .... viewer removed with name \(viewerData.viewerName ?? "")")
        
        visibleCell.viewModel = viewModel
        
        let senderName = viewerData.viewerName.unwrap
        let timeStamp = viewerData.timestamp ?? 0
        let message = "\(senderName)" + " " + "left the audience".localized
        
        let messageInfo = ISMComment(messageId: "", messageType: -2, message: message, senderIdentifier: "", senderImage: StreamUserEvents.left.rawValue, senderName: "\(senderName)", senderId: "", sentAt: timeStamp)
        
        addStreamInfoMessage(message: messageInfo)
        
    }
    
    @objc func mqttViewerRemovedByInitiator(notification: NSNotification){
        
        guard let isometrik = viewModel.isometrik,
              let visibleCell = fullyVisibleCells(streamCollectionView),
              let viewerData = notification.userInfo?["data"] as? ViewerRemoveEvent,
              let streamsData = viewModel.streamsData,
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
            visibleCell.streamEndView.streamEndMessageLabel.text = "The host has removed you from the stream, you can watch other live videos".localized + "."
            visibleCell.streamEndView.continueButton.addTarget(self, action: #selector(scrollToNextAvailableStream), for: .touchUpInside)
        }
        
        // otherwise remove the viewer
        viewModel.removeViewer(withId: viewerData.viewerId.unwrap)
        visibleCell.viewModel = viewModel
        
        let senderName = viewerData.viewerName.unwrap
        let removedBy = streamData.userDetails?.userName ?? ""
        let timeStamp = viewerData.timestamp ?? 0
        let message = "\(senderName) " + " " + "has been kicked out of the audience by".localized + " \(removedBy)"
        
        let messageInfo = ISMComment(messageId: "", messageType: -2, message: message, senderIdentifier: "", senderImage: StreamUserEvents.kickout.rawValue, senderName: "\(senderName)", senderId: "", sentAt: timeStamp)
        
        addStreamInfoMessage(message: messageInfo)
        
    }
    
    /**
     MQTT actions for `Message`
     */
    
    @objc func mqttSentMessage(notification: NSNotification){
        
        guard let isometrik = viewModel.isometrik,
              let streamsData = viewModel.streamsData,
              streamsData.count > 0,
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
        }
        
    }
    
    @objc func mqttMessageReply(notification: NSNotification){
        
    }
    
    @objc func mqttRemoveMessage(notification: NSNotification) {
        
        guard let isometrik = viewModel.isometrik,
              let streamsData = viewModel.streamsData,
              streamsData.count > 0,
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
        
        guard let streamsData = viewModel.streamsData,
              let visibleCell = fullyVisibleCells(streamCollectionView),
              let visibleIndex = fullyVisibleIndex(streamCollectionView),
              let _streamData = notification.userInfo?["data"] as? ISMStream,
              let streamData = streamsData[safe: visibleIndex.row]
        else { return }
        
        let streamUserType = viewModel.streamUserType
        
        if streamUserType == .host {
            return
        }
        
        let streamId = streamData.streamId.unwrap
        streamCollectionView.isScrollEnabled = false
        
        // show the popup saying stream off
        if streamId == _streamData.streamId {
            visibleCell.streamEndView.isHidden = false
            visibleCell.streamEndView.streamEndMessageLabel.text = "The host is not online now. You can watch other live videos".localized + "."
            visibleCell.streamEndView.continueButton.addTarget(self, action: #selector(scrollToNextAvailableStream), for: .touchUpInside)
        }
        
    }
    
    /**
     MQTT actions for `Publisher`
     */
    
    @objc func mqttPublisherTimeout(notification: NSNotification){
        
    }
    
    @objc func mqttPublisherStopped(notification: NSNotification){
        
    }
    
    @objc func mqttRequestToBeCoPublisherAdded(notification: NSNotification){
        
    }
    
    @objc func mqttRequestToBeCoPublisherRemoved(notification: NSNotification){
        
    }
    
    @objc func mqttCopublishRequestAccepted(notification: NSNotification){
        
    }
    
    @objc func mqttCopublishRequestDenied(notification: NSNotification){
        
    }
    
    @objc func mqttProfileSwitched(notification: NSNotification){
        
    }
    
    /**
     MQTT actions for `Moderator`
     */
    
    @objc func mqttModeratorAdded(notification: NSNotification){
        
        guard let isometrik = viewModel.isometrik,
              let userData = notification.userInfo?["data"] as? ModeratorEvent,
              let visibleCell = fullyVisibleCells(streamCollectionView),
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        // matching stream id
        if streamData.streamId == userData.streamId {
            let currentUserId = isometrik.getUserSession().getUserId()
            
            if userData.moderatorId == currentUserId {
                
                // Changing the stream user type
                viewModel.streamUserType = .moderator
                viewModel.streamMessageViewModel?.streamUserType = .moderator
                
                let title = "Added to moderator's group of broadcast".localized
                let subtitle = "\(userData.moderatorName ?? "") " + "has been added to the moderator's group of broadcast by".localized  + " \(userData.initiatorName ?? "")" + ".\n" + "Being a moderator one can kick out members and viewers, reply-to and delete messages".localized
                
                self.handleModalActions(title, subtitle)
                
                // updating moderator flag
                viewModel.streamsData?[viewModel.selectedStreamIndex.row].isModerator = true
                
                // updating viewModel after changes
                visibleCell.viewModel = viewModel
                visibleCell.streamContainer.streamMessageView.messageTableView.reloadData()
            }
            
            // update the info message
            
            let senderName = userData.moderatorName ?? ""
            let timeStamp = Int64(userData.timestamp ?? 0)
            let message = "\(senderName) " + "has been added to the moderator's group of broadcast by".localized + " \(userData.initiatorName ?? "")"
            
            let messageInfo = ISMComment(messageId: "", messageType: -2, message: message, senderIdentifier: "", senderImage: StreamUserEvents.addAsModerator.rawValue, senderName: "\(senderName)", senderId: "", sentAt: timeStamp)
            
            addStreamInfoMessage(message: messageInfo)
            
        }
        
    }
    
    @objc func mqttModeratorRemoved(notification: NSNotification){
        
        guard let isometrik = viewModel.isometrik,
              let userData = notification.userInfo?["data"] as? ModeratorEvent,
              let visibleCell = fullyVisibleCells(streamCollectionView),
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        // matching stream id
        if streamData.streamId == userData.streamId {
            let currentUserId = isometrik.getUserSession().getUserId()
            
            if userData.moderatorId == currentUserId {
                
                // Changing the stream user type
                viewModel.streamUserType = .viewer
                viewModel.streamMessageViewModel?.streamUserType = .viewer
                
                let title = "Removed from moderator's group of broadcast".localized
                let subtitle = "\(userData.moderatorName ?? "") " + "has been removed from moderator's group of broadcast by".localized + " \(userData.initiatorName ?? "").\n " + "without being a moderator one can no longer kick out members and viewers, reply-to and delete messages".localized
                
                self.handleModalActions(title, subtitle)
                
                // updating moderator flag
                viewModel.streamsData?[viewModel.selectedStreamIndex.row].isModerator = false
                
                // updating viewModel after changes
                visibleCell.viewModel = viewModel
                visibleCell.streamContainer.streamMessageView.messageTableView.reloadData()
            }
            
            // update the info message
            
            let senderName = userData.moderatorName ?? ""
            let timeStamp = Int64(userData.timestamp ?? 0)
            let message = "\(senderName) " + "has been removed from the moderator's group of broadcast by".localized + "\(userData.initiatorName ?? "")."
            
            let messageInfo = ISMComment(messageId: "", messageType: -2, message: message, senderIdentifier: "", senderImage: StreamUserEvents.removedAsModerator.rawValue, senderName: "\(senderName)", senderId: "", sentAt: timeStamp)
            
            addStreamInfoMessage(message: messageInfo)
            
        }
        
    }
    
    @objc func mqttModeratorLeft(notification: Notification){
        
        guard let isometrik = viewModel.isometrik,
              let userData = notification.userInfo?["data"] as? ModeratorEvent,
              let visibleCell = fullyVisibleCells(streamCollectionView),
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let streamerName = "\(streamData.userDetails?.firstName ?? "") \(streamData.userDetails?.lastName ?? "")"
        
        // matching stream id
        if streamData.streamId == userData.streamId {
            let currentUserId = isometrik.getUserSession().getUserId()
            
            if userData.moderatorId == currentUserId {
                
                // Changing the stream user type
                viewModel.streamUserType = .viewer
                viewModel.streamMessageViewModel?.streamUserType = .viewer
                
                // updating moderator flag
                viewModel.streamsData?[viewModel.selectedStreamIndex.row].isModerator = false
                
                // updating viewModel after changes
                visibleCell.viewModel = viewModel
                visibleCell.streamContainer.streamMessageView.messageTableView.reloadData()
            }
            
            // update the info message
            
            let senderName = userData.moderatorName ?? ""
            let timeStamp = Int64(userData.timestamp ?? 0)
            let message = "\(senderName) " + "left from the moderator's group of broadcast by".localized + " \(streamerName)"
            
            let messageInfo = ISMComment(messageId: "", messageType: -2, message: message, senderIdentifier: "", senderImage: StreamUserEvents.leftAsModerator.rawValue, senderName: "\(senderName)", senderId: "", sentAt: timeStamp)
            
            addStreamInfoMessage(message: messageInfo)
            
        }
        
    }
    
    /**
     MQTT actions for `Pubsub`
     */
    
    @objc func pubsubMessagePublished(notification: NSNotification){
        
        guard let pubsubMessage = notification.userInfo?["data"] as? PubsubEvent,
              let isometrik = viewModel.isometrik,
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
        
        guard let player = viewModel.videoPreviewPlayer else { return }
        player.play()
        
    }
    
}
