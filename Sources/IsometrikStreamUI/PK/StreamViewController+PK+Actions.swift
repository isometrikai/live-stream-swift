//
//  StreamViewController+PK+Actions.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 20/06/24.
//

import Foundation
import UIKit
import IsometrikStream

extension StreamViewController {
    
    func pkInviteTapped(){
        
        guard let isometrik = viewModel.isometrik,
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let viewModel = PKInviteUserViewModel(isometrik: isometrik, streamInfo: streamData)
        
        viewModel.linking_CallBack = { [weak self] streamInfo in
            
            guard let streamInfo, let self else { return }
            
            let viewModel = PKSendInvitationViewModel(streamInfo: streamInfo)
            let controller = PKSendInvitationRequestViewController(viewModel: viewModel)
            
            controller.sheetPresentationController?.prefersGrabberVisible = false
            controller.sheetPresentationController?.preferredCornerRadius = 0
            controller.sheetPresentationController?.detents = [
                .custom(resolver: { context in
                    return 250 + ism_windowConstant.getBottomPadding
                })
            ]
            
            self.present(controller, animated: true)
            
        }
        
        let controller = PKInviteListViewController(viewModel: viewModel)
        controller.modalPresentationStyle = .pageSheet
        
        if let sheet = controller.sheetPresentationController {
            if #available(iOS 16.0, *) {
                // Configure the custom detent
                let customDetent = UISheetPresentationController.Detent.custom { context in
                    return context.maximumDetentValue * 0.6  // 60% of the screen height
                }
                sheet.detents = [customDetent, .medium()]
                sheet.selectedDetentIdentifier = customDetent.identifier
                sheet.preferredCornerRadius = 0
            } else {
                // Fallback on earlier versions
                sheet.preferredCornerRadius = 0
                sheet.detents = [.medium()]
            }
        }
        
