//
//  ISMComment.swift
//  ISOMetrikSDK
//
//  Created by Rahul Sharma on 22/06/21.
//  Copyright © 2021 Appscrip. All rights reserved.
//

import Foundation


public struct ISMCommentsData:Codable {
    public private(set) var messageInfo:[ISMComment] = []
    public private(set) var pageToken:String?
    public private(set) var message:String?


/// Codable keys to confirm Codable protocol
enum CodingKeys: String, CodingKey {
    case messageInfo = "messages"
    case pageToken = "pageToken"
    case message = "msg"
}
    init(messageInfo:[ISMComment],pageToken:String,message:String){
        self.messageInfo = messageInfo
        self.pageToken = pageToken
        self.message = message
    }
    /// Public initlizer decoder.
    ///
    /// - Parameter decoder: decoder
    /// - Throws: throw error while decoding
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        messageInfo = try values.decodeIfPresent([ISMComment].self, forKey: .messageInfo) ?? []
        pageToken = try? values.decodeIfPresent(String.self, forKey: .pageToken)
        message = try? values.decodeIfPresent(String.self, forKey: .message)
    }
    
    /// Encode user model.
    ///
    /// - Parameter encoder: encoder
    /// - Throws: throws error & exception while converting model
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pageToken, forKey: .pageToken)
        try container.encode(message, forKey: .message)
    }
}

public struct ISMMetadataResponse: Codable {
    let sentAt: Int64?
    let msg: String?
    let messagesCount: Int?
    let messageID: String?

    enum CodingKeys: String, CodingKey {
        case sentAt, msg, messagesCount
        case messageID = "messageId"
    }
}


/// Model class for `MessageInfo`. Inheriting protocol for `decodable/Encodable`.
public struct ISMComment: Codable {
    public private(set) var messageId: String?
    public var messageType: Int64?
    public var message: String?
    public var senderIdentifier: String?
    public var senderImage: String?
    public var senderName: String?
    public var senderId: String?
    public var sentAt: Int64?
    public var deletionTime: Int64?
    public var streamInfo: ISMStream? = nil
    public var has_replies: Bool?
    public var deviceId: String?
    
    public var metaData: MessageMetaDataBody?

    /// Codable keys to confirm Codable protocol
    enum CodingKeys: String, CodingKey {
        case accountid = "accountid"
        case projectid = "projectid"
        case messageid = "messageid"
        case messageId = "messageId"
        case messageType = "messageType"
        case message = "body"
        case deviceId
        case senderIdentifier = "senderIdentifier"
        case senderImage = "senderProfileImageUrl"
        case senderName = "senderName"
        case senderId = "senderId"
        case sentat = "sentat"
        case sentAt = "sentAt"
        case streamid = "streamid"
        case message_count = "message_count"
        case messagesCount = "repliesCount"
        case has_replies = "has_replies"
        
    }
    
    /// `Initialization` for message info
    /// - Parameters:
    ///   - messageId: Current message Id, Type should be **String**
    ///   - messageType: Current message Type, Type should be **Int64**
    ///   - message: Message string, Type should be **String**
    ///   - senderIdentifier: identifier string, Type should be **String**
    ///   - senderImage: send profile image, Type should be **String**
    ///   - senderName: sender Name, Type should be **String**
    ///   - senderId: sender Id, Type should be **String**
    ///   - sentAt: sent Time, Type should be **String**
    public init(messageId: String,
                messageType: Int64,
                message: String,
                senderIdentifier: String? = nil,
                senderImage: String? = nil,
                senderName: String? = nil,
                senderId: String? = nil,
                sentAt: Int64? = nil,
                streamInfo: ISMStream? = nil,
                deletionTime: Int64? = nil, has_replies: Bool? = nil, metaData: MessageMetaDataBody? = nil) {
        self.messageId = messageId
        self.messageType = messageType
        self.message = message
        self.senderIdentifier = senderIdentifier
        self.senderImage = senderImage
        self.senderName = senderName
        self.senderId = senderId
        self.sentAt = sentAt
        self.streamInfo = streamInfo
        self.deletionTime = deletionTime
        self.has_replies = has_replies
        self.metaData = metaData
    }
    
