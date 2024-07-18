//
//  StreamViewController+GiftActions.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 26/06/24.
//

import UIKit
import Foundation
import IsometrikStream

extension StreamViewController {
    
    func giftTapped(){
        
        guard let isometrik = viewModel.isometrik,
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row],
              let recieverData = getGiftRecieverData()
        else { return }
        
        let controller = StreamGiftPickerViewController(isometrik: isometrik, streamInfo: streamData, recieverGiftData: recieverData)
        
        controller.viewModel.sendGift = { [weak self] data in
            self?.sendGift(giftData: data, forInsert: true)
        }
        
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    func getGiftRecieverData() -> ISMCustomGiftRecieverData? {
        
        guard let isometrik = viewModel.isometrik,
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return nil }
        
        var recieverStreamId = ""
        var recieverStreamUserId = ""
        var recieverId = ""
        var recieverName = ""
        var memberId = ""
        var recieverUserType = ""
        
        let currentHost = viewModel.streamMembers.filter { $0.isAdmin == true }
        let hostUserId = isometrik.getHostUserId()
        let streamId = streamData.streamId.unwrap
        let initiatorId = streamData.initiatorId.unwrap
        let userName = streamData.userDetails?.userName ?? ""
        
        if currentHost.count > 0 {
            memberId = currentHost[0].userID ?? ""
            recieverUserType = memberId == hostUserId ? "publisher" : "co-publisher"
        }
        
        if viewModel.copublisherViewer {
            recieverStreamId = viewModel.ghostStreamId
            recieverStreamUserId = viewModel.ghostStreamUserId
            recieverId = viewModel.ghostUserId
            recieverName = ""
        } else {
            recieverStreamId = streamId
            recieverStreamUserId = initiatorId
            recieverId = initiatorId
            recieverName = userName
        }
        
        if let firstUserDetails = streamData.firstUserDetails,
           let secondUserDetails = streamData.secondUserDetails
        {
            print("First User Detail :::-- \(firstUserDetails)")
            print("Second User Detail :::-- \(secondUserDetails)")
            
            if currentHost.count > 0 {
                
                if firstUserDetails.userId == memberId {
                    recieverStreamId = firstUserDetails.streamId.unwrap
                    recieverStreamUserId = firstUserDetails.userId.unwrap
                    recieverId = firstUserDetails.userId.unwrap
                    recieverName = firstUserDetails.userName.unwrap
                }
                
                if firstUserDetails.userId != "" {
                    recieverUserType = firstUserDetails.userId  ==  memberId ? "publisher" : "co-publisher"
                }
                
                if secondUserDetails.userId == memberId {
                    recieverStreamId = secondUserDetails.streamId.unwrap
                    recieverStreamUserId = secondUserDetails.userId.unwrap
                    recieverId = secondUserDetails.userId.unwrap
                    recieverName = secondUserDetails.userName.unwrap
                }
                
            }
            
        }
        
        let giftData = ISMCustomGiftRecieverData(
            recieverId: recieverId,
            recieverStreamId: recieverStreamId,
            recieverStreamUserId: recieverStreamUserId,
            recieverUserType: recieverUserType,
            recieverName: recieverName
        )
        
        print("Custom gift data ::::-- \(giftData)")
        
