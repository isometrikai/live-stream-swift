//
//  RestreamBody.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 12/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import Foundation

public enum RestreamChannelType: Int {
    case facebook = 0
    case youtube
    case twitch
    case twitter
    case linkedin
    case custom
}

public struct RestreamBody: Codable, Hashable {
    
    public let channelId: String?
    public let ingestUrl: String?
    public let channelType: Int?
    public let enabled: Bool?
    public let channelName: String?
    
    public init(
        channelId: String? = nil,
        ingestUrl: String? = nil,
        channelType: RestreamChannelType? = nil,
        enabled: Bool? = nil,
        channelName: String? = nil
    ) {
        self.channelId = channelId
        self.ingestUrl = ingestUrl
        self.channelType = channelType?.rawValue ?? nil
        self.enabled = enabled
        self.channelName = channelName
    }
    
}
