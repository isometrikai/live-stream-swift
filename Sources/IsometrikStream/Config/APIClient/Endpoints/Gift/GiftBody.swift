//
//  GiftBody.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 19/06/24.
//

import Foundation

public struct GiftBody: Codable, Hashable {
    
    private let senderId, isometricToken, receiverCurrency, receiverStreamId: String?
    private let currency, receiverUserId: String?
    private let amount: Int?
    private let reciverUserType, pkId, giftId: String?
    private let giftUrl: String?
    private let giftTitle: String?
    private let giftThumbnailUrl: String?
    private let IsGiftVideo, isPk: Bool?
    private let receiverName, messageStreamId: String?
    private let deviceId: String?
    
    public init(senderId: String?, isometricToken: String?, receiverCurrency: String?, receiverStreamId: String?, currency: String?, receiverUserId: String?, amount: Int?, reciverUserType: String?, pkId: String?, giftId: String?, giftUrl: String?, giftTitle: String?, giftThumbnailUrl: String?, IsGiftVideo: Bool?, isPk: Bool?, receiverName: String?, messageStreamId: String?,deviceId: String?) {
        self.senderId = senderId
        self.isometricToken = isometricToken
        self.receiverCurrency = receiverCurrency
        self.receiverStreamId = receiverStreamId
        self.currency = currency
        self.receiverUserId = receiverUserId
        self.amount = amount
        self.reciverUserType = reciverUserType
        self.pkId = pkId
        self.giftId = giftId
        self.giftUrl = giftUrl
        self.giftTitle = giftTitle
        self.giftThumbnailUrl = giftThumbnailUrl
        self.IsGiftVideo = IsGiftVideo
        self.isPk = isPk
        self.receiverName = receiverName
        self.messageStreamId = messageStreamId
        self.deviceId = deviceId
    }
    
}
