//
//  MessageMqttEventResponse.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 14/11/22.
//

import Foundation

/**
 *  Message MQTT Response
 */

extension ISMMQTTSessionWrapper {
    
    /// Message sent data.
    /// - Parameter data: Data coming from MQTT, Type should be **Dictionary<String, Any>**
    /// - Returns: Type can be **MessageInfo** or nil.
    func messageAddEventResponse(_ data: Data , completionHandler: @escaping (MqttResult<MessageAddEvent>) -> ()) {
        
        do {
            let messageObj = try data.ism_live_decode() as MessageAddEvent
            completionHandler(.success(messageObj))
            
        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * MessageAddEventResponse *.")
            completionHandler(.failure(error))
        }
    
    }
    
    func messageReplyAddEventResponse(_ data: Data , completionHandler: @escaping (MqttResult<ISMMessageReply>) -> ()) {
        
        do {
            let messageObj = try data.ism_live_decode() as MessageReplyAddEvent
            
            let messageInfo = ISMMessageReply(sentat: Int64(messageObj.timestamp.unwrap),
                                              senderid: messageObj.senderId,
                                              senderName: messageObj.senderName,
                                              senderImage: messageObj.senderImage,
                                              senderIdentifier: messageObj.senderIdentifier,
                                              messageid: messageObj.messageId,
                                              messageType: messageObj.messageType,
                                              message: messageObj.message,
                                              parentMessageId: messageObj.parentMessageId.unwrap,
                                              isloading: false)
            completionHandler(.success(messageInfo))
            
        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * MessageReplyAddEventResponse *.")
            completionHandler(.failure(error))
        }
    }
    
    func messageRemoveEventResponse(_ data: Data , completionHandler: @escaping (MqttResult<ISMComment>) -> ()) {
        
        do {
            let messageObj = try data.ism_live_decode() as MessageRemoveEvent
            
            /// Convert json into stream info data.
            let streamInfo = ISMStream(streamId: messageObj.streamId.unwrap,
                                       initiatorName: messageObj.initiatorName.unwrap,
                                       createdBy: messageObj.initiatorId.unwrap)
            
            /// Convert json into message info data.
            let messageInfo = ISMComment(messageId: messageObj.messageId.unwrap, messageType: -1,
                                         message: messageObj.action.unwrap,
                                         streamInfo: streamInfo, deletionTime: Int64(messageObj.timestamp.unwrap))
            
            completionHandler(.success(messageInfo))
            
        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * MessageRemoveEventResponse *.")
            completionHandler(.failure(error))
        }
        
    }
    
    func messageReplyRemoveEventResponse(_ data: Data , completionHandler: @escaping (MqttResult<ISMMessageReply>) -> ()) {
        
        do {
            let messageObj = try data.ism_live_decode() as MessageReplyRemoveEvent
            
            let messageInfo = ISMMessageReply(sentat: 0, senderid: messageObj.initiatorId.unwrap, senderName: messageObj.initiatorName.unwrap , senderImage: "", senderIdentifier: "", messageid: messageObj.messageId.unwrap, messageType: -1, message: "", parentMessageId: messageObj.parentMessageId.unwrap, isloading: false, removeAt: Int64(messageObj.timestamp.unwrap))
            
            completionHandler(.success(messageInfo))
            
        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * MessageReplyRemoveEventResponse *.")
            completionHandler(.failure(error))
        }
        
    }
    

    
}
