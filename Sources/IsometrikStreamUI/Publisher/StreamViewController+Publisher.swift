//
//  File.swift
//  
//
//  Created by Appscrip 3Embed on 04/07/24.
//

import Foundation
import IsometrikStream
import UIKit

/**
    Extension to manage the `Publisher` used in the `StreamLiveViewController` class
 */

extension StreamViewController {
    
    func sendCopublishRequest(completionHandler: @escaping (ISMPublisher?) -> ()) {
        
        guard let isometrik = viewModel.isometrik,
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let streamId = streamData.streamId.unwrap

        isometrik.getIsometrik().addCopublishRequest(streamId: streamId) { publisher in
                    completionHandler(publisher)
        }failure: { error in
            switch error{
            case .noResultsFound(_):
                // handle noresults found here
                break
            case .invalidResponse:
                DispatchQueue.main.async {
                    self.view.showToast( message: "CoPublish Error : Invalid Response")
                }
            case .httpError(let errorCode, let errorMessage):
                DispatchQueue.main.async{
                    self.view.showToast( message: "\(errorCode) \(errorMessage?.error ?? "")")
                }
            default :
                break
            }
        }
    }
    
    func acceptCoPublishRequest(requestByUserId: String, completionHandler: @escaping (Bool) -> ()) {
        
        guard let isometrik = viewModel.isometrik,
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let streamId = streamData.streamId.unwrap
        
        isometrik.getIsometrik().acceptCopublishRequest(streamId: streamId, requestByUserId: requestByUserId) { (result) in
                completionHandler(true)
        }failure: { error in
            switch error{
            case .noResultsFound(_):
                // handle noresults found here
                break
            case .invalidResponse:
                DispatchQueue.main.async {
                    self.view.showToast( message: "Accept CoPublish Error : Invalid Response")
                }
            case.networkError(let error):
                self.view.showToast( message: "Network Error \(error.localizedDescription)")
              
            case .httpError(let errorCode, let errorMessage):
                DispatchQueue.main.async{
                    self.view.showToast( message: "\(errorCode) \(errorMessage?.error ?? "")")
                }
            default :
                break
            }
            completionHandler(false)
        }
    }
    
    func denyCoPublishRequest(userId: String) {
        
        guard let isometrik = viewModel.isometrik,
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let streamId = streamData.streamId.unwrap
        
        isometrik.getIsometrik().denyCopublishRequest(streamId: streamId, requestByUserId: userId){ (result) in
          print(result)
        }failure: { error in
            switch error{
            case .noResultsFound(_):
                // handle noresults found here
                break
            case .invalidResponse:
                DispatchQueue.main.async {
                    self.view.showToast( message: "Deny CoPublish Error : Invalid Response")
                }
            case.networkError(let error):
                self.view.showToast( message: "Network Error \(error.localizedDescription)")
              
            case .httpError(let errorCode, let errorMessage):
                DispatchQueue.main.async{
                    self.view.showToast( message: "\(errorCode) \(errorMessage?.error ?? "")")
                }
            default :
                break
            }
        }
    }
    
    func fetchStatusOfCoPublishRequest(completion: @escaping(Bool)->Void){
        
        guard let isometrik = viewModel.isometrik,
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let streamId = streamData.streamId.unwrap
        
        isometrik.getIsometrik().fetchCopublishRequestStatus(streamId: streamId) { (result) in
            self.viewModel.publisher = result
            completion(true)
        }failure: { error in
            self.viewModel.publisher = nil
            completion(false)
            switch error{
            case .noResultsFound(_):
                // handle noresults found here
                break
            case .invalidResponse:
                DispatchQueue.main.async {
                    self.view.showToast( message: "Get CoPublish Error : Invalid Response")
                }
            case.networkError(let error):
                DispatchQueue.main.async {
                    self.view.showToast( message: "Network Error \(error.localizedDescription)")
                }
              
            case .httpError(let errorCode, let errorMessage):
                DispatchQueue.main.async{
                    self.view.showToast( message: "CoPublish Error: \(errorCode) \(errorMessage?.error ?? "")")
                }
            default :
                break
            }
        }
    }
    
    func switchProfile() {
        
        guard let isometrik = viewModel.isometrik,
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let streamId = streamData.streamId.unwrap
        let userId = isometrik.getUserSession().getUserId()
        
        isometrik.getIsometrik().switchProfile(streamId: streamId, requestByUserId: userId, isPublic: true) { (result) in
            
            guard let rtcToken = result.rtcToken
            else { return }
                
            self.viewModel.streamUserType = .member
            isometrik.getUserSession().setUserType(userType: .member)
            
            isometrik.getUserSession().setMemberForPKStatus(false)
                
            /// remove from viewer list
            // Pending
            
            /// configure rtc token
            self.viewModel.configureRTCToken(rtcToken: rtcToken)
            self.viewModel.selectedStreamIndex = IndexPath(row: 0, section: 0)
            
            /// empty streams
            self.viewModel.streamsData = [streamData]
            
            self.streamCollectionView.reloadData()
            
        }failure: { error in
            switch error{
            case .httpError(let errorCode, let errorMessage):
                DispatchQueue.main.async{
                    self.view.showToast( message: "\(errorCode) \(errorMessage?.error ?? "")")
                }
            default :
                break
            }
        }
    }
    
