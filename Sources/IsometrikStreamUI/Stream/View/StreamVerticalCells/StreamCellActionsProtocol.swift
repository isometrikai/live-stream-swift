//
//  StreamCellActionsProtocol.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 19/09/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import Foundation
import IsometrikStream

protocol StreamCellActionDelegate {
    
    func didTapStreamClose(withIndex index: Int)
    func didTapViewerCountView()
    func didTapLiveStatusView()
    func didTapSellerProfileView()
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
    
    func StopPKBattleAsTimerFinishes()
    
    func startPKBattle()
    func toggleHostInPKBattle()
}

/**
    `extension`
 */

extension StreamCellActionDelegate {
    
    func didTapStreamClose(withIndex index: Int) {}
    func didTapViewerCountView() {}
    func didTapLiveStatusView() {}
    func didTapSellerProfileView() {}
    func didTapFollowButton() {}
    func didTapProductDetails() {}
    
    func didTapSendMessageButton(message: String) {}
    func didTapMessageEmojiButton() {}
    func didTapAlternateActionButton(withIndex index: Int) {}

    
    func didTapStreamOptions(with option: StreamOption.RawValue) {}
    func didMessageScrolled(withStatus: ScrollStatus) {}
    
    func didKeyboardDismissed(){}
    func didModeratorTapped(){}
    func didCartButtonTapped(){}
    func didStartScheduledStream(){}
    
}
