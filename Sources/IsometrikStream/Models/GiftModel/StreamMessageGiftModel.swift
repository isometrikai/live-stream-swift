//
//  StreamMessageGiftModel.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 26/06/24.
//

import Foundation

public struct StreamMessageGiftModel: Codable {
    
    public var message: String?
    public var giftName: String?
    public var giftCategoryName: String? = ""
    public var coinsValue: Int?
    public var giftThumbnailUrl: String?
    public var reciverStreamUserId: String? = ""
    public var receiverName: String? = ""
    public var totalCoinsRecived: Int?
    
    enum CodingKeys: String, CodingKey {
        case message
        case giftName
        case giftCategoryName
        case coinsValue
        case giftThumbnailUrl
        case reciverStreamUserId
        case receiverName
        case totalCoinsRecived
    }
    
    public init(message:String = "", giftName: String = "", giftCategoryName: String = "", coinsValue:Int = 0, giftThumbnailUrl: String = "", reciverStreamUserId: String = "", receiverName: String = "", totalCoinsRecived: Int = 0) {
        self.message = message
        self.giftName = giftName
        self.giftCategoryName = giftCategoryName
        self.coinsValue = coinsValue
        self.giftThumbnailUrl = giftThumbnailUrl
        self.reciverStreamUserId = reciverStreamUserId
        self.receiverName = receiverName
        self.totalCoinsRecived = totalCoinsRecived
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decodeIfPresent(String.self, forKey: .message)
        giftName = try? values.decodeIfPresent(String.self, forKey: .giftName)
        giftCategoryName = try? values.decodeIfPresent(String.self, forKey: .giftCategoryName)
        coinsValue = try? values.decodeIfPresent(Int.self, forKey: .coinsValue)
        giftThumbnailUrl = try? values.decodeIfPresent(String.self, forKey: .giftThumbnailUrl)
        reciverStreamUserId = try? values.decodeIfPresent(String.self, forKey: .reciverStreamUserId)
        receiverName = try? values.decodeIfPresent(String.self, forKey: .receiverName)
        totalCoinsRecived = try? values.decodeIfPresent(Int.self, forKey: .totalCoinsRecived)
    }
    
}
