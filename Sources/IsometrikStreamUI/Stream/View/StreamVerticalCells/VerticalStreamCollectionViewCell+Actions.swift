//
//  VerticalStreamCollectionViewCell+Actions.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 07/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

extension VerticalStreamCollectionViewCell {
    
    // MARK: - Stream Container Header Actions
    
    @objc func closeStreamButtonTapped(){
        delegate?.didTapStreamClose()
    }
    
    @objc func liveStatusViewTapped(){
        delegate?.didTapLiveStatusView()
    }
    
    @objc func viewerCountViewTapped(){
        delegate?.didTapViewerCountView()
    }
    
    @objc func followButtonTapped(){
        delegate?.didTapFollowButton()
    }
    
    @objc func sellerProfileTapped(){
        delegate?.didTapSellerProfileView()
    }
    
    @objc func productDetailsTapped(){
        delegate?.didTapProductDetails()
    }
    
    @objc func streamMembersTapped(){
        delegate?.didTapStreamMembersView()
    }
    
    // MARK: - Stream Container Footer Actions
    
    @objc func messageTextViewEmojiButtonTapped(){
        delegate?.didTapMessageEmojiButton()
    }
    
    @objc func messageTextViewSendButtonTapped(){
        
        let messageTextField = streamContainer.streamFooterView.messageTextInputView.messageTextField
        let messageText = messageTextField.text ?? ""
        
        messageTextField.text = ""
        
        delegate?.didTapSendMessageButton(message: messageText)
    }
    
    @objc func alternateActionButtonTapped(){
        delegate?.didTapAlternateActionButton(withIndex: self.tag)
    }
    
    @objc func dismissKeyboardTapped(){
        delegate?.didKeyboardDismissed()
    }
    
    @objc func viewersCountTapped(){
        delegate?.didTapViewerCountView()
    }
    
    @objc func moderatorButtonTapped(){
        delegate?.didModeratorTapped()
    }
    
    @objc func cartButtonTapped(){
        delegate?.didCartButtonTapped()
    }
    
    //:
    
    // Scheduled stream view
    
    @objc func startScheduledStream(){
        delegate?.didStartScheduledStream()
    }
    
    //:
    
    // Stream video container actions
    
    @objc func startPKBattle(){
        delegate?.startPKBattle()
    }
    
    @objc func toggleHostInPKBattle(){
        delegate?.toggleHostInPKBattle()
    }
    
    //:
    
}

extension VerticalStreamCollectionViewCell: StreamOptionActionDelegate {
    
    func didOptionsTapped(with option: StreamOption.RawValue) {
        delegate?.didTapStreamOptions(with: option)
        
        /**
         `In case cell needs internal changes to the actions`
         */
    }
    
}