        self.present(controller, animated: true)
        
    }
    
    func pkInviteRecieved(data: PubsubEvent?){
        
        guard let pubsubMessage = data,
              let isometrik = viewModel.isometrik
        else { return }
        
        let userData = pubsubMessage.userMetaData
        let userName = userData?.userName.unwrap
        let firstName = userData?.firstName.unwrap
        let lastName = userData?.lastName.unwrap
        let userProfile = userData?.profilePic.unwrap
        let userId = pubsubMessage.userId
        let streamId = pubsubMessage.metaData?.streamId ?? ""
        let inviteId = pubsubMessage.metaData?.inviteId ?? ""
        
        if !viewModel.isPKInvitationActive {
            viewModel.isPKInvitationActive = true
            
            let user = StreamUserDetails(firstName: firstName, isFollow: 0, isStar: false, lastName: lastName, userName: userName, userProfile: userProfile, profilePic: userProfile, isomatricChatUserId: userId, id: userId)
            let streamInfo = ISMStream(streamId: streamId, userDetails: user)
            
            let viewModel = PKRecievedInvitationViewModel(isometrik: isometrik, streamInfo: streamInfo, inviteId: inviteId)
            
            viewModel.response_callBack = { [weak self] (response, streamInfo) in
                guard let self else { return }
                self.viewModel.isPKInvitationActive = false
                
                switch response {
                case .accept:
                    self.pkInviteAccepted(inviteId: inviteId, streamInfo: streamInfo)
                    break
                case .reject:
                    break
                }
            }
            
            let controller = PKRecieveInvitationViewController(viewModel: viewModel)
            
            if let sheet = controller.sheetPresentationController {
                if #available(iOS 16.0, *) {
                    let customDetent = UISheetPresentationController.Detent.custom { context in
                        return context.maximumDetentValue * 0.45
                    }
                    sheet.detents = [customDetent, .medium(), .large()]
                    sheet.selectedDetentIdentifier = customDetent.identifier
                    sheet.preferredCornerRadius = 0
                } else {
                    sheet.detents = [.medium(), .large()]
                }
            }
            
            controller.modalPresentationStyle = .pageSheet
            controller.isModalInPresentation = true
            present(controller, animated: true, completion: nil)
            
        }
        
    }
    
    func pkInviteStatusRecieved(data: PubsubEvent?){
        
        guard let pubsubMessage = data,
              let metaData = pubsubMessage.metaData,
              let streamsData = viewModel.streamsData,
              let _ = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let status = metaData.status.unwrap
        let inviteId = metaData.inviteId.unwrap
        
        if status == "Accepted" {
                        
            viewModel.streamsData?[viewModel.selectedStreamIndex.row].pkInviteId = inviteId
            viewModel.streamsData?[viewModel.selectedStreamIndex.row].isPkChallenge = true
            
            viewModel.fetchStreamMembers { error in
                if error == nil {
                    DispatchQueue.main.async {
                        guard let visibleCell = self.fullyVisibleCells(self.streamCollectionView) else { return }
                        visibleCell.viewModel = self.viewModel
                        self.handleMemberChanges()
                    }
                } else {
                    print(error ?? "")
                }
            }
            
            if var topController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                
                if topController is PKSendInvitationRequestViewController {
                    topController.dismiss(animated: true)
                }
            }
            
        } else {
            // In case of rejection hide the linking popup and present pk list again
        }
        
    }
    
    func pkInviteAccepted(inviteId: String, streamInfo: ISM_PK_Stream?){
        
        guard let streamInfo,
              let isometrik = viewModel.isometrik
        else { return }
        
        let streamId = streamInfo.streamId.unwrap
        let initiatorId = streamInfo.userId.unwrap
        
        // leave previous channel
        isometrik.getIsometrik().leaveChannel()
        
        // Update Publish status
        isometrik.getIsometrik().updatePublishStatus(streamId: streamId, startPublish: true) { [weak self] result in
            
            guard let self,
                  let rtcToken = result.rtcToken
            else { return }
            self.viewModel.streamUserType = .member
            
            isometrik.getUserSession().setUserType(userType: .member)
            isometrik.getUserSession().setMemberForPKStatus(true)
            isometrik.getIsometrik().setUserRoleInStream(.Broadcaster)
            
            viewModel.selectedStreamIndex = IndexPath(row: 0, section: 0)
            viewModel.streamsData?.removeAll()
            
            let stream = ISMStream(streamId: streamId, startTime: Int64(streamInfo.startDateTime.unwrap) ,rtcToken: rtcToken, isPkChallenge: true, pkInviteId: inviteId, isometrikUserID: initiatorId, status: "STARTED")
            
            viewModel.streamsData = [stream]
            
            self.setupDefaults()
            
        } failure: { error in
            switch error{
            case .noResultsFound(_):
                // handle noresults found here
                break
            case .invalidResponse:
                DispatchQueue.main.async {
                    self.view.showISMLiveErrorToast( message: "CoPublish Error : Invalid Response")
                }
            case.networkError(let error):
                self.view.showISMLiveErrorToast( message: "Network Error \(error.localizedDescription)")
              
            case .httpError(let errorCode, let errorMessage):
                DispatchQueue.main.async{
                    self.view.showISMLiveErrorToast( message: "Update Publish:\(errorCode) \(errorMessage?.error ?? "")")
                }
            default :
                break
            }
        }
        
    }
    
    func stopPkViewerEvent(data: PubsubPayloadResponse?){
        
        guard let data,
              let payload = data.payload
        else { return }
        
        let type = payload.type ?? ""
        let message = payload.message ?? ""
        let pkId = payload.pkId ?? ""
        
        print("STOP PK EVENT, VIEWER: \(message)")
        print("STOP PK EVENT ACTION: \(type)")
        
        stopPKBattleForViewer(withPKId: pkId)
        
    }
    
    func stopPKBroadcasterEvent(data: PubsubPayloadResponse?){
        
        guard let data,
              let payload = data.payload
        else { return }
        
        let type = payload.type ?? ""
        let message = payload.message ?? ""
        let pkId = payload.pkId ?? ""
        
        if type == "FORCE_STOP" {
            stopPKBattleForBroadcaster(withPkId: pkId)
        }
        
    }
    
    func startPKBattleForViewer(metaData: MessageMetaDataBody?){
        
        DispatchQueue.main.async { [self] in
            
            guard let metaData,
                  let isometrik = viewModel.isometrik,
                  let visibleCell = fullyVisibleCells(streamCollectionView),
                  let streamsData = viewModel.streamsData,
                  let _ = streamsData[safe: viewModel.selectedStreamIndex.row]
            else { return }
            
            let message = metaData.message.unwrap
            let timeInMin = metaData.timeInMin.unwrap
            let pkId = metaData.pkId.unwrap
            let creationTime = metaData.createdTs ?? 0
            
            // updating first and seconds user details
            let streamInfo = metaData.streamData?.first
            
            self.viewModel.streamsData?[viewModel.selectedStreamIndex.row].firstUserDetails = streamInfo?.firstUserDetails
            self.viewModel.streamsData?[viewModel.selectedStreamIndex.row].secondUserDetails = streamInfo?.secondUserDetails
            self.viewModel.streamsData?[viewModel.selectedStreamIndex.row].pkId = pkId
            
            print("START PK EVENT, VIEWER: \(message)")
            print("CREATION TIME ==>> \(creationTime)")
            
            // calculate secs
            let startTime = Int(creationTime * 1000)
            let currentTime = Int(Date().timeIntervalSince1970 * 1000)
            let timeInMiliSec = (timeInMin * 60 * 1000)
            let remainingSec = Int((timeInMiliSec - (currentTime - startTime)) / 1000)
            
            print("TimeInSecs :: \(timeInMiliSec)")
            
            viewModel.pkBattleTimeInSec = remainingSec
            visibleCell.viewModel = viewModel
            visibleCell.updatePKBattleTimer()
            visibleCell.streamContainer.videoContainer.giftData = nil
            visibleCell.streamContainer.videoContainer.battleOn = true
            
            // update pkId to stream info when PK battle starts
            isometrik.getUserSession().setPKStatus(pkBattleStatus: .on)
            isometrik.getUserSession().setPKBattleId(pkId: pkId)
            
        }
        
    }
    
    func stopPKBattleForBroadcaster(withPkId pkId: String){
        DispatchQueue.main.async {[self] in
            guard let isometrik = viewModel.isometrik,
                  let visibleCell = fullyVisibleCells(streamCollectionView),
                  let streamsData = viewModel.streamsData,
                  let _ = streamsData[safe: viewModel.selectedStreamIndex.row]
            else { return }
            
            visibleCell.viewModel?.pkBattleTimer?.invalidate()
            visibleCell.hidePKTimerView()
            
            // Get winners
            getPKWinnersData(pkId: pkId)
            
            // reset battle progress
            viewModel.pkGiftData = nil
            visibleCell.streamContainer.videoContainer.giftData = nil
            
            // update pkId to stream info when PK battle stops for broadcaster
            self.viewModel.streamsData?[viewModel.selectedStreamIndex.row].pkId = ""
            
            visibleCell.viewModel = viewModel
            
            visibleCell.streamContainer.videoContainer.battleOn = false
            isometrik.getUserSession().setPKStatus(pkBattleStatus: .off)
        }
    }
    
    func stopPKBattleForViewer(withPKId pkId: String){
        DispatchQueue.main.async {[self] in
            
            guard let isometrik = viewModel.isometrik,
                  let visibleCell = fullyVisibleCells(streamCollectionView),
                  let streamsData = viewModel.streamsData,
                  let _ = streamsData[safe: viewModel.selectedStreamIndex.row]
            else { return }
            
            visibleCell.viewModel?.pkBattleTimer?.invalidate()
            visibleCell.hidePKTimerView()
            
            // Get winners
            getPKWinnersData(pkId: pkId)
            
            // update pkId to stream info when PK battle ends
            self.viewModel.streamsData?[viewModel.selectedStreamIndex.row].pkId = ""
            visibleCell.viewModel = viewModel
            
            // reset battle progress bar
            viewModel.pkGiftData = nil
            visibleCell.streamContainer.videoContainer.giftData = nil
            visibleCell.streamContainer.videoContainer.battleOn = false
            
            isometrik.getUserSession().setPKStatus(pkBattleStatus: .off)
            isometrik.getUserSession().setPKBattleId(pkId: "")

            self.checkForCopublisherStatus()
        }
    }
    
    func handlePKChanges(){
        
        guard let isometrik = viewModel.isometrik,
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let streamMembers = viewModel.streamMembers
        
        if streamMembers.count > 1 {
            isometrik.getUserSession().setCurrentStreamData(streamData: streamData)
        } else {
            
            // setting pkId if present
            let pkId = streamData.pkId.unwrap
            isometrik.getUserSession().setPKBattleId(pkId: pkId)
            
            // setting initiator id for host
            for i in 0..<streamMembers.count {
                let member = streamMembers[i]
                if member.isAdmin.unwrap {
                    self.viewModel.streamsData?[viewModel.selectedStreamIndex.row].initiatorId = member.userID
                }
                
                // if viewer is in member list show join now popup
                let currentUserId = isometrik.getUserSession().getUserId()
                if currentUserId == member.userID && viewModel.streamUserType == .viewer {
                    let title = "Join as co-publisher"
                    let subtitle = "Once you join a live broadcast as a co-publisher, anybody can watch it"
                    self.handleModalActions(title, subtitle, joinAsCopublisher: true)
                }
            }
            
        }
        
    }
    
    func endPKInvite(inviteId: String, intentToStop: Bool = false){
        
        guard let isometrik = viewModel.isometrik,
              !inviteId.isEmpty,
              let visibleCell = fullyVisibleCells(streamCollectionView)
        else { return }
        
        let selectedIndexRow = viewModel.selectedStreamIndex.row
        
        isometrik.getIsometrik().endPKLinking(inviteId: inviteId) { result in
            
            let userType = self.viewModel.streamUserType
            
            switch userType {
            case .viewer:
                break
            case .member:
                
                if intentToStop == true {
                    // call leave as a member
                    isometrik.getIsometrik().leaveChannel()
                }
                
                break
            case .host:
                
                self.viewModel.streamsData?[selectedIndexRow].isPkChallenge = false
                if intentToStop == true {
                    isometrik.getIsometrik().leaveChannel()
                }
                
                self.viewModel.fetchStreamMembers() { error in
                    if error == nil {
                        DispatchQueue.main.async {
                            visibleCell.viewModel = self.viewModel
                            self.handleMemberChanges()
                        }
                    } else {
                        print(error ?? "")
                    }
                }
                
                break
            case .moderator:
                break
            }
            
        } failure: { error in
            switch error{
            case .noResultsFound(_):
                // handle noresults found here
                break
            case .invalidResponse:
                DispatchQueue.main.async {
                    self.view.showISMLiveErrorToast( message: "PK Stop Error: Invalid Response")
                }
            case .httpError(let errorCode, let errorMessage):
                DispatchQueue.main.async{
                    self.view.showISMLiveErrorToast( message: "PK Stop Error: \(errorCode) \(errorMessage?.error ?? "")")
                }
            default :
                break
            }
        }

        
    }
    
    func getPKWinnersData(pkId: String){
        
        guard let isometrik = viewModel.isometrik else { return }
    
        isometrik.getIsometrik().getPKBattleWinners(pkId: pkId) { winnerData in
            
            DispatchQueue.main.async {
                
                guard let visibleCell = self.fullyVisibleCells(self.streamCollectionView) else { return }
                
                let videoContainer = visibleCell.streamContainer.videoContainer
                
                // set winner data for winning or loosing
                videoContainer.winnerData = winnerData
                
                // get video session
                var videoSessions = videoContainer.videoSessions
                
                // update winner data to video session and reload
                let group = DispatchGroup()
                group.enter()
                
                for i in 0..<videoSessions.count {
                    videoSessions[i].winnersData = winnerData.data
                    if i == videoSessions.count - 1 {
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    videoContainer.videoContainerCollectionView.reloadData()
                }
            }
                    
        }failure: { error in
            switch error{
            case .noResultsFound(_):
                DispatchQueue.main.async {
                    
                    guard let visibleCell = self.fullyVisibleCells(self.streamCollectionView) else { return }
                    
                    // set winner data for tie
                    visibleCell.streamContainer.videoContainer.winnerData = nil
                }
                
            case .invalidResponse:
                DispatchQueue.main.async {
                    self.view.showISMLiveErrorToast( message: "PK Winners: Invalid Response")
                }
            case .httpError(let errorCode, let errorMessage):
                DispatchQueue.main.async{
                    self.view.showISMLiveErrorToast( message: "PK Winners: \(errorCode) \(errorMessage?.error ?? "")")
                }
            default :
                break
            }
        }
  
    }
    
    func checkForCopublisherStatus(){
        
        let members = viewModel.streamMembers
        for member in members {
            if member.isAdmin ?? false {
                if member.userID == viewModel.ghostStreamUserId {
                    viewModel.copublisherViewer = true
                } else {
                    viewModel.copublisherViewer = false
                }
            }
        }
        
    }
    
    func coPublisherLeft(data: MemberLeaveEvent){
        DispatchQueue.main.async {  [self] in
            
            guard let visibleCell = fullyVisibleCells(streamCollectionView),
                  let isometrik = viewModel.isometrik,
                  let streamsData = viewModel.streamsData,
                  let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
            else { return }
            
            let userType = viewModel.streamUserType
            let isPKChallenge = streamData.isPkChallenge.unwrap
            let streamId = streamData.streamId.unwrap
        
            if let videoSessionIndex = isometrik.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSessions.firstIndex(where: {
                $0.userData?.userID == data.memberId
            }){
                isometrik.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSessions.remove(at:videoSessionIndex )
            }
            
            if let memberIndex = viewModel.streamMembers.firstIndex(where: { $0.userID == data.memberId
            }){
                viewModel.streamMembers.remove(at: memberIndex)
            }
            
            visibleCell.streamContainer.videoContainer.videoSessions =  isometrik.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSessions ?? []
            
            if  isPKChallenge {
                viewModel.streamsData?[viewModel.selectedStreamIndex.row].isPkChallenge = false
                
                switch userType {
                case .member :
                    // Note : change back to ghost(which is basically the member's original stream) stream if you are a member.
                    self.updateBroadCastingStatusAfterPKEnds(intentToStop: false)
                case .host :
                    break
                case .viewer:
                    let ghostStreamData = UserDefaultsProvider.shared.getStreamData()
                    let userInfo = isometrik.getUserSession().getUserModel()
                    
                    // leave previous channel first
                    isometrik.getIsometrik().leaveChannel()
                    
                    viewModel.unsubscribeToMqttEvents()
                    viewModel.unsubscribeToStreamEvents(streamId: streamId)
                    
                    self.leaveStreamByViewer(userId: userInfo.userId ?? "", streamId:streamId)
                    
                    
                    viewModel.streamsData?[viewModel.selectedStreamIndex.row].pkInviteId = ""
                    
                    joinChannel(streamData: viewModel.streamsData?[viewModel.selectedStreamIndex.row], cell: visibleCell)
                    
                    // Notes: only subscribe if the ghost stream was not initiated by host.
                    if  ghostStreamData?.initiatorId != data.memberId{
                        viewModel.subscribeToStreamEvents(streamId: streamId)
                    }
                    
                default :
                    break
                }
            }
            
            visibleCell.streamContainer.videoContainer.refreshPKView()
            
            viewModel.fetchStreamMembers() { error in
                if error == nil {
                    DispatchQueue.main.async {
                        visibleCell.viewModel = viewModel
                        self.handleMemberChanges()
                    }
                } else {
                    visibleCell.viewModel = viewModel
                    print(error ?? "")
                }
            }
            
            // update message data
            let timeStamp = Int64(Date().timeIntervalSince1970)
            let message = "\(data.memberName ?? "") " + " " + "in the audience, is not live anymore".ism_localized
            
            let messageInfo = ISMComment(messageId: "", messageType: -2, message: message, senderIdentifier: "", senderImage: "ism_stream_left", senderName: "\(data.memberName ?? "")", senderId: "", sentAt: timeStamp)
            
            self.handleMessages(message: messageInfo)
            
        }
    }
    
    func updateBroadCastingStatusAfterPKEnds(intentToStop: Bool){
        
        guard let isometrik = viewModel.isometrik,
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        // get previous ghost stream data
        let ghostStreamData = UserDefaultsProvider.shared.getStreamData()
        let streamId = streamData.streamId.unwrap
        
        print("INTENT TO STOP ::: \(intentToStop)")
        
        if intentToStop {
            let currentUserId = isometrik.getUserSession().getUserId()
            stopLiveStream(streamId: ghostStreamData?.streamId ?? "", userId: currentUserId, forceFully: false)
        } else {
            
            // Unsubscribe the Host mqtt events from ended PK.
            viewModel.unsubscribeToStreamEvents(streamId: streamId)
            
            // leave previous channel first
            isometrik.getIsometrik().leaveChannel()
            
            // set user type to host
            isometrik.getUserSession().setUserType(userType: .host)
            
            viewModel.selectedStreamIndex = IndexPath.init(row: 0, section: 0)
            viewModel.streamUserType = .host
            if let ghostStreamData {
                viewModel.streamsData = [ghostStreamData]
            }
            
            self.setupDefaults()
            viewModel.streamsData?[viewModel.selectedStreamIndex.row].pkInviteId = ""
            
            self.streamCollectionView.reloadData()
            
        }
        
    }
    
    func changeStreamForPKStatusRecieved(metaData: MessageMetaDataBody?) {
        
        DispatchQueue.main.async {[self] in
            
            guard let metaData,
                  let isometrik = viewModel.isometrik,
                  let streamsData = viewModel.streamsData,
                  let currentStreamData = streamsData[safe: viewModel.selectedStreamIndex.row]
            else { return }
            
            let currentStreamId = currentStreamData.streamId.unwrap
            let currentStreamUserId = currentStreamData.initiatorId ?? ""
            
            let intentToStop = metaData.intentToStop ?? false
            let action = metaData.action ?? ""
            let streamData = metaData.streamData
            
            if isometrik.getUserSession().getUserType() != .viewer {
                if action == "END_PK" {
                    self.updateBroadCastingStatusAfterPKEnds(intentToStop: intentToStop)
                }
            } else {
                
                let currUserId = isometrik.getUserSession().getUserId()
                let ghostUserId = currentStreamUserId
                
                viewModel.copublisherViewer = true
                viewModel.ghostStreamId = currentStreamId
                viewModel.ghostStreamUserId = currentStreamUserId
                viewModel.ghostUserId = ghostUserId
                
                if intentToStop {
                    
                    viewModel.copublisherViewer = false
                    viewModel.ghostStreamId = ""
                    viewModel.ghostStreamUserId = ""
                    viewModel.ghostUserId = ""
                    
                    isometrik.getIsometrik().leaveViewer(streamId: currentStreamId, viewerId: currUserId) { [self] (result) in
                        self.switchToStream(streamData: streamData?.first)
                    }failure: { error in
                        
                        switch error{
                        case .httpError(let errorCode, let errorMessage):
                            DispatchQueue.main.async{
                                self.view.showISMLiveErrorToast( message: "\(errorCode) \(errorMessage?.error ?? "")")
                            }
                        default :
                            break
                        }
                    }
                    
                } else {
                    self.switchToStream(streamData: streamData?.first)
                }
                
            }
        }
    }
    
    func switchToStream(streamData: ISM_PK_Stream?){
        
        guard let streamData,
              let visibleIndex = fullyVisibleIndex(streamCollectionView),
              let currentStreamsData = viewModel.streamsData,
              let _ = currentStreamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        // reseting session every time stream changes
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewModel.isometrik?.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSessions = []
        }
        
        viewModel.selectedStreamIndex = visibleIndex
        viewModel.streamUserType = .viewer
        
        // remove current stream from array
        if self.viewModel.streamsData?.count ?? 0 >= visibleIndex.row + 1 {
            self.viewModel.streamsData?.remove(at: visibleIndex.row)
        }
        
        // create new one and insert
        
        let firstUserDetail = streamData.firstUserDetails
        let secondUserDetail = streamData.secondUserDetails
        
        print("Switching to stream with id: \(streamData.streamId.unwrap) whose initiator is \(firstUserDetail?.userName ?? "")")
        
        let newStream = ISMStream(streamId: streamData.streamId.unwrap,
                                  startTime: Int64(streamData.startDateTime ?? 0), userDetails: streamData.userDetails, isPkChallenge: true, firstUserDetails: firstUserDetail, secondUserDetails: secondUserDetail)
        
        self.viewModel.streamsData?.insert(newStream, at: visibleIndex.row)
        self.streamCollectionView.reloadData()
    }
    
    func didChangeToPkEvent(){
        guard let streamsData = viewModel.streamsData,
              let _ = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        self.viewModel.streamsData?[viewModel.selectedStreamIndex.row].isPkChallenge = true
    }
    
    func stopPKBattle(pkId: String, action: PKStopAction){
        
        guard let isometrik = viewModel.isometrik else { return }
        
        isometrik.getIsometrik().stopPKChallenge(pkId: pkId, action: action.rawValue) { result in
                print(result)
        }failure:  { error in
            switch error{
            case .noResultsFound(_):
                // handle noresults found here
                break
            case .invalidResponse:
                DispatchQueue.main.async {
                    self.view.showISMLiveErrorToast( message: "PK Stop Battle Error: Invalid Response")
                }
            case .httpError(let errorCode, let errorMessage):
                DispatchQueue.main.async{
                    self.view.showISMLiveErrorToast( message: "PK Stop Battle Error: \(errorCode) \(errorMessage?.error ?? "")")
                }
            default :
                break
            }
        }
        
    }
    
}

