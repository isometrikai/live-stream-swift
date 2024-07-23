//
//  StreamLiveViewController+Member.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 26/11/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import Foundation
import IsometrikStream

/**
    Extension to manage the `Member` used in the `StreamLiveViewController` class
 */

extension StreamViewController {
    
    /// Join stream as a member.
    /// - Parameters:
    ///   - hostInfo: Host details, Type should be **UserInfo**
    ///   - streamInfo: Stream details, Type should be **StreamInfo**
    func joinStreamAsAMember(user: ISMStreamUser, streamInfo: ISMStream) {
        
        let streamsData = viewModel.streamsData
        let isometrik = viewModel.isometrik
        
        guard let streamData = streamsData[safe: viewModel.selectedStreamIndex.row],
              let streamId = streamData.streamId,
              let memberId = user.userId
        else { return }
        
        /// Start loading.
        isometrik.getIsometrik().addMember(streamId: streamId, memberId: memberId) { (result) in
            
            if let userId = memberId.ism_userIdUInt() {
                self.viewModel.joinChannel(channelName: streamId, userId: userId)
            }
            
        }failure: { error in
            switch error{
            case .noResultsFound(_):
                // handle noresults found here
                break
            case .invalidResponse:
                DispatchQueue.main.async {
                    self.view.showToast( message: "Join Stream Error : Invalid Response")
                }
            case .httpError(let errorCode, let errorMessage):
                DispatchQueue.main.async{
                    self.view.showToast( message: "Join Stream Error : \(errorCode) \(errorMessage?.error ?? "")")
                }
            default :
                break
            }
        }
    }
    
    func sendRequestToAddMember(memberData: ISMViewer) {
        
        let isometrik = viewModel.isometrik
        let streamsData = viewModel.streamsData
        
        guard let streamData = streamsData[safe: viewModel.selectedStreamIndex.row],
              let streamId = streamData.streamId,
              let memberId = memberData.viewerId
        else { return }
        
        isometrik.getIsometrik().addMember(streamId: streamId, memberId: memberId) { (result) in
            print("Add Memebr Request sent successfully")
        }failure: { error in
            switch error{
            case .noResultsFound(_):
                // handle noresults found here
                break
            case .invalidResponse:
                DispatchQueue.main.async {
                    self.view.showToast( message: "Add Memeber Error : Invalid Response")
                }
            case .httpError(let errorCode, let errorMessage):
                DispatchQueue.main.async{
                    self.view.showToast( message: "Add Memeber Error : \(errorCode) \(errorMessage?.error ?? "")")
                }
            default :
                break
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func removeMemberByInitiator(initiatorId: String, streamId: String, memberId: String, session : VideoSession? = nil) {
        
        guard let visibleCell = self.fullyVisibleCells(self.streamCollectionView)
        else { return }
        
        let isometrik = viewModel.isometrik
        
        isometrik.getIsometrik().removeMember(streamId: streamId, memberId: memberId) { result in
            
            DispatchQueue.main.async {
                // remove video session
                
                if let index = visibleCell.streamContainer.videoContainer.videoSessions.firstIndex(where: {  $0.uid == session?.uid
                }){
                    visibleCell.streamContainer.videoContainer.videoSessions.remove(at: index)
                    self.viewModel.isometrik.getIsometrik().setAudioStatusForRemoteSession(uid: session?.uid ?? 0, status: true)
                    self.viewModel.isometrik.getIsometrik().setVideoStatusForRemoteSession(uid: session?.uid ?? 0, status: true)
                }
                
                if let index =  self.viewModel.streamMembers.firstIndex(where: {
                    $0.userID == memberId
                }){
                    self.viewModel.streamMembers.remove(at: index)
                    visibleCell.viewModel = self.viewModel
                }
                
                if let index =      self.viewModel.isometrik.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSessions.firstIndex(where: {  $0.uid == session?.uid
                }){
                    self.viewModel.isometrik.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSessions.remove(at: index)
                }
                
            }
            
        }failure: { error in
            
            switch error{
            case .noResultsFound(_):
                // handle noresults found here
                break
            case .invalidResponse:
                DispatchQueue.main.async {
                    self.view.showToast( message: "Remove Memeber Error : Invalid Response")
                }
            case .httpError(let errorCode, let errorMessage):
                DispatchQueue.main.async{
                    self.view.showToast( message: "Remove Memeber Error : \(errorCode) \(errorMessage?.error ?? "")")
                }
            default :
                break
            }
            
            DispatchQueue.main.async {
                // remove video session
                
                if let index = visibleCell.streamContainer.videoContainer.videoSessions.firstIndex(where: {  $0.uid == session?.uid
                }){
                    visibleCell.streamContainer.videoContainer.videoSessions.remove(at: index)
                
                    self.viewModel.isometrik.getIsometrik().setAudioStatusForRemoteSession(uid: session?.uid ?? 0, status: true)
                    self.viewModel.isometrik.getIsometrik().setVideoStatusForRemoteSession(uid: session?.uid ?? 0, status: true)
                }
                
                if let index =  self.viewModel.streamMembers.firstIndex(where: {
                    $0.userID == memberId
                }){
                    self.viewModel.streamMembers.remove(at: index)
                    visibleCell.viewModel = self.viewModel
                }
                if let index = self.viewModel.isometrik.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSessions.firstIndex(where: {  $0.uid == session?.uid
                }){
                    self.viewModel.isometrik.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSessions.remove(at: index)
                }
            }
        }
        
    }
    
    /// - Parameters:
    ///   - hostInfo: Host details, Type should be **UserInfo**
    ///   - streamInfo: Stream details, Type should be **StreamInfo**
    func leaveStreamByMember() {
        
        let isometrik = viewModel.isometrik
        let streamsData = viewModel.streamsData
        
        guard let streamData = streamsData[safe: viewModel.selectedStreamIndex.row],
              let streamId = streamData.streamId
        else { return }
        
        let memberId = isometrik.getUserSession().getUserId()
 
        isometrik.getIsometrik().leaveMember(streamId: streamId) { (result) in
            
            DispatchQueue.main.async {
                /// leave channel.
                isometrik.getIsometrik().leaveChannel()
                self.viewModel.isometrik.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSessions.removeAll()
                self.dismissViewController()
            }
         
        } failure: { error in
            DispatchQueue.main.async {
                switch error{
                case .noResultsFound(_):
                    // handle noresults found here
                    break
                case .invalidResponse:
                        self.view.showToast( message: "Leave Memeber Error : Invalid Response")
                case .httpError(let errorCode, let errorMessage):
                        self.view.showToast( message: "Leave Memeber Error : \(errorCode) \(errorMessage?.error ?? "")")
                default :
                    break
                }
                isometrik.getIsometrik().leaveChannel()
                self.viewModel.isometrik.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSessions.removeAll()
                self.dismissViewController()
            }
        }
        
    }
    
}
