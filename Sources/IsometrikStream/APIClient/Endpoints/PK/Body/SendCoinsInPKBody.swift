//
//  SendCoinsInPKBody.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 12/12/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import Foundation

public struct SendCoinsInPKBody: Codable, Hashable {
    
    private let senderId: String?
    private let senderName: String?
    private let senderType: String?
    private let coins: String?
    private let receiverId: String?
    private let receiverType: String?
    private let receiverName: String?
    private let receiverCurrency: String?
    private let streamId: String?
    private let txnId: String?
    private let transferedCoins: Double?
    private let receiverTransfer: Double?
    private let pkId: String?

    public init(senderId: String, senderName: String, senderType: String, coins: String, receiverId: String, receiverType: String, receiverName: String, receiverCurrency: String, streamId: String, txnId: String, transferedCoins: Double, receiverTransfer: Double, pkId: String) {
        
        self.senderId = senderId
        self.senderName = senderName
        self.senderType = senderType
        self.coins = coins
        self.receiverId = receiverId
        self.receiverType = receiverType
        self.receiverName = receiverName
        self.receiverCurrency = receiverCurrency
        self.streamId = streamId
        self.txnId = txnId
        self.transferedCoins = transferedCoins
        self.receiverTransfer = receiverTransfer
        self.pkId = pkId
    }
    
}
