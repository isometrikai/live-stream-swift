//
//  MessageAddEvent.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 14/11/22.
//

import Foundation

public struct MessageAddEvent: Codable, Hashable {
    
    public let viewersCount: Int?
    public let streamId: String?
    public let sentAt: Int64?
    public let senderProfileImageUrl: String?
    public let senderName: String?
    public let senderIdentifier: String?
    public let senderId: String?
    public let searchableTags: [String]?
    public let replyMessage: Bool?
    public let repliesCount: Int?
    public let messageType: Int?
    public let messageId: String?
    public let membersCount: Int?
    public let deviceId: String?
    public let customType: String?
    public let body: String?
    public let action: String?
    public let metaData: MessageMetaDataBody?
    
    enum CodingKeys: String, CodingKey {
        case viewersCount
        case streamId
        case sentAt
        case senderProfileImageUrl
        case senderName
        case senderIdentifier
        case senderId
        case searchableTags
        case replyMessage
        case repliesCount
        case messageType
        case messageId
        case membersCount
        case deviceId
        case customType
        case body
        case action
        case metaData
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        viewersCount = try? values.decodeIfPresent(Int.self, forKey: .viewersCount)
        streamId = try? values.decodeIfPresent(String.self, forKey: .streamId)
        sentAt = try? values.decodeIfPresent(Int64.self, forKey: .sentAt)
        senderProfileImageUrl = try? values.decodeIfPresent(String.self, forKey: .senderProfileImageUrl)
        senderName = try? values.decodeIfPresent(String.self, forKey: .senderName)
        senderIdentifier = try? values.decodeIfPresent(String.self, forKey: .senderIdentifier)
        senderId = try? values.decodeIfPresent(String.self, forKey: .senderId)
        searchableTags = try? values.decodeIfPresent([String].self, forKey: .searchableTags)
        replyMessage = try? values.decodeIfPresent(Bool.self, forKey: .replyMessage)
        repliesCount = try? values.decodeIfPresent(Int.self, forKey: .repliesCount)
        messageType = try? values.decodeIfPresent(Int.self, forKey: .messageType)
        membersCount = try? values.decodeIfPresent(Int.self, forKey: .membersCount)
        deviceId = try? values.decodeIfPresent(String.self, forKey: .deviceId)
        customType = try? values.decodeIfPresent(String.self, forKey: .customType)
        body = try? values.decodeIfPresent(String.self, forKey: .body)
        action = try? values.decodeIfPresent(String.self, forKey: .action)
        metaData = try? values.decodeIfPresent(MessageMetaDataBody.self, forKey: .metaData)
        messageId = try? values.decodeIfPresent(String.self, forKey: .messageId)
    }
    
}

//public struct MessageMetaDataBody: Codable, Hashable {
//    
//    public let timeStamp: Int64?
//    public let pinProductId: String?
//    
//    enum CodingKeys: String, CodingKey {
//        case timeStamp
//        case pinProductId
//    }
//    
//}