    /// `Initialization` for message info
    /// - Parameters:
    ///   - messageId: Current message Id, Type should be **String**
    ///   - messageType: Current message Type, Type should be **Int64**
    ///   - message: Message string, Type should be **String**
    ///   - senderIdentifier: identifier string, Type should be **String**
    ///   - senderImage: send profile image, Type should be **String**
    ///   - senderName: sender Name, Type should be **String**
    ///   - senderId: sender Id, Type should be **String**
    ///   - sentAt: sent Time, Type should be **String**
    init(messageId: String, messageType: Int64, message: String, senderIdentifier: String, senderImage: String, senderName: String, senderId: String, sentAt: Int64, has_replies: Bool) {
        self.messageId = messageId
        self.messageType = messageType
        self.message = message
        self.senderIdentifier = senderIdentifier
        self.senderImage = senderImage
        self.senderName = senderName
        self.senderId = senderId
        self.sentAt = sentAt
        self.has_replies = has_replies
    }
    
    /// Public initlizer decoder.
    ///
    /// - Parameter decoder: decoder
    /// - Throws: throw error while decoding
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        messageId = try? values.decodeIfPresent(String.self, forKey: .messageid)
        if messageId == nil{messageId = try? values.decodeIfPresent(String.self, forKey: .messageId)}
        messageType = try? values.decodeIfPresent(Int64.self, forKey: .messageType)
        message = try? values.decodeIfPresent(String.self, forKey: .message)
        senderIdentifier = try? values.decodeIfPresent(String.self, forKey: .senderIdentifier)
        senderImage = try? values.decodeIfPresent(String.self, forKey: .senderImage)
        senderName = try? values.decodeIfPresent(String.self, forKey: .senderName)
        senderId = try? values.decodeIfPresent(String.self, forKey: .senderId)
        sentAt = try? values.decodeIfPresent(Int64.self, forKey: .sentat)
        has_replies = try? values.decodeIfPresent(Bool.self, forKey: .has_replies)
        if sentAt == nil{sentAt = try? values.decodeIfPresent(Int64.self, forKey: .sentAt)}
        deviceId = try? values.decodeIfPresent(String.self, forKey: .deviceId)
    }
    
    /// Encode Message model.
    ///
    /// - Parameter encoder: encoder
    /// - Throws: throws error & exception while converting model
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(messageId, forKey: .messageId)
        try container.encode(messageType, forKey: .messageType)
        try container.encode(message, forKey: .message)
        try container.encode(senderIdentifier, forKey: .senderIdentifier)
        try container.encode(senderImage, forKey: .senderImage)
        try container.encode(senderName, forKey: .senderName)
        try container.encode(senderId, forKey: .senderId)
        try container.encode(sentAt, forKey: .sentAt)
        try container.encode(has_replies, forKey: .has_replies)
        try container.encode(deviceId, forKey: .deviceId)
    }
}

public struct ISMReplyDeleteResponse: Codable {
    public let msg: String?
    public let deletedAt: Int64?
    public let error: String?
    public let errorCode: Int?
}

public struct MessageMetaDataBody: Codable, Hashable {
    
    public let userName: String?
    public let userId: String?
    public let userProfile: String?
    
    public let timeStamp: Int64?
    public let pinProductId: String?
    public let orderDetails: StreamOrderDetail?
    
    public let fullName: String?
    public let streamData: [ISM_PK_Stream]?
    public let action: String?
    public let streamId: String?
    public let viewerId: String?
    public let intentToStop: Bool?
    public let timeInMin: Int?
    public let pkId: String?
    public let message: String?
    public let createdTs: Int64?
    
