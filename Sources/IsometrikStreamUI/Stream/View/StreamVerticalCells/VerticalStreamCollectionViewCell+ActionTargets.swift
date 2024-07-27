//
//  VerticalStreamCollectionViewCell+ActionTargets.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 07/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit
import IsometrikStream

extension VerticalStreamCollectionViewCell: StreamCellActionDelegate {
    
    func addActionTargets(){
        
        // stream container header targets
        
        let streamHeaderView = streamContainer.streamHeaderView
        
        streamHeaderView.closeButton.addTarget(self, action: #selector(closeStreamButtonTapped), for: .touchUpInside)
        streamHeaderView.viewerCountView.actionButton.addTarget(self, action: #selector(viewersCountTapped), for: .touchUpInside)
        streamHeaderView.streamStatusView.moderatorButton.addTarget(self, action: #selector(moderatorButtonTapped), for: .touchUpInside)
        streamHeaderView.cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        streamHeaderView.profileView.followButton.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
        streamHeaderView.profileView.profileDetailsButton.addTarget(self, action: #selector(sellerProfileTapped), for: .touchUpInside)
        streamHeaderView.streamStatusView.memberFeatureView.actionButton.addTarget(self, action: #selector(streamMembersTapped), for: .touchUpInside)
        
        // stream container footer targets
        
        let messageTextInputView = streamContainer.streamFooterView.messageTextInputView
        
        messageTextInputView.emojiButton.addTarget(self, action: #selector(messageTextViewEmojiButtonTapped), for: .touchUpInside)
        messageTextInputView.sendButton.addTarget(self, action: #selector(messageTextViewSendButtonTapped), for: .touchUpInside)
        
        let streamFooterView = streamContainer.streamFooterView
    
        streamFooterView.messageTextInputView.emojiButton.addTarget(self, action: #selector(messageTextViewEmojiButtonTapped), for: .touchUpInside)
        streamFooterView.messageTextInputView.sendButton.addTarget(self, action: #selector(messageTextViewSendButtonTapped), for: .touchUpInside)
        streamFooterView.actionButton.addTarget(self, action: #selector(alternateActionButtonTapped), for: .touchUpInside)
        
        //:
        
        // stream container pinned item targets
        
        let pinnedView = streamContainer.streamItemPinnedView
        pinnedView.clickableAreaButton.addTarget(self, action: #selector(productDetailsTapped), for: .touchUpInside)
        
        //:
        
        // stream custom loader targets
        
        streamLoader.closeActionButton.addTarget(self, action: #selector(closeStreamButtonTapped), for: .touchUpInside)
        
        //:
        
        // Schedule stream view
        
        scheduleStreamView.closeActionButton.addTarget(self, action: #selector(closeStreamButtonTapped), for: .touchUpInside)
        scheduleStreamView.goLiveButton.addTarget(self, action: #selector(startScheduledStream), for: .touchUpInside)
        
        //:
        
        // stream keyboard dismiss action target
        
        streamContainer.dismissButton.addTarget(self, action: #selector(dismissKeyboardTapped), for: .touchUpInside)
        
        //:
        
        // stream video container targets
        
        streamContainer.videoContainer.pkOverlayView.startPKBattleButton.addTarget(self, action: #selector(startPKBattle), for: .touchUpInside)
        streamContainer.videoContainer.pkOverlayView.hostToggleButton.addTarget(self, action: #selector(toggleHostInPKBattle), for: .touchUpInside)
        
        //:
        
    }
    
    // Delegate methods
    func didMessageScrolled(withStatus: ScrollStatus) {
        delegate?.didMessageScrolled(withStatus: withStatus)
    }
    
    func didDeleteButtonTapped(messageInfo: ISMComment?) {
        delegate?.didDeleteButtonTapped(messageInfo: messageInfo)
    }
    
    func didProfileTapped(messageInfo: ISMComment?) {
        delegate?.didProfileTapped(messageInfo: messageInfo)
    }
    
    func StopPKBattleAsTimerFinishes() {
        delegate?.StopPKBattleAsTimerFinishes()
    }
    
    func loadMoreMessages() {
        delegate?.loadMoreMessages()
    }
    
}
