//
//  PresenceStreamStopEvent.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 14/11/22.
//

import Foundation

public struct PresenceStreamStopEvent: Codable, Hashable {
    
    public let action: String?
    public let streamId: String?
    public let timestamp: Int64?
    public let initiatorId: String?
    
}
