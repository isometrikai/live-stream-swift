//
//  ISMMessageReply.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 29/09/22.
//

import Foundation

// MARK: - Welcome
public struct ISMMessageReplyData: Codable {
    let pageToken, msg: String?
    let messages: [ISMMessageReply]?
}

// MARK: - Message
public struct ISMMessageReply: Codable {
    var sentat: Int64?
    let senderid, senderName: String?
    let senderImage: String?
    let senderIdentifier, messageid: String?
    let messageType: Int?
    var message: String?
    var parentMessageId: String = ""
    var isloading: Bool = false
    var removeAt: Int64? = 0

    enum CodingKeys: String, CodingKey {
        case sentat, senderid
        case senderName = "sender_name"
        case senderImage = "sender_image"
        case senderIdentifier = "sender_identifier"
        case messageid
        case messageType = "message_type"
        case message
    }
}