    enum CodingKeys: String, CodingKey {
        case userName
        case userId
        case userProfile
        case timeStamp
        case pinProductId
        case orderDetails
        
        case fullName
        case streamData
        case action
        case streamId
        case viewerId
        case intentToStop
        case timeInMin
        case pkId
        case message
        case createdTs
    }
    
    public init(
        userName: String,
        userId: String?,
        userProfile: String,
        timeStamp: Int64? = 0,
        pinProductId: String? = "",
        orderDetails: StreamOrderDetail? = nil,
        fullName: String,
        streamData: [ISM_PK_Stream]? = nil,
        action: String? = nil,
        streamId: String? = nil,
        viewerId: String? = nil,
        intentToStop: Bool? = nil,
        timeInMin: Int? = nil,
        pkId: String? = nil,
        message: String? = nil,
        createdTs: Int64? = nil
    ) {
        self.userName = userName
        self.userId = userId
        self.userProfile = userProfile
        self.pinProductId = pinProductId
        self.timeStamp = timeStamp
        self.orderDetails = orderDetails
        
        self.fullName = fullName
        self.streamData = streamData
        self.action = action
        self.streamId = streamId
        self.viewerId = viewerId
        self.intentToStop = intentToStop
        self.timeInMin = timeInMin
        self.pkId = pkId
        self.message = message
        self.createdTs = createdTs
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userName = try? values.decodeIfPresent(String.self, forKey: .userName)
        userId = try? values.decodeIfPresent(String.self, forKey: .userId)
        userProfile = try? values.decodeIfPresent(String.self, forKey: .userProfile)
        timeStamp = try? values.decodeIfPresent(Int64.self, forKey: .timeStamp)
        pinProductId = try? values.decodeIfPresent(String.self, forKey: .pinProductId)
        orderDetails = try? values.decodeIfPresent(StreamOrderDetail.self, forKey: .orderDetails)
        
        fullName = try? values.decodeIfPresent(String.self, forKey: .fullName)
        streamData = try? values.decodeIfPresent([ISM_PK_Stream].self, forKey: .streamData)
        action = try? values.decodeIfPresent(String.self, forKey: .action)
        streamId = try? values.decodeIfPresent(String.self, forKey: .streamId)
        viewerId = try? values.decodeIfPresent(String.self, forKey: .viewerId)
        intentToStop = try? values.decodeIfPresent(Bool.self, forKey: .intentToStop)
        timeInMin = try? values.decodeIfPresent(Int.self, forKey: .timeInMin)
        pkId = try? values.decodeIfPresent(String.self, forKey: .pkId)
        message = try? values.decodeIfPresent(String.self, forKey: .message)
        createdTs = try? values.decodeIfPresent(Int64.self, forKey: .createdTs)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userName, forKey: .userName)
        try container.encode(userId, forKey: .userId)
        try container.encode(userProfile, forKey: .userProfile)
        try container.encode(pinProductId, forKey: .pinProductId)
        try container.encode(timeStamp, forKey: .timeStamp)
        try container.encode(orderDetails, forKey: .orderDetails)
        
        try container.encode(fullName, forKey: .fullName)
        try container.encode(streamData, forKey: .streamData)
        try container.encode(userId, forKey: .userId)
        try container.encode(action, forKey: .action)
        try container.encode(streamId, forKey: .streamId)
        try container.encode(viewerId, forKey: .viewerId)
        try container.encode(intentToStop, forKey: .intentToStop)
        try container.encode(timeInMin, forKey: .timeInMin)
        try container.encode(pkId, forKey: .pkId)
        try container.encode(message, forKey: .message)
        try container.encode(createdTs, forKey: .createdTs)
    }
    
}

public struct StreamOrderDetail: Codable, Hashable {
    
    public let quantity: String?
    public let purchasedOn: Double?
    public let purchasedByUsername: String?
    public let purchasedByUserId: String?
    public let productName: String?
    public let productId: String?
    public let price: Double?
    public let currency: String?
    
}

