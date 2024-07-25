//
//  SubscriptionBody.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 12/11/22.
//

import Foundation

public struct SubscriptionBody: Codable, Hashable {
    
    private let streamStartChannel: Bool?
    private let clientId: String?
    
    public init(streamStartChannel: Bool? = nil, clientId: String? = nil) {
        self.streamStartChannel = streamStartChannel
        self.clientId = clientId
    }
    
}
