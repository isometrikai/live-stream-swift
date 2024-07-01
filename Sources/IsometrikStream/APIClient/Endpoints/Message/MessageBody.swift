//
//  MessageBody.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 11/11/22.
//

import Foundation

public struct MessageBody: Codable, Hashable {
    
    public let streamId: String?
    public let ids: String?
    public let messageTypes: String?
    public let customTypes: String?
    public let senderIds: String?
    public let lastMessageTimestamp: Int?
    public let senderIdsExclusive: Bool?
    public let searchTag: String?
    public let limit: Int?
    public let skip: Int?
    public let sort: Int?
    public let messageId: String?
    public let searchableTags: [String]?
    public let messageType: Int64?
    public let deviceId: String?
    public let customType: String?
    public let body: String?
    public let parentMessageId: String?
    public let metaData: MessageMetaDataBody?
    public let senderId: String?
    public let senderImage: String?
    public let senderName: String?
    public let senderIdentifier: String?
    
    
    public init(streamId: String? = nil,
         ids: String? = nil,
         messageTypes: String? = nil ,
         customTypes: String? = nil,
         senderIds: String? = nil,
         lastMessageTimestamp: Int? = nil,
         senderIdsExclusive: Bool? = nil,
         searchTag: String? = nil,
         limit: Int? = nil,
         skip: Int? = nil,
         sort: Int? = nil,
         messageId: String? = nil,
         searchableTags: [String]? = nil,
         messageType: Int64? = nil,
         deviceId: String? = nil,
         customType: String? = nil,
         body: String? = nil,
         parentMessageId: String? = nil,
         metaData: MessageMetaDataBody? = nil,
         
         senderId: String? = nil,
         senderImage: String? = nil,
         senderName: String? = nil,
         senderIdentifier: String? = nil
    ) {
        self.streamId = streamId
        self.ids = ids
        self.messageTypes = messageTypes
        self.customTypes = customTypes
        self.senderIds = senderIds
        self.lastMessageTimestamp = lastMessageTimestamp
        self.senderIdsExclusive = senderIdsExclusive
        self.searchTag = searchTag
        self.limit = limit
        self.skip = skip
        self.sort = sort
        self.messageId = messageId
        self.searchableTags = searchableTags
        self.messageType = messageType
        self.deviceId = deviceId
        self.customType = customType
        self.body = body
        self.parentMessageId = parentMessageId
        self.metaData = metaData
        
        self.senderId = senderId
        self.senderImage = senderImage
        self.senderName = senderName
        self.senderIdentifier = senderIdentifier
    }
    
}