        return giftData
        
    }
    
    func sendGift(giftData: StreamMessageGiftModel, forInsert: Bool = false){
    
        guard let encodedData = try? JSONEncoder().encode(giftData),
              let giftJsonString = String(data: encodedData, encoding: .utf8)
        else { return }
        
        if giftData.giftCategoryName.unwrap == "3D" {
            sendMessage(messageText: giftJsonString, messageOfType: .giftMessage_3D)
        }
        sendMessage(messageText: giftJsonString, messageOfType: .giftMessage)
        
    }
    
    func handleGiftMessages(messageData: ISMComment) {
        
        guard let visibleCell = fullyVisibleCells(streamCollectionView),
              let streamMessageViewModel = viewModel.streamMessageViewModel else { return }
        
        let giftContainerView = visibleCell.streamContainer.streamGiftMessageView
        let giftTableView = giftContainerView.giftTableView
        let giftMessages = streamMessageViewModel.giftMessages
        
        giftTableView.beginUpdates()
        
        if giftMessages.count > 2 {
            viewModel.streamMessageViewModel?.giftMessages.remove(at: 2)
            let index = IndexPath(row: 2, section: 0)
            giftTableView.deleteRows(at: [index], with: .none)
        }
        
        viewModel.streamMessageViewModel?.giftMessages.insert(messageData, at: 0)
        giftContainerView.giftMessages = viewModel.streamMessageViewModel?.giftMessages ?? []
        
        let index = IndexPath(row: 0, section: 0)
        giftTableView.insertRows(at: [index], with: .right)
        
        updateGiftTimer()
        
        // handling animated gift here.
        playAnimatedGift(messageInfo: messageData)
        
        giftTableView.endUpdates()
        
        // on recieving gift messages update for battle progress
        print("WHILE SENDING MESSAGES :::: \(messageData.message ?? "")")
        setWinnerBattleProgress(messageInfo: messageData.message ?? "")
        
    }
    
    func updateGiftTimer(){
        viewModel.giftTimer?.invalidate()
        viewModel.giftTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(giftTimerTapped), userInfo: nil, repeats: true)
    }
    
    @objc func giftTimerTapped(){
        
        guard let visibleCell = fullyVisibleCells(streamCollectionView),
              let streamMessageViewModel = viewModel.streamMessageViewModel
        else { return }
        
        let giftMessages = streamMessageViewModel.giftMessages
        
        if giftMessages.count > 0 {
            
            let giftMessageContainer = visibleCell.streamContainer.streamGiftMessageView
            let giftTableView = giftMessageContainer.giftTableView
            
            giftTableView.beginUpdates()
            
            let count = giftMessages.count
            viewModel.streamMessageViewModel?.giftMessages.remove(at: count - 1)
            giftMessageContainer.giftMessages = viewModel.streamMessageViewModel?.giftMessages ?? []
            giftTableView.deleteRows(at: [IndexPath(row: count - 1, section: 0)], with: .left)
            
            giftTableView.endUpdates()
            
        }
    }
    
    func handle3DGiftMessages(messageData: ISMComment) {
        
        viewModel.animated3DGiftTimer?.invalidate()
        viewModel.animated3DGiftTimer = nil
        viewModel.animated3DGiftTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.resetGif), userInfo: nil, repeats: false)
        
        guard let visibleCell = fullyVisibleCells(streamCollectionView) else { return }
        
        let message = messageData.message ?? ""
        let gifCoverImageView = visibleCell.streamContainer.giftAnimationCoverView
        
        
        if let data = message.data(using: .utf8) {
            do {
                // Remove the outer quotes and double-escaping
                let trimmedString = String(data: data, encoding: .utf8)?
                    .trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                    .replacingOccurrences(of: "\\\"", with: "\"")

                if let jsonData = trimmedString?.data(using: .utf8) {
                    let giftModel = try JSONDecoder().decode(ISMStreamGiftModel.self, from: jsonData)
                    
                    let giftURLString = giftModel.giftAnimationImage ?? ""
                    visibleCell.streamContainer.giftAnimationCoverView.image = UIImage()
                    if let url = URL(string: giftURLString) {
                        gifCoverImageView.kf.setImage(with: url)
                    }
                    
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }
        
    }
    
    @objc func resetGif(){
        guard let visibleCell = fullyVisibleCells(streamCollectionView) else { return }
        visibleCell.streamContainer.giftAnimationCoverView.image = UIImage()
    }
    
    func playAnimatedGift(messageInfo: ISMComment) {
        
//        let message = messageInfo.message ?? ""
//        
//        let giftArray = ["dragon", "wolf", "panther", "çakirdostum", "dinazorx", "fil", "ghosthorse", "ghostrider", "kadinmelek", "kaplan", "kurukafa", "yavrudinazor"]
        
//        guard let data = message.data(using: String.Encoding.utf8),
//              let giftModel = try? JSONDecoder().decode(GiftModel.self, from: data) else { return }
//        
//        let giftName = giftModel.giftName?.lowercased()
//        
//        if giftArray.contains(giftName ?? "") {
//            
//            let giftName = giftName ?? ""
//            
//            print("GIFTNAME ::::: --->>> \(giftName)")
//            
//            if mainDataContainerView.animatedGiftView.player == nil {
//                mainDataContainerView.animatedGiftView.giftName = giftName
//            }
//            
//            delegate?.didRecieveAnimatedGift()
//            
//        }
        
    }
    
}
