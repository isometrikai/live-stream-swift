//
//  StreamViewController+StreamMessages.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 13/09/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit
import IsometrikStream

/**
    Extension to manage the `StreamMessages` used in the `StreamViewController` class
 */

extension StreamViewController {
    
    func sendMessage(messageText: String, messageOfType: ISMStreamMessageType = .text) {
        
        guard !messageText.isEmpty
        else { return }
        
        let messageType = Int64(messageOfType.rawValue)
        
        let streamMessageViewModel = viewModel.streamMessageViewModel
        guard let streamMessageViewModel else { return }
        streamMessageViewModel.sendMessage(messageType: messageType ,message: messageText){ message,error in }
        
//        if let _ = viewModel.scheduleStreamMessageViewModel, LiveStreamStatus(rawValue: streamData.status) == .scheduled {
//            viewModel.scheduleStreamMessageViewModel?.sendMessages(message: messageText)
//        } else {
//            let streamMessageViewModel = viewModel.streamMessageViewModel
//            guard let streamMessageViewModel else { return }
//            streamMessageViewModel.sendMessage(messageType: messageType ,message: messageText){message,error in }
//        }
        
    }
    
    func handleMessages(message: ISMComment) {
        
        guard let visibleCell = fullyVisibleCells(streamCollectionView)
        else { return }
        
        let streamMessageView = visibleCell.streamContainer.streamMessageView
        let streamMessageViewModel = viewModel.streamMessageViewModel
        let streamMessageTableView = streamMessageView.messageTableView
        
        guard let streamMessageViewModel else {
            return
        }
        
        // Handle according to messageType
        let messageType = ISMStreamMessageType(rawValue: Int(message.messageType ?? 0))
        
        // setting message height initially too
        self.setHeightForMessages()
        
        switch messageType {
        case .text, .productBought:
            
            // check for duplicate messages only if not a delete message
            if message.messageId != "" && message.messageId != nil {
                // check whether message exist with the same messageId or not
                let duplicateMessage = streamMessageViewModel.messages.filter { msg in
                    message.messageId == msg.messageId
                }
                
                if duplicateMessage.count > 0 {
                    return
                }
            }
            
            streamMessageViewModel.messages.append(message)
            streamMessageView.viewModel = streamMessageViewModel
            
            let messageCount = streamMessageViewModel.messages.count
            
            streamMessageTableView.beginUpdates()
            let index = IndexPath(row: messageCount - 1, section: 0)
            streamMessageTableView.insertRows(at: [index], with: .fade)
            streamMessageTableView.endUpdates()
            
            self.setHeightForMessages()
            
            // refresh the pinned item details for updates like, stock count
            
//            guard let productViewModel = viewModel.streamProductViewModel,
//                  let pinnedProductData = productViewModel.pinnedProductData
//            else { return }
//            
//            let pinnedProductId = pinnedProductData.childProductID ?? ""
            //self.fetchPinnedProductDetails(pinnedProductId: pinnedProductId)
            
            //:
            
            if messageType == .productBought {
                
                // Play animation when any user bought a product
                
                viewModel.streamAnimationPopupTimer?.invalidate()
                viewModel.streamAnimationPopupTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(stopAnimatingStreamAnimationPopup), userInfo: nil, repeats: false)
                
                let animationView = visibleCell.streamContainer.streamAnimationPopup
                animationView.playAnimation(message: message)
                
                view.endEditing(true)
                
                //:
                
            }
            
            break
        case .likeMessage:
            self.playLikeAnimation(imageToUse: "ic_reaction")
            break
        case .deletedMessage:
            
            // Replace the message
            
            // Get the index of the message to be replaced
            let updatedMessage = streamMessageViewModel.messages.map { msg in
                var updMsg = msg
                if msg.messageId == message.messageId {
                    updMsg = message
                }
                return updMsg
            }
            
            streamMessageViewModel.messages = updatedMessage
            streamMessageView.viewModel = streamMessageViewModel
            streamMessageTableView.reloadData()
            self.setHeightForMessages()
            
            break
            
        case .pinnedProduct:

            // set pinned item for the viewer
            print("Pinned Product Message \(message)")
            // fetch the product data and set the pinned product
            let pinnedProductId = message.metaData?.pinProductId ?? ""
            //self.fetchPinnedProductDetails(pinnedProductId: pinnedProductId)
            
            break
        case .giftMessage:
            self.handleGiftMessages(messageData: message)
            break
        case .giftMessage_3D:
            self.handle3DGiftMessages(messageData: message)
            break
        default:
            break
        }
    }
    
    func setHeightForMessages(withReload: Bool = false) {
        
        guard let visibleCell = fullyVisibleCells(streamCollectionView)
        else { return }
        
        let messageTableView = visibleCell.streamContainer.streamMessageView.messageTableView
        let messageTableViewHeightConstraint = visibleCell.streamContainer.streamMessageViewConstraint
        
        guard let messageViewModel = visibleCell.streamContainer.streamMessageView.viewModel else { return }
        let messageCount = messageViewModel.messages.count
        
        if withReload {
            messageTableView.reloadData()
        }
        
        // check before scroll to bottom, whether enabled or not
        /**
         
         if scrollToBottomForMessage {
             if !visibleCell.messages.isEmpty {
                 let indexPath = IndexPath(row: visibleCell.messages.count - 1, section: 0)
                 // if valid indexPath then only scroll otherwise not
                 if messageTableView.isValid(indexPath: indexPath) {
                     messageTableView.scrollToRow(at: indexPath , at: .bottom, animated: true)
                 }
             }
         }
         
         */
        
        messageTableView.layoutIfNeeded()
        
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        
        let ratioHeight = (screenWidth / 2) * (4/3)
        let topPadding = ism_windowConstant.getTopPadding
        let bottomPadding = ism_windowConstant.getBottomPadding
        let maximumMessageTableViewHeight = screenHeight - ( 90 + ratioHeight + 40 + 65 + topPadding + bottomPadding)
        
        let maxHeightReached = messageTableView.contentSize.height > maximumMessageTableViewHeight
        messageTableViewHeightConstraint?.constant = maxHeightReached ? maximumMessageTableViewHeight : messageTableView.contentSize.height + 5
        
        if messageCount > 0 {
            let indexPath = IndexPath(row: messageCount - 1, section: 0)
            // if valid indexPath then only scroll otherwise not
            if messageTableView.isValid(indexPath: indexPath) {
                DispatchQueue.main.async {
                    messageTableView.scrollToRow(at: indexPath , at: .bottom, animated: true)
                }
            }
        }
        
    }
    
    func reloadDataWithoutChangingScrollPosition(){
        guard let visibleCell = fullyVisibleCells(streamCollectionView)
        else { return }
        
        let messageTableView = visibleCell.streamContainer.streamMessageView.messageTableView
        let distanceFromOffset = messageTableView.contentSize.height - messageTableView.contentOffset.y
        
        messageTableView.reloadData() // reload tableView
        
        // Calculate new content offset after reload tableView
        let offset = messageTableView.contentSize.height - distanceFromOffset
        
        messageTableView.layoutIfNeeded()
        
        // set new content offset for the tableview without animation
        messageTableView.setContentOffset(CGPoint(x: 0, y: offset), animated: false)
    }
    
    func addStreamInfoMessage(message: ISMComment) {
        
        guard let visibleCell = fullyVisibleCells(streamCollectionView) else { return }
        
        DispatchQueue.main.async {
            
            visibleCell.streamContainer.streamInfoMessageView.messageData = message
            visibleCell.streamContainer.streamingInfoMessageViewHeightConstraints?.constant = 35
            
            UIView.animate(withDuration: 0.3) {
                visibleCell.layoutIfNeeded()
            }
            
        }
        
    }
    
    @objc func stopAnimatingStreamAnimationPopup(){
        
        guard let visibleCell = fullyVisibleCells(streamCollectionView)
        else { return }
        
        viewModel.streamAnimationPopupTimer?.invalidate()
        visibleCell.streamContainer.streamAnimationPopup.stopAnimation()
        
    }
    
}
