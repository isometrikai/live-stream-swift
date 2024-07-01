//
//  PresenceStreamStartEvent.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 14/11/22.
//

import Foundation

public struct PresenceStreamStartEvent: Codable, Hashable {
    
    public let action: String?
    public let streamId: String?
    public let streamKey: String?
    public let ingestEndPoint: String?
    public let playbackUrl: String?
    public let viewersCount: String?
    public let memberPublishingCount: Int?
    public let memberIds: [String]?
    public let createdBy: String?
    public let rtcToken: String?
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
