//
//  MessageReplyRemoveEvent.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 14/11/22.
//

import Foundation

public struct MessageReplyRemoveEvent: Codable, Hashable {
    
    public let action: String?
    public let streamId: String?
    public let messageId: String?
    public let timestamp: Int64?
    public let initiatorId: String?
    public let initiatorName: String?
    public let parentMessageId: String?
    
}