/**
    PK overlay actions
 */

extension StreamViewController {
    
    func startPKBattle() {
        
        let challengeViewModel = PkChallengeViewModel()
        
        challengeViewModel.startPK_CallBack = { [weak self] timeInMin in
            
            guard let self,
                  let time = Int(timeInMin ?? "0"),
                  let isometrik = viewModel.isometrik,
                  let streamsData = viewModel.streamsData,
                  let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
            else { return }
            
            let pkInviteId = streamData.pkInviteId.unwrap
            
            isometrik.getIsometrik().startPkChallenge(inviteId: pkInviteId, timeInMin: time) { result in
                print("START PK CHALLENGE RESPONSE : \(result)")
            } failure: { error in
                switch error{
                case .noResultsFound(_):
                    // handle noresults found here
                    break
                case .invalidResponse:
                    DispatchQueue.main.async {
                        self.view.showISMLiveErrorToast( message: "PK Error: Invalid Response")
                    }
                case .httpError(let errorCode, let errorMessage):
                    DispatchQueue.main.async{
                        self.view.showISMLiveErrorToast( message: "PK Error: \(errorCode) \(errorMessage?.error ?? "")")
                    }
                default :
                    break
                }
            }
            
        }
        
        let controller = PKChallengeSettingViewController(viewModel: challengeViewModel)
        
        if let sheet = controller.sheetPresentationController {
            if #available(iOS 16.0, *) {
                
                let customDetent = UISheetPresentationController.Detent.custom { context in
                    return 420 + ism_windowConstant.getBottomPadding
                }
                sheet.detents = [customDetent]
                sheet.selectedDetentIdentifier = customDetent.identifier
                sheet.preferredCornerRadius = 0
                
            } else {
                sheet.detents = [.medium(), .large()]
            }
        }
        
