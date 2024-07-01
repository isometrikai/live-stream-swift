//
//  ISMRestream.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 12/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import Foundation

public struct ISMRestreamData: Codable {
    
    public var restreamChannels: [ISMRestreamChannel]?
    public var msg: String?
    
    enum CodingKeys: String, CodingKey {
        case restreamChannels
        case msg
    }
    
}

public struct ISMRestreamChannel: Codable {
    
    public var ingestUrl: String?
    public var enabled: Bool?
    public var channelType: Int?
    public var channelName: String?
    public var channelId: String?
    
    enum CodingKeys: String, CodingKey {
        case ingestUrl
        case enabled
        case channelType
        case channelName
        case channelId
    }
    
    public init(
        ingestUrl: String? = nil,
        enabled: Bool? = false,
        channelType: Int? = nil,
        channelName: String? = nil,
        channelId: String? = nil
    ) {
        self.ingestUrl = ingestUrl
        self.enabled = enabled
        self.channelType = channelType
        self.channelName = channelName
        self.channelId = channelId
    }

}
