//
//  StreamViewController+StreamSettingsAction.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 09/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

extension StreamViewController: StreamSettingDelegate {
    
    func didTapSettingOptionFor(actionType: StreamSettingType) {
        
        guard let isometrik = viewModel.isometrik,
              let visibleCell = fullyVisibleCells(streamCollectionView),
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let appUserId = streamData.userDetails?.id ?? ""
        let streamInitiatorId = streamData.userDetails?.isomatricChatUserId ?? ""
        let userType = viewModel.streamUserType
        let getIsometrik = isometrik.getIsometrik()
        let userId = isometrik.getUserSession().getUserId()
        let videoContainer = visibleCell.streamContainer.videoContainer
        
        let isScheduledStream = (streamData.status == "SCHEDULED")
        
        switch actionType {
        case .report:
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                // get report reasons
                let controller = StreamReportViewController()
                controller.userViewModel.userId = appUserId
                controller.modalPresentationStyle = .pageSheet
                
                if #available(iOS 15.0, *) {
                    if #available(iOS 16.0, *) {
                        controller.sheetPresentationController?.prefersGrabberVisible = false
                        controller.sheetPresentationController?.detents = [
                            .custom(resolver: { context in
                                return 250 + ism_windowConstant.getBottomPadding
                            })
                        ]
                    }
                }
                