        controller.modalPresentationStyle = .pageSheet
        present(controller, animated: true, completion: nil)
        
    }
    
    func toggleHostInPKBattle() {
        
        guard let visibleCell = fullyVisibleCells(streamCollectionView) else { return }
        
        DispatchQueue.main.async { [self] in
            
            
            let controller = PKHostChangeViewController()
            
            controller.hostChange_Callback = { [weak self] in
                
                guard let self else { return }
                
                let streamMembers = self.viewModel.streamMembers
                
                let group = DispatchGroup()
                group.enter()
                
                var hostData: ISMMember?
                
                // toggle member host tag
                for i in 0..<streamMembers.count {
                    let member = streamMembers[i]
                    if member.isAdmin.unwrap {
                        self.viewModel.streamMembers[i].isAdmin = nil
                    } else {
                        self.viewModel.streamMembers[i].isAdmin = true
                        hostData = member
                    }
                    if i == (streamMembers.count - 1) {
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    
                    // it updates the profile view of host for viewer
                    //visibleCell.updateProfileView(members: self.members)
                    
                    if let hostData = hostData {
                        // change streamInfo initiator info
                        self.viewModel.streamsData?[self.viewModel.selectedStreamIndex.row].initiatorId = hostData.userID
                        
                        // change user Details too
//                        let userDetail = StreamUserDetails(firstName: hostData.name, isFollow: nil, isStar: nil, lastName: hostData.name, userName: hostData.name, userProfile: hostData.imagePath, walletUserId: hostData.memberId)
//                        
//                        self.ongoingStreams[indexPath.row].userDetails = userDetail
                        
                        // toggle the winnerdata if any
                        
                        if self.viewModel.pkGiftData != nil {
                            
                            let streamer1Id = self.viewModel.pkGiftData?.streamer1?.userId ?? ""
                            let streamer1 = self.viewModel.pkGiftData?.streamer1
                            let streamer2 = self.viewModel.pkGiftData?.streamer2
                            if streamer1Id == hostData.userID {
                                self.viewModel.pkGiftData?.streamer1 = streamer1
                                self.viewModel.pkGiftData?.streamer2 = streamer2
                            } else {
                                self.viewModel.pkGiftData?.streamer2 = streamer1
                                self.viewModel.pkGiftData?.streamer1 = streamer2
                            }
                            
                            visibleCell.streamContainer.videoContainer.giftData = self.viewModel.pkGiftData
                        }
                        
                    }
                    
                    // change video session data
                    self.updateVideoSessions()
                    self.checkForCopublisherStatus()
                }
                
            }
            
            if let sheet = controller.sheetPresentationController {
                if #available(iOS 16.0, *) {
                    
                    let customDetent = UISheetPresentationController.Detent.custom { context in
                        return 200 + ism_windowConstant.getBottomPadding
                    }
                    sheet.detents = [customDetent]
                    sheet.selectedDetentIdentifier = customDetent.identifier
                    sheet.preferredCornerRadius = 0
                    
                } else {
                    sheet.detents = [.medium(), .large()]
                }
            }
            
            controller.modalPresentationStyle = .pageSheet
            present(controller, animated: true, completion: nil)
            
        }
    }
    
}


