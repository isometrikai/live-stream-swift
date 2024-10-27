//
//  StreamMessageViewModel.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 13/09/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit
import IsometrikStream

enum ISMStreamMessageType: Int {
    case giftMessage_3D = 10
    case giftMessage = 2
    case deletedMessage = -1
    case text = 0
    case pinnedProduct = 10000
    case likeMessage = 3
    case productBought = 4
    case request = 5
    
    case changeStream = 21
    case pkStart = 23
    case changeToPK = 20
}

class StreamMessageViewModel: NSObject {
    
    var streamInfo: ISMStream
    var isometrik: IsometrikSDK
    
    var messages: [ISMComment] = []
    var giftMessages: [ISMComment] = []
    var streamUserType: StreamUserType = .viewer
    var streamUserAccess: StreamUserAccess = .user
    var skip = 0
    var limit = 10
    
    var isMessageAPILoading = false
    var isLastMessagePage = false
    
    init(streamInfo: ISMStream, isometrik: IsometrikSDK) {
        self.streamInfo = streamInfo
        self.isometrik = isometrik
    }
    
    func fetchMessages(completionHandler: @escaping(_ error: IsometrikError?) -> Void){
        
        let streamId = streamInfo.streamId.unwrap
        
        if !isMessageAPILoading && !isLastMessagePage {
            
            isMessageAPILoading = true
            
            isometrik.getIsometrik().fetchMessages(streamId: streamId, skip: skip, limit: limit) { messagesData in
                
                self.isMessageAPILoading = false
                
                // get messages and reverse it
                let reversedMessages = messagesData.messageInfo.reversed()
                
                // append messages
                if self.messages.isEmpty {
                    // append them directly
                    self.messages.append(contentsOf: reversedMessages)
                } else {
                    // insert them to top of an array
                    self.messages.insert(contentsOf: reversedMessages, at: 0)
                }
                
                if self.messages.count.isMultiple(of: self.limit) {
                    self.skip += self.limit
                } else {
                    self.isLastMessagePage = true
                }
                
                
                completionHandler(nil)
                
            } failure: { error in
                self.isMessageAPILoading = false
                let isometrikError = IsometrikError(errorMessage: "not able to fetch messages!")
                completionHandler(isometrikError)
            }
        }
        
    }
    
    func sendMessage(messageType: Int64 = 0, message: String, completionHandler: @escaping(_ message: ISMComment?, _ error: IsometrikError?) -> Void){
        
        let currentUserSession = isometrik.getUserSession()
        let userImage = currentUserSession.getUserImage()
        let userName = currentUserSession.getUserIdentifier()
        let userId = currentUserSession.getUserId()
        let name = currentUserSession.getUserName()
        
        let metaData = MessageMetaDataBody(userName: userName, userId: userId, userProfile: currentUserSession.getUserImage(), fullName: name)
        
        isometrik.getIsometrik().sendMessage(streamId: streamInfo.streamId.unwrap, senderImage: currentUserSession.getUserImage(), senderIdentifier: currentUserSession.getUserIdentifier(), senderId: currentUserSession.getUserId(), senderName: currentUserSession.getUserName(), messageType: messageType, message: message, metaData: metaData) { message in
            DispatchQueue.main.async {
                completionHandler(message, nil)
            }
        } failure: { error in
            switch error{
            case .noResultsFound(_):
                // handle noresults found here
                break
            case .invalidResponse:
                print("Message Error : Invalid Response")
            case .httpError(let errorCode, let errorMessage):
                print("\(errorCode) \(errorMessage?.error ?? "")")
            default :
                break
            }
        }
        
    }
    
    func resetToDefault(){
        messages = []
        giftMessages = []
        skip = 0
    }
    
}

