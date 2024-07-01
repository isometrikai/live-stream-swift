//
//  StreamGiftModelData.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 11/03/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import Foundation

public struct ISMStreamGiftModelData: Codable {
    
    public let status: String?
    public let message: String?
    public let data: [ISMStreamGiftModel]?
    public let totalCount: Int?
    
}

public struct ISMStreamGiftModel: Codable {
    
    public let id: String?
    public let giftTitle: String?
    public let giftImage: String?
    public let giftAnimationImage: String?
    public let giftCount: Int?
    public let giftTag: String?
    public let virtualCurrency: Int?
    public let giftGroupId: String?
    public let applicationId: String?
    public let clientName: String?
    
}


public struct ISMCustomGiftRecieverData {
    
    public var recieverId: String
    public var recieverStreamId: String
    public var recieverStreamUserId: String
    public var recieverUserType: String
    public var recieverName: String
    
    public init(recieverId: String, recieverStreamId: String, recieverStreamUserId: String, recieverUserType: String, recieverName: String) {
        self.recieverId = recieverId
        self.recieverStreamId = recieverStreamId
        self.recieverStreamUserId = recieverStreamUserId
        self.recieverUserType = recieverUserType
        self.recieverName = recieverName
    }
    
}
