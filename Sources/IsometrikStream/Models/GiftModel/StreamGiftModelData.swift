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
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.giftTitle = try container.decodeIfPresent(String.self, forKey: .giftTitle)
        self.giftImage = try container.decodeIfPresent(String.self, forKey: .giftImage)
        self.giftAnimationImage = try container.decodeIfPresent(String.self, forKey: .giftAnimationImage)
        self.giftCount = try container.decodeIfPresent(Int.self, forKey: .giftCount)
        self.giftTag = try container.decodeIfPresent(String.self, forKey: .giftTag)
        self.virtualCurrency = try container.decodeIfPresent(Int.self, forKey: .virtualCurrency)
        self.giftGroupId = try container.decodeIfPresent(String.self, forKey: .giftGroupId)
        self.applicationId = try container.decodeIfPresent(String.self, forKey: .applicationId)
        self.clientName = try container.decodeIfPresent(String.self, forKey: .clientName)
    }
    
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
