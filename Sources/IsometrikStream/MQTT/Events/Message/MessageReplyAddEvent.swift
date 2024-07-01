//
//  MessageReplyAddEvent.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 14/11/22.
//

import Foundation

public struct MessageReplyAddEvent: Codable, Hashable {
    
    public let action: String?
    public let streamId: String?
    public let messageId: String?
    public let timestamp: Int64?
    public let initiatorId: String?
    public let senderId: String?
    public let senderIdentifier: String?
    public let senderImage: String?
    public let senderName: String?
    public let message: String?
    public let messageType: Int?
    public let parentMessageId: String?
    
}