/**
    PK winners data handling funtions
 */

extension StreamViewController {
    
    func setWinnerDefaultData(_ completion: @escaping ()->Void){
    
        DispatchQueue.main.async { [self] in
            
            guard let streamsData = viewModel.streamsData,
                  let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
            else { return }
            
            let pkId = streamData.pkId.unwrap
            
            // if pkId is empty then donot show battle progress bar
            if pkId != "" {
                if viewModel.pkGiftData == nil {
                    /**
                     getting data from member array
                     */
                    
                    if viewModel.streamMembers.count > 1 {
                        
                        var firstMember: ISM_PK_User?
                        var secondMember: ISM_PK_User?
                        
                        for i in 0..<viewModel.streamMembers.count {
                            let member = viewModel.streamMembers[i]
                        
                            let memberId = member.userID.unwrap
                            let userName = member.userName.unwrap
                            let firstName = member.metaData?.firstName.unwrap
                            let lastName = member.metaData?.lastName.unwrap
                            
                            if member.isAdmin != nil && member.isAdmin ?? false {
                                // firstMember
                                firstMember = ISM_PK_User(userId: memberId, userName: userName, firstName: firstName ,lastName: lastName, coins: 0, streamUserId: memberId)
                            } else {
                                // secondMember
                                secondMember = ISM_PK_User(userId: memberId, userName: userName, firstName: firstName ,lastName: lastName, coins: 0, streamUserId: memberId)
                            }
                        }
                        
                        if firstMember != nil && secondMember != nil {
                            let winnerData = ISM_PK_LocalGiftModel(streamer1: firstMember!, streamer2: secondMember!)
                            viewModel.pkGiftData = winnerData
                            completion()
                        } else {
                            viewModel.pkGiftData = nil
                            completion()
                        }
                        
                        
                    }
                    
                    /** getting data from streamInfo
                     
                     self.streamViewModel.winnerData = ISM_PK_LocalWinnerModel(streamer1: streamInfo.firstUserDetails, streamer2: streamInfo.secondUserDetails)
                     
                     */
                }
            } else {
                completion()
                return
            }
        }
    }
    
