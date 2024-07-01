//
//  PubSubEvent.swift
//  PicoAdda
//
//  Created by Appscrip 3Embed on 12/06/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import Foundation

public struct PubsubEvent: Codable, Hashable {
    
    public let action: String?
    public let userProfileImageUrl: String?
    public let userName: String?
    public let userMetaData: PubsubUserMetaData?
    public let userIdentifier, userId: String?
    public let sentAt: Int?
    public let metaData: PubsubMetaData?
    public let messageType: Int?
    public let messageId, deviceId, customType, body: String?
    
}

public struct PubsubMetaData: Codable, Hashable {
    
    public let userName: String?
    public let status, streamId, reciverStreamId, profilepic: String?
    public let lastName: String?
    public let isStar: Bool?
    public let inviteId, firstName, accseptedUserId, accseptedStreamUserId: String?
    
}

public struct PubsubUserMetaData: Codable, Hashable {
    
    public let userName, profilePic, lastName, firstName: String?
    
}

public struct PubsubPayloadResponse: Codable, Hashable {
    public let sentAt: Int?
    public let payload: PubsubPayload?
    public let messageId, action: String?
}

public struct PubsubPayload: Codable, Hashable {
    public let type, pkId, message: String?
}

