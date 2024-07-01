//
//  StreamStartEvent.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 14/11/22.
//

import Foundation

public struct StreamStartEvent: Codable, Hashable {
    
    public let action: String?
    public let streamId: String?
    public let streamDescription: String?
    public let streamImage: String?
    public let timestamp: Int64?
    public let membersCount: Int?
    public let initiatorId: String?
    public let initiatorName: String?
    public let initiatorIdentifier: String?
    public let initiatorImage: String?
    public let members: [StreamMember]?
    public let isPublic: Bool?
    public let audioOnly: Bool?
    public let multiLive: Bool?
    public let hdBroadcast: Bool?
    public let restream: Bool?
    public let restreamChannelsCount: Int?
    public let productLinked: Bool?
    public let productsCount: Int?
    public let moderatorsCount: Int?
    
}

public struct StreamMember: Codable, Hashable {
    
    public let memberId: String?
    public let memberName: String?
    public let memberIdentifier: String?
    public let isAdmin: Bool?
    
}