    func setWinnerBattleProgress(messageInfo: String){
        
        DispatchQueue.main.async { [self] in
            
            guard let visibleCell = fullyVisibleCells(streamCollectionView),
                  let streamsData = viewModel.streamsData,
                  let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
            else { return }
            
            let pkId = streamData.pkId.unwrap
            
            if pkId.isEmpty {
                return
            }
            
            /// Setting winner default data first if `streamViewModel` winnerdata is nil
            self.setWinnerDefaultData {
                /// Appending it based on the `messageInfo`
                let data = messageInfo.data(using: .utf8)!
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String: Any] {
                        
                        let recieverId = (jsonArray["reciverStreamUserId"] as? String).unwrap
                        let coinValue = (jsonArray["coinsValue"] as? Int).unwrap
                        let totalCoinsRecived = (jsonArray["totalCoinsRecived"] as? Int).unwrap
                        
                        // increase the coins here
                        let streamer1Id = self.viewModel.pkGiftData?.streamer1?.userId ?? ""
                        
                        if recieverId == streamer1Id {
                            self.viewModel.pkGiftData?.streamer1?.coins = totalCoinsRecived
                        } else {
                            self.viewModel.pkGiftData?.streamer2?.coins = totalCoinsRecived
                        }
                        
                        let giftData = self.viewModel.pkGiftData
                        visibleCell.streamContainer.videoContainer.giftData = giftData
                        
                    } else {
                        print("bad json")
                    }
                } catch let error as NSError {
                    print(error)
                } //: do catch block end
            }
            
