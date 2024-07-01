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
        
        guard let isometrik = viewModel.isometrik,
              let streamsData = viewModel.streamsData,
              streamsData.count > 0,
              let streamData = streamsData[safe: index]
        else { return }
        
        let userType = viewModel.streamUserType
        let streamId = streamData.streamId.unwrap
        let userId = isometrik.getUserSession().getUserId()
        
        switch option {
        case .cancel:
            
            break
        case .ok:
            
            if userType == .host {
                stopLiveStream(streamId: streamId, userId: userId)
                self.endTimer()
            }
            
            break
        }
        
    }
    
    func stopLiveStream(streamId: String, userId: String, forceFully: Bool = false) {
        
        guard let isometrik = viewModel.isometrik,
              let visibleCell = fullyVisibleCells(streamCollectionView)
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
                print("MESSAGE COUNT \(self.viewModel.streamMessageViewModel?.messages.count)")
                streamMessageView.viewModel = self.viewModel.streamMessageViewModel
                streamMessageView.messageTableView.reloadData()
                self.setHeightForMessages()
            }
        }
        
        // fetching pinned product data if any
        self.fetchPinnedProductInStream()
        
    }
    
    func toggleMicrophone(){
        
        guard let isometrik = viewModel.isometrik else { return }
        
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
        
        guard let isometrik = viewModel.isometrik else { return }
        
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
        
        guard let isometrik = viewModel.isometrik else { return }
        let streamMembers = viewModel.streamMembers
        DispatchQueue.main.async {
            
            /**
             Clear the video sessions for non exsting members in the stream
             on did set it will update the video sessions
             */
            
            if isometrik.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSessions.count != streamMembers.count {
                let userIds = streamMembers.map { $0.userID?.ism_userIdUInt() }
                self.viewModel.isometrik?.getIsometrik().rtcWrapper.getLiveKitManager()?.videoSessions.removeAll(where: {
                    !userIds.contains( $0.uid)
                })
            }
            self.updateVideoSessions()
        }
        
    }
    
    func endPKInviteTapped(){
        
        let controller = StreamPopupViewController()
        controller.titleLabel.text = "Are you sure want to Stop Streaming Together?"
        
        controller.actionCallback = { [weak self] action in
            guard let self else { return }
            switch action {
            case .ok:
                
                guard let streamsData = viewModel.streamsData,
                      let _ = streamsData[safe: viewModel.selectedStreamIndex.row]
                else { return }
                
                let inviteId = self.viewModel.streamsData?[self.viewModel.selectedStreamIndex.row].pkInviteId ?? ""
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
        
        controller.actionCallback = { [weak self] action in
            guard let self else { return }
            switch action {
            case .ok:
                
                guard let streamsData = viewModel.streamsData,
                      let _ = streamsData[safe: viewModel.selectedStreamIndex.row]
                else { return }
                
                let pkId = self.viewModel.streamsData?[self.viewModel.selectedStreamIndex.row].pkId ?? ""
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