    func fetchCopublishRequests(completionHandler: @escaping (ISMPublisher?) -> Void) {
        
        guard let isometrik = viewModel.isometrik,
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let streamId = streamData.streamId.unwrap
        
        isometrik.getIsometrik().fetchCopublishRequests(streamId: streamId) { (result) in
            completionHandler(result)
        }failure: { error in
            switch error{
            case .noResultsFound(_):

                break
            case .invalidResponse:
                DispatchQueue.main.async {
                    self.view.showToast( message: "CoPublish Error : Invalid Response")
                }
            case.networkError(let error):
                self.view.showToast( message: "Network Error \(error.localizedDescription)")
              
            case .httpError(let errorCode, let errorMessage):
                DispatchQueue.main.async{
                    self.view.showToast( message: "CoPublish \(errorCode) \(errorMessage?.error ?? "")")
                }
            default :
                break
            }
            completionHandler(nil)
        }
    }
    
    func deleteCopublishRequest(user: ISMStreamUser, streamInfo: ISMStream, completionHandler: @escaping (ISMPublisher?) -> Void) {
        
        guard let isometrik = viewModel.isometrik,
              let streamId = streamInfo.streamId
        else { return }
        
        isometrik.getIsometrik().deleteCopublishRequest(streamId: streamId) { (result) in
            completionHandler(result)
        } failure: { error in
            switch error{
            case .noResultsFound(_):
                // handle noresults found here
                break
            case .invalidResponse:
                DispatchQueue.main.async {
                    self.view.showToast( message: "CoPublish Error : Invalid Response")
                }
            case.networkError(let error):
                self.view.showToast( message: "Network Error \(error.localizedDescription)")
              
            case .httpError(let errorCode, let errorMessage):
                DispatchQueue.main.async{
                    self.view.showToast( message: "Remove Copublish:\(errorCode) \(errorMessage?.error ?? "")")
                }
            default :
                break
            }
            completionHandler(nil)
        }
    }
    
    func updatePublishStatus(streamInfo: ISMStream, memberId: String, publishStatus: Bool, completionHandler: @escaping(ISMPublisher?) -> ()) {
        
        guard let isometrik = viewModel.isometrik,
              let streamId = streamInfo.streamId
        else { return }
        
        isometrik.getIsometrik().updatePublishStatus(streamId: streamId, memberId: memberId, publishStatus: publishStatus) { (result) in
            completionHandler(result)
        }failure: { error in
            switch error{
            case .noResultsFound(_):
                // handle noresults found here
                break
            case .invalidResponse:
                DispatchQueue.main.async {
                    self.view.showToast( message: "CoPublish Error : Invalid Response")
                }
            case.networkError(let error):
                self.view.showToast( message: "Network Error \(error.localizedDescription)")
              
            case .httpError(let errorCode, let errorMessage):
                DispatchQueue.main.async{
                    self.view.showToast( message: "Update Copublishers: \(errorCode) \(errorMessage?.error ?? "")")
                }
            default :
                break
            }
            completionHandler(nil)
        }
    }
    
}

extension StreamViewController: MoreSettingActionDelegate {
    
    func didOptionTapped(for type: StreamSettingType?, session: VideoSession?, index: Int) {
        
        guard let session,
              let visibleCell = fullyVisibleCells(streamCollectionView),
              let isometrik = viewModel.isometrik,
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let getIsometrik = isometrik.getIsometrik()
        let getUserSession = isometrik.getUserSession()
        let streamId = streamData.streamId.unwrap
        let initiatorId = isometrik.getUserSession().getUserId()
        
        let currentVideoSession = visibleCell.streamContainer.videoContainer.videoSessions[index]
        
        switch type {
        case .audio:
            
            if session.uid == getUserSession.getUserId().ism_userIdUInt() {
                getIsometrik.setMuteStatusForAudio()
                currentVideoSession.isAudioMute = getIsometrik.getMuteStatusForAudio()
            } else {
                currentVideoSession.isAudioMute = !currentVideoSession.isAudioMute
                getIsometrik.setAudioStatusForRemoteSession(uid: session.uid, status: currentVideoSession.isAudioMute)
            }
            
            reloadVideoContainerCellWith(index: index)
            
        case .camera:
            
            if session.uid == getUserSession.getUserId().ism_userIdUInt() {
                getIsometrik.setMuteStatusForVideo()
                currentVideoSession.isVideoMute = getIsometrik.getMuteStatusForVideo()
            } else {
                currentVideoSession.isVideoMute = !currentVideoSession.isVideoMute
                getIsometrik.setVideoStatusForRemoteSession(uid: session.uid, status: currentVideoSession.isVideoMute)
            }
            
            reloadVideoContainerCellWith(index: index)
            
        case .kickout:
            
            guard let userData = session.userData else { return }

            let alertController = UIAlertController(title: "Are you sure?", message: "Are you sure want to kickout \"\(userData.userName ?? "")\" from the stream?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            let kickoutAction = UIAlertAction(title: "Yes, Kickout!", style: .destructive) { action in
                self.removeMemberByInitiator(initiatorId:initiatorId, streamId:streamId , memberId: userData.userID ?? "",session: session)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(kickoutAction)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.present(alertController, animated: true, completion: nil)
            }
            
            break
            
        default:
            break
        }
        
    }
    
    func reloadVideoContainerCellWith(index: Int) {
        guard let visibleCell = fullyVisibleCells(streamCollectionView) else { return }
        let broadCasterView = visibleCell.streamContainer.videoContainer
        broadCasterView.videoContainerCollectionView.reloadData()
    }
    
}