            /// Appending it based on the `messageInfo`
            let data = messageInfo.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String: Any] {
                    
                    let recieverId = (jsonArray["reciverStreamUserId"] as? String).unwrap
                    //let coinValue = (jsonArray["coinsValue"] as? Int).unwrap
                    let totalCoinsRecived = (jsonArray["totalCoinsRecived"] as? Int).unwrap
                    
                    // increase the coins here
                    let streamer1Id = self.viewModel.pkGiftData?.streamer1?.userId ?? ""
                    
                    if recieverId == streamer1Id {
                        self.viewModel.pkGiftData?.streamer1?.coins = totalCoinsRecived
                    } else {
                        self.viewModel.pkGiftData?.streamer2?.coins = totalCoinsRecived
                    }
                    
                    let giftData = self.viewModel.pkGiftData
                    visibleCell.streamContainer.videoContainer.giftData = giftData
                    
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            } //: do catch block end
            
        }
    }
    
    func setWinnerBattleProgress(stats: ISM_PK_StreamStats?){
        DispatchQueue.main.async { [weak self] in
            
            guard let self,
                  let stats,
                  let visibleCell = fullyVisibleCells(streamCollectionView)
            else { return }
            
            self.viewModel.streamsData?[self.viewModel.selectedStreamIndex.row].pkId = stats.pkId.unwrap

            let pkId = stats.pkId.unwrap
            if pkId.isEmpty {
                return
            }
            
            /// Setting winner default data first if `streamViewModel` winnerdata is nil
            self.setWinnerDefaultData() {
                
                /// Appending coins base on the `PKBattle stats`
                
                if !(stats.firstUserCoins == 0) || !(stats.secondUserCoins == 0) {
                    
                    let streamer1Id = self.viewModel.pkGiftData?.streamer1?.userId ?? ""
                    let firstUserId = stats.firstUserDetails?.streamUserId ?? ""
                    
                    if streamer1Id == firstUserId {
                        self.viewModel.pkGiftData?.streamer1?.coins = stats.firstUserCoins
                        self.viewModel.pkGiftData?.streamer2?.coins = stats.secondUserCoins
                    } else {
                        self.viewModel.pkGiftData?.streamer2?.coins = stats.firstUserCoins
                        self.viewModel.pkGiftData?.streamer1?.coins = stats.secondUserCoins
                    }
                    
                    visibleCell.streamContainer.videoContainer.giftData = self.viewModel.pkGiftData
                }
                
            }
            
        }
    }
    
}
