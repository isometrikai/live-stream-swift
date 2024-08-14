//
//  MessageRouter.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 11/11/22.
//

import UIKit
import Foundation

enum MessageRouter: ISMLiveURLConvertible, CustomStringConvertible {
    
    case fetchMessages(streamId: String, messageParam: MessageBody? = nil)
    case removeMessage(streamId: String, messageId: String)
    case sendMessage
    case addMetadata
    case fetchMessageReplies(streamId: String, parentMessageId: String, messageParam: MessageBody?)
    case sendMessageReply(messageParam: MessageBody)
    case removeMessageReply(streamId: String, parentMessageId: String, messageId: String, messageParam: MessageBody?)
    case sendHeart
    
    var description: String {
        switch self {
        case  .sendMessage:
            return "Send messages in a stream group call."
        case .removeMessage:
            return "Remove message reply from a stream group call."
        case .fetchMessages:
            return "Fetch messages in a stream group call."
        case .addMetadata:
            return "Add metadata in a stream group call."
        case .fetchMessageReplies:
            return "Fetch message replies in a stream group call."
        case .sendMessageReply:
            return "Send reply to a message!"
        case .removeMessageReply:
            return "Remove message reply from a stream group call."
        case .sendHeart:
            return "Send heart in a stream"
        }
    }
    
    var baseURL: URL{
        return URL(string:"\(ISMConfiguration.shared.primaryOrigin)")!
    }
    
    var method: ISMLiveHTTPMethod {
        switch self {
        case .sendMessage, .addMetadata, .sendMessageReply, .sendHeart :
            return .post
        case .removeMessage, .removeMessageReply :
            return .delete
        default:
            return .get
        }
    }
    
    var path: String {
        let path: String
        switch self {
        case .sendMessage:
            path = "/streaming/v2/message"
        case .removeMessage:
            path = "/streaming/v2/message"
        case .fetchMessages :
            path = "/streaming/v2/messages"
        case .addMetadata:
            path = "/streaming/v2/message/ivs/metadata"
        case .fetchMessageReplies:
            path = "/streaming/v2/message/replies"
        case .sendMessageReply:
            path = "/streaming/message/reply"
        case .removeMessageReply:
            path = "/streaming/v2/message/reply"
        case .sendHeart:
            path = "/live/v1/stream/like"
        }
        return path
    }
    
    // We are sending default headers for api, add additonal headers here
    var headers: [String : String]?{
        return nil
    }
    
    var queryParams: [String : String]? {
        var param: [String: String] = [:]
        
        switch self {
        case let .fetchMessages(streamId,messageData):
            
            param = ["streamId": "\(streamId)"]
            
            if let messageData = messageData {
                
                if let ids = messageData.ids {
                    param += ["ids": "\(ids)"]
                }
                
                if let messageTypes = messageData.messageTypes {
                    param += ["messageTypes": "\(messageTypes)"]
                }
                
                if let customTypes = messageData.customTypes {
                    param += ["customTypes": "\(customTypes)"]
                }
                
                if let senderIds = messageData.senderIds {
                    param += ["customTypes": "\(senderIds)"]
                }
                
                if let lastMessageTimestamp = messageData.lastMessageTimestamp {
                    param += ["lastMessageTimestamp": "\(lastMessageTimestamp)"]
                }
                
                if let searchTag = messageData.searchTag {
                    param += ["searchTags": "\(searchTag)"]
                }
                
                if let senderIdsExclusive = messageData.senderIdsExclusive {
                    param += ["senderIdsExclusive": "\(senderIdsExclusive)"]
                }
                
                if let limit = messageData.limit {
                    param += ["limit": "\(limit)"]
                }
                
                if let skip = messageData.skip {
                    param += ["skip": "\(skip)"]
                }
                
                if let sort = messageData.sort {
                    param += ["sort": "\(sort)"]
                }
                
            }
            break
        case let .removeMessage(streamId, messageId):
            param = [
                "streamId": "\(streamId)",
                "messageId": "\(messageId)"
            ]
            break
       case let .removeMessageReply(streamId, parentMessageId, messageId, _):
            param = [
                "streamId": "\(streamId)",
                "messageId": "\(messageId)",
                "parentMessageId": "\(parentMessageId)"
            ]
            break
        default:
            break
            
        }
        
        return param
    }
    
}

public typealias MessagePayloadResponse = ((Result<Any?, IsometrikError>) -> Void)