                self.present(controller, animated: true)
            }
            
            break
        case .speaker:
            
            switch userType {
            case .viewer, .moderator:
                
                let uid = isometrik.getUserSession().getUserId().ism_userIdUInt() ?? 0
                self.getVideoSessionAndIndexWithId(uId: uid) { session, index in
                    guard let session else { return }
                    session.isAudioMute = !session.isAudioMute
                    getIsometrik.setAudioStatusForRemoteSession(uid: streamInitiatorId.ism_userIdUInt() ?? UInt(), status: session.isAudioMute)
                    videoContainer.videoContainerCollectionView.reloadData()
                }
                
                break
            case .member:
                break
            case .host:
                break
            }
            
            break
        case .audio:
            
            switch userType {
            case .host, .member:
                
                let uid = isometrik.getUserSession().getUserId().ism_userIdUInt() ?? 0
                self.getVideoSessionAndIndexWithId(uId: uid) { session, index in
                    guard let session else { return }
                    session.isAudioMute = !session.isAudioMute
                    getIsometrik.setMuteStatusForAudio(status: session.isAudioMute)
                    videoContainer.videoContainerCollectionView.reloadData()
                }
                
                break
            default:
                break
            }
            
            break
        case .camera:
            
            switch userType {
            case .host, .member:
                
                let uid = isometrik.getUserSession().getUserId().ism_userIdUInt() ?? 0
                self.getVideoSessionAndIndexWithId(uId: uid) { session, index in
                    guard let session else { return }
                    session.isVideoMute = !session.isVideoMute
                    getIsometrik.setMuteStatusForVideo(status: session.isVideoMute)
                    videoContainer.videoContainerCollectionView.reloadData()
                }
                
                break
            default:
                break
            }
            
            break
        case .delete:
            
            switch userType {
            case .host:
                // delete stream
                let popupController = StreamPopupViewController()
                popupController.titleLabel.text = "Are you sure that you want to delete your live?"
                popupController.modalPresentationStyle = .overCurrentContext
                popupController.modalTransitionStyle = .crossDissolve
                
                popupController.actionCallback = { [weak self] streamAction in
                    switch streamAction {
                    case .ok:
                        isometrik.getIsometrik().deleteStream(streamId: streamData._id ?? "") { result in
                            self?.dismissViewController()
                        } failure: { error in
                            print(error.localizedDescription)
                        }

                        break
                    default:
                        break
                        
                    }
                }
                
                self.dismiss(animated: true) {
                    self.present(popupController, animated: true)
                }
                
                break
            default:
                break
            }
            
            break
        case .edit:
            
            switch userType {
            case .host:
                
                let selectedStreamIndex = viewModel.selectedStreamIndex.row
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in

                    guard let self else { return }
                    
                    let goliveViewModel = GoLiveViewModel(isometrik: isometrik)
                    goliveViewModel.streamData = streamData
                    goliveViewModel.isEditing = true
                    goliveViewModel.update_callback = { [weak self] streamId in
                        guard let self else { return }
                        
                        // get stream data
                        visibleCell.streamLoader.isHidden = false
                        
                        isometrik.getIsometrik().fetchStreams(streamId: streamId) { data in
                            let streams = data.streams
                            if let streams, streams.count > 0, let stream = streams.first {
                                self.viewModel.streamsData?[selectedStreamIndex] = stream
                                self.streamCollectionView.reloadData()
                            }
                        } failure: { error in
                            print(error.localizedDescription)
                        }
                        
                    }
                    
                    let controller = GoLiveViewController(viewModel: goliveViewModel)
                    
                    let navVC = UINavigationController(rootViewController: controller)
                    navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: true)
                    
                }
                
                break
            default:
                break
            }
            
        default:
            break
        }
        
    }
    
    func openStreamSettingController(){
        
        guard let isometrik = viewModel.isometrik,
              let streamsData = viewModel.streamsData, streamsData.count > 0,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let settingController = StreamSettingViewController()
        let streamStatus = LiveStreamStatus(rawValue: streamData.status)
        let userType = viewModel.streamUserType
        
        let reportAction = StreamSettingData(settingLabel: "Report".localized, settingImage: appearance.images.report, streamSettingType: .report)
        
        switch streamStatus {
        case .started:
            
            let uid = isometrik.getUserSession().getUserId().ism_userIdUInt() ?? 0
            self.getVideoSessionAndIndexWithId(uId: uid) { [weak self] session, index in
                guard let currentSession = session, let self else { return }
                
                let audioStatus = !currentSession.isAudioMute
                let videoStatus = !currentSession.isVideoMute
                
                let audioImage = audioStatus ? self.appearance.images.speakerOn : self.appearance.images.speakerOff
                
                let audioLabel = audioStatus ? "Mute Audio".localized : "Unmute Audio".localized
                
                let audioAction = StreamSettingData(settingLabel: audioLabel, settingImage: audioImage, streamSettingType: .audio)
                
                let videoImage = videoStatus ? self.appearance.images.videoCamera : self.appearance.images.videoCameraOff
                
                let videoLabel = videoStatus ? "Disable Camera".localized : "Enable Camera".localized
                
                let cameraAction = StreamSettingData(settingLabel: videoLabel, settingImage: videoImage, streamSettingType: .camera)
                
                let speakerImage = audioStatus ? self.appearance.images.speakerOn : self.appearance.images.speakerOff
                
                let speakerLabel = audioStatus ? "Mute Volume".localized : "Unmute Volume".localized
                
                let speakerAction = StreamSettingData(settingLabel: speakerLabel, settingImage: speakerImage, streamSettingType: .speaker)
                
                switch userType {
                case .viewer:
                    settingController.settingData = [speakerAction, reportAction]
                    break
                case .member:
                    settingController.settingData = [audioAction, cameraAction]
                    break
                case .host:
                    settingController.settingData = [audioAction, cameraAction]
                    break
                case .moderator:
                    settingController.settingData = [speakerAction]
                    break
                }
                
            }
            
            break
        case .scheduled:
            
            let deleteStream = StreamSettingData(settingLabel: "Delete Live", settingImage: UIImage(), streamSettingType: .delete)
            let editStream = StreamSettingData(settingLabel: "Edit Live", settingImage: UIImage(), streamSettingType: .edit)
            
            switch userType {
            case .viewer:
                settingController.settingData = [reportAction]
                break
            case .host:
                settingController.settingData = [editStream, deleteStream]
                break
            default:
                print("")
            }
            
            break
        default:
            print("")
        }
        
        settingController.modalPresentationStyle = .pageSheet
        settingController.streamViewModel = viewModel
        settingController.delegate = self
        
        if let sheet = settingController.sheetPresentationController {
            
            // Fixed height detent of 200 points
            let fixedHeightDetent = UISheetPresentationController.Detent.custom(identifier: .init("fixedHeight")) { _ in
                return 200
            }
            
            sheet.detents = [fixedHeightDetent]
        }
        
        present(settingController, animated: true, completion: nil)
        
    }
    
    func getVideoSessionAndIndexWithId(uId: UInt, completion: @escaping (VideoSession? , Int) -> Void) {
        
        guard let visibleCell = fullyVisibleCells(streamCollectionView) else { return }
        
        let videoSessions = visibleCell.streamContainer.videoContainer.videoSessions
        for i in 0..<videoSessions.count {
            let session = videoSessions[i]
            if session.uid == uId {
                completion(session, i)
                break
            }
            if i == videoSessions.count - 1 {
                completion(nil, 0)
            }
        }
        
    }
    
}
