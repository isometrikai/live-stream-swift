//
//  StreamCellActionsProtocol.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 19/09/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import Foundation
import IsometrikStream

enum CopublishRequestResponseType {
    case accepted
    case rejected
}

protocol StreamCellActionDelegate {
    
    func didTapStreamClose()
    func didTapViewerCountView()
    func didTapStreamMembersView()
    func didTapLiveStatusView()
    func didTapStreamerProfileView()
    func didTapFollowButton()
    func didTapProductDetails()
    
    func didTapSendMessageButton(message: String)
    func didTapMessageEmojiButton()
    func didTapAlternateActionButton(withIndex index: Int)

    
    func didTapStreamOptions(with option: StreamOption.RawValue)
    func didMessageScrolled(withStatus: ScrollStatus)
    
    func didKeyboardDismissed()
    func didModeratorTapped()
    func didCartButtonTapped()
    
    func didDeleteButtonTapped(messageInfo: ISMComment?)
    func didStartScheduledStream()
    func didProfileTapped(messageInfo: ISMComment?)
    func didCopublisherRequestResponseTapped(response: CopublishRequestResponseType, messageInfo: ISMComment?, index: Int)
    
    func StopPKBattleAsTimerFinishes()
    
    func startPKBattle()
    func toggleHostInPKBattle()
    
    func loadMoreMessages()
}

/**
    `extension`
 */

extension StreamCellActionDelegate {
    
    func didTapStreamClose() {}
    func didTapViewerCountView() {}
    func didTapStreamMembersView() {}
    func didTapLiveStatusView() {}
    func didTapStreamerProfileView() {}
    //func didTapSellerProfileView() {}
    func didTapFollowButton() {}
    func didTapProductDetails() {}
    
    func didTapSendMessageButton(message: String) {}
    func didTapMessageEmojiButton() {}
    func didTapAlternateActionButton(withIndex index: Int) {}

    
    func didTapStreamOptions(with option: StreamOption.RawValue) {}
    
    func didMessageScrolled(withStatus: ScrollStatus) {}
    func loadMoreMessages(){}
    
    func didKeyboardDismissed(){}
    func didModeratorTapped(){}
    func didCartButtonTapped(){}
    func didStartScheduledStream(){}
    
    
}
