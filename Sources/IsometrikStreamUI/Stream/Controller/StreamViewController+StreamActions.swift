//
//  StreamViewController+StreamActions.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 31/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit


extension StreamViewController {
    
    func didTapOnClosingAction(withOption option: StreamPopupAction, index: Int) {
        
        let isometrik = viewModel.isometrik
        let streamsData = viewModel.streamsData
        
        guard streamsData.count > 0,
              let streamData = streamsData[safe: index]
        else { return }
        
        let userType = viewModel.streamUserType
        let streamId = streamData.streamId.unwrap
        let userId = isometrik.getUserSession().getUserId()
        
        switch option {
        case .cancel:
            
            switch userType {
            case .member:
                
                if !(streamData.isPkChallenge.unwrap) {
                    updatePublishStatus(streamInfo: streamData, memberId: userId, publishStatus: false) { result in
                        /// leave channel.
                        isometrik.getIsometrik().leaveChannel()
                        
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            isometrik.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSessions = []
                            self.dismissViewController()
                        }
                    }
                }
                
                break
            default: break
            }
            
            break
        case .ok:
            
            switch userType {
            case .member:
                if streamData.isPkChallenge.unwrap {
                    endPKInvite(inviteId: streamData.pkInviteId.unwrap)
                } else {
                    leaveStreamByMember()
                }
                break
            case .host:
                stopLiveStream(streamId: streamId, userId: userId)
                self.endTimer()
                break
            default: break
            }
            
            break
        }
        
    }
    
    func stopLiveStream(streamId: String, userId: String, forceFully: Bool = false) {
        
        let isometrik = viewModel.isometrik
        
        guard let visibleCell = fullyVisibleCells(streamCollectionView)
        else { return }
        
        /// Start loading.
        visibleCell.streamLoader.isHidden = false
        
        /// Call stop stream api.
        isometrik.getIsometrik().stopStream(streamId: streamId, streamUserId: userId) { [weak self] stream in
            
            guard let self else { return }
            
            /// leave channel.
            isometrik.getIsometrik().leaveChannel()
            viewModel.streamsData = []
            
            if forceFully {
                self.dismissViewController()
            } else {
                // show analytics
                visibleCell.streamLoader.isHidden = false
                self.openStreamAnalytics(inStream: false, streamId: streamId)
            }
            
        } failure: { error in
            self.dismissViewController()
        }
        
    }
    
    func fetchStreamData(cell: VerticalStreamCollectionViewCell?){
        
        guard let cell
        else { return }
        
        // fetching stream members
        viewModel.fetchStreamMembers() { error in
            if error == nil {
                DispatchQueue.main.async {
                    cell.viewModel = self.viewModel
                    self.handleMemberChanges()
                }
            } else {
                print(error ?? "")
            }
        }
        
        // fetching stream viewers count
        viewModel.fetchStreamViewerCount() { error in
            if error == nil {
                DispatchQueue.main.async {
                    cell.viewModel = self.viewModel
                }
            } else {
                print(error ?? "")
            }
        }
        
        let streamMessageView = cell.streamContainer.streamMessageView
        
        // fetching stream messages
        viewModel.fetchStreamMessages() { error in
            if error == nil {
                streamMessageView.viewModel = self.viewModel.streamMessageViewModel
                streamMessageView.messageTableView.reloadData()
                self.setHeightForMessages()
            }
        }
        
        // fetching pinned product data if any
        //self.fetchPinnedProductInStream()
        
        // fetch copublish status
        self.fetchStatusOfCoPublishRequest { _ in }
        
        // check whether viewer is in moderator's group of a stream
        if viewModel.streamUserType != .host {
            viewModel.isUserModerator { success, error in
                if error == nil {
                    cell.viewModel = self.viewModel
                    cell.streamContainer.streamMessageView.messageTableView.reloadData()
                } else {
                    ToastManager.shared.showToast(message: error.unwrap, in: self.view)
                }
            }
        }
        
        // fetch PK status if PK Challange
        guard let streamData = viewModel.streamsData[safe: viewModel.selectedStreamIndex.row] else { return }
        let isPK = streamData.isPkChallenge.unwrap
        if isPK {
            viewModel.fetchPKStreamStats { error in
                if error == nil {
                    guard let visibleCell = self.fullyVisibleCells(self.streamCollectionView) else { return }
                    
                    visibleCell.updatePKBattleTimer()
                    visibleCell.streamContainer.videoContainer.battleOn = true
                    
                    // set winner progress battle UI
                    self.setWinnerBattleProgress(stats: self.viewModel.pkStreamStats)
                    
                }
            }
        }
        
    }
    
    func toggleMicrophone(){
        let isometrik = viewModel.isometrik
        isometrik.getIsometrik().setMuteStatusForAudio()
    }
    
    func initiateCountDown(){
        
        let streamUserType = viewModel.streamUserType
        
        if streamUserType == .host {
            countDownView.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.countDownView.startTimer()
            })
            
            viewModel.timerForCounter = Timer.scheduledTimer(
                timeInterval: 1,
                target: self,
                selector: #selector(counterTime),
                userInfo: nil,
                repeats: true
            )
            
            viewModel.youAreLiveCallbackAfterCounter = {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    let viewController = YouAreLivePopUpViewController()
                    viewController.modalPresentationStyle = .overCurrentContext
                    self.present(viewController, animated: true, completion: nil)
                }
            }
        } else {
            countDownView.isHidden = true
        }
        
    }
    
    @objc func scrollToNextAvailableStream(){
        let isometrik = viewModel.isometrik
        self.dismiss(animated: true)
        isometrik.getIsometrik().leaveChannel()
    }
    
    func updateCart(){
        
        guard let cell = fullyVisibleCells(streamCollectionView) else { return }
        
        let cartBadge = cell.streamContainer.streamHeaderView.cartBadge
//        let cartCount = CartVM.cartProducts.count
        
//        if cartCount != 0 {
//            cartBadge.isHidden = false
//            cartBadge.setTitle("\(cartCount)", for: .normal)
//        } else {
//            cartBadge.isHidden = true
//        }
        
    }
    
    func handleMemberChanges(){
        
        let isometrik = viewModel.isometrik
        let streamMembers = viewModel.streamMembers
        DispatchQueue.main.async {
            
            /**
             Clear the video sessions for non exsting members in the stream
             on did set it will update the video sessions
             */
            
            if isometrik.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSessions.count != streamMembers.count {
                let userIds = streamMembers.map { $0.userID?.ism_userIdUInt() }
                self.viewModel.isometrik.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSessions.removeAll(where: {
                    !userIds.contains( $0.uid)
                })
            }
            self.updateVideoSessions()
        }
        
    }
    
    func endPKInviteTapped(){
        
        let controller = StreamPopupViewController()
        controller.titleLabel.text = "Are you sure want to Stop Streaming Together?"
        controller.cancelButton.setTitle("No", for: .normal)
        controller.actionButton.setTitle("Yes", for: .normal)
        
        controller.actionCallback = { [weak self] action in
            guard let self else { return }
            switch action {
            case .ok:
                
                let inviteId = self.viewModel.streamsData[self.viewModel.selectedStreamIndex.row].pkInviteId ?? ""
                print("INVITE ID:: is ->\(inviteId)")
                self.endPKInvite(inviteId: inviteId)
                
                break
            default:
                break
                
            }
        }
        
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true)
    }
    
    func stopPKBattleTapped(){
        
        let controller = StreamPopupViewController()
        controller.titleLabel.text = "Are you sure want to Stop PK?"
        controller.cancelButton.setTitle("No", for: .normal)
        controller.actionButton.setTitle("Yes", for: .normal)
        
        controller.actionCallback = { [weak self] action in
            guard let self else { return }
            switch action {
            case .ok:
                
                let streamsData = viewModel.streamsData
                guard let _ = streamsData[safe: viewModel.selectedStreamIndex.row]
                else { return }
                
                let pkId = self.viewModel.streamsData[self.viewModel.selectedStreamIndex.row].pkId ?? ""
                self.stopPKBattle(pkId: pkId, action: .forceStop)
                
                break
            default:
                break
                
            }
        }
        
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true)
        
    }
    
}
