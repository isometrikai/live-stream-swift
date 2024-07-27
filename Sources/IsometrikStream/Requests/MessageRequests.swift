//
//  MessageRequests.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 12/11/22.
//

import UIKit

/**
    Isometrik `Message` Requests
 */

extension IsometrikStream {
    
    /// Fetch messages
    /// - Parameters:
    ///   - streamId: for need to fetch messages. Type should be **String**
    ///   - userId: for need to fetch messages. Type should be **String**
    ///   - completionHandler: completionHandler for response data.
    public func fetchMessages(streamId: String, skip: Int = 0, limit: Int = 10,  completionHandler: @escaping (ISMCommentsData)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
     
        let request =  ISMLiveAPIRequest<Any>(endPoint: MessageRouter.fetchMessages(streamId:streamId , messageParam: MessageBody(messageTypes: "0", limit: limit, skip: skip)), requestBody:nil)
        
       
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMCommentsData, ISMLiveAPIError> ) in
            
            switch result{
                
            case .success(var comment, _) :
                DispatchQueue.main.async {
                    completionHandler(comment)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
                
            }
        }
    }
    
    /// Remove messages
    /// - Parameters:
    ///   - streamId: Current runing stream Id, Type should be **String**.
    ///   - memberId: For remove the message, Type should be **String**.
    ///   - memberName: For remove the message, Type should be **String**.
    ///   - messageId: To remove the message, Type should be **String**.
    ///   - removeTime: at Time, Type should be **Int64**.
    ///   - completionHandler: completionHandler for response data.
    public func removeMessage(streamId: String, messageId: String, completionHandler: @escaping (ISMComment)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: MessageRouter.removeMessage(streamId:streamId , messageId: messageId), requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMComment, ISMLiveAPIError> ) in
            
            switch result{
                
            case .success(var comment, _) :
                DispatchQueue.main.async {
                    completionHandler(comment)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
                
            }
        }
        
    }
    
    /// Send Message
    /// - Parameters:
    ///   - streamId: Current runing stream Id, Type should be **String**.
    ///   - senderImage: Sender image, Type should be **String**.
    ///   - senderIdentifier: sender Identifier, Type should be **String**.
    ///   - senderId: senderId, Type should be **String**.
    ///   - senderName: Name of sender, Type should be **String**.
    ///   - messageType: Message Type, Type should be **String**.
    ///   - message: Message text, Type should be **String**.
    ///   - completionHandler: completionHandler for response data.
    public func sendMessage(streamId: String, senderImage: String, senderIdentifier: String, senderId: String, senderName: String, messageType: Int64, message: String, metaData: MessageMetaDataBody?, completionHandler: @escaping (ISMComment)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        
        let messageParam = MessageBody(
            streamId: streamId,
            messageType: messageType,
            deviceId: deviceId,
            body: message,
            metaData: metaData
        )
        
        let request =  ISMLiveAPIRequest(endPoint: MessageRouter.sendMessage, requestBody:messageParam)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMComment, ISMLiveAPIError> ) in
            
            switch result{
                
            case .success(var comment, _) :
                comment.senderName = senderName
                comment.senderImage = senderImage
                comment.senderId = senderId
                comment.senderIdentifier = senderIdentifier
                comment.message = message
                comment.messageType = messageType
                DispatchQueue.main.async {
                    completionHandler(comment)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
                
            }
        }
    
    }
    
    /// Add Meta data
    /// - Parameters:
    ///   - streamId: Current runing stream Id, Type should be **String**.
    ///   - senderId: senderId, Type should be **String**.
    ///   - message: Message text, Type should be **String**.
    ///   - completionHandler: completionHandler for response data.
    public func addMetadata(streamId: String , senderId: String, message: String, completionHandler: @escaping (ISMMetadataResponse)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let messageParam = MessageBody(
            streamId: streamId
            //metadata: MessageMetaDataBody(description: message)
        )
        
        let request =  ISMLiveAPIRequest(endPoint: MessageRouter.addMetadata, requestBody:messageParam)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMMetadataResponse, ISMLiveAPIError> ) in
            
            switch result{
                
            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
                
            }
        }
    
    }
    
    /// Fetch message replies in a stream
    /// - Parameters:
    ///   - pageToken: pageToken description
    ///   - streamId: streamId description
    ///   - userId: userId description
    ///   - messageId: messageId description
    ///   - messageSentAt: messageSentAt description
    ///   - completionHandler: completionHandler for response data.
    public func fetchMessageReplies(skip: Int = 0, streamId: String, messageId: String, completionHandler: @escaping (ISMMessageReplyData)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: MessageRouter.fetchMessageReplies(streamId:streamId , parentMessageId: messageId, messageParam: MessageBody(skip: skip)), requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMMessageReplyData, ISMLiveAPIError> ) in
            
            switch result{
                
            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
                
            }
        }
    }
    
    /// Send reply to message in a stream
    /// - Parameters:
    ///   - streamId: streamId description
    ///   - senderImage: senderImage description
    ///   - senderName: senderName description
    ///   - senderIdentifier: senderIdentifier description
    ///   - senderId: senderId description
    ///   - parentMessageSentAt: parentMessageSentAt description
    ///   - parentMessageId: parentMessageId description
    ///   - messageType: messageType description
    ///   - message: message description
    ///   - completionHandler: completionHandler for response data.
    public func sendMessageReply(streamId: String, senderImage: String ,senderName: String, senderIdentifier: String, senderId: String, parentMessageSentAt: String, parentMessageId: String, messageType: Int, message: String,completionHandler: @escaping (ISMMetadataResponse)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let messageBody = MessageBody(
            streamId: streamId,
            parentMessageId: parentMessageId, senderId: senderId,
            senderImage: senderImage,
            senderName: senderName,
            senderIdentifier: senderIdentifier
        )
        
        let request =  ISMLiveAPIRequest(endPoint: MessageRouter.sendMessageReply(messageParam: messageBody), requestBody:messageBody)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMMetadataResponse, ISMLiveAPIError> ) in
            
            switch result{
                
            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
                
            }
        }
        
    }
    
    /// Delete reply
    public func removeMessageReply(streamId: String, parentMessageId: String, messageId: String, completionHandler: @escaping (ISMReplyDeleteResponse)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: MessageRouter.removeMessageReply(streamId:streamId , parentMessageId: parentMessageId, messageId: messageId, messageParam: nil), requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMReplyDeleteResponse, ISMLiveAPIError> ) in
            
            switch result{
                
            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)

            }
        }
        

    }
    
    public func sendHeartMessage(streamId: String, senderImage: String, senderIdentifier: String, senderId: String, senderName: String, messageType: Int64, message: String, completionHandler: @escaping (ISMReplyDeleteResponse)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        
        let messageParam = MessageBody(
            streamId: streamId,
            deviceId: deviceId,
            customType: "like",
            senderId: senderId,
            senderImage: senderImage,
            senderName: senderName,
            senderIdentifier: senderIdentifier
        )
        
        let request =  ISMLiveAPIRequest(endPoint: MessageRouter.sendHeart, requestBody:messageParam)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMReplyDeleteResponse, ISMLiveAPIError> ) in
            
            switch result{
                
            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)

            }
        }
    
    }
    
}
