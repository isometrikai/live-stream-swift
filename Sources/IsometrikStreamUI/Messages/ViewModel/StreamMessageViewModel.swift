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
    
    case changeStream = 21
    case pkStart = 23
    case changeToPK = 20
}

class StreamMessageViewModel: NSObject {
    
    var streamInfo: ISMStream?
    var isometrik: IsometrikSDK?
    var messages: [ISMComment] = []
    var giftMessages: [ISMComment] = []
    var streamUserType: StreamUserType = .viewer
    var skip = 0
    var limit = 10
    
    func fetchMessages(completionHandler: @escaping(_ error: IsometrikError?) -> Void){
        
        guard let streamInfo = streamInfo else {
            completionHandler(IsometrikError(errorMessage: "No Stream Data"))
            return
        }
        
        guard let isometrik = isometrik else {
            completionHandler(IsometrikError(errorMessage: "Isometrik found nil"))
            return
        }
        
        isometrik.getIsometrik().fetchMessages(streamId: streamInfo.streamId.unwrap, skip: skip, limit: limit) { messagesData in
            
            debugPrint("MESSAGE LOG :: MessageToken: \(messagesData.pageToken ?? "")\n MessagesCount \(messagesData.message?.count ?? 0)")
            
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
            }
            
            completionHandler(nil)
            
        } failure: { error in
            let isometrikError = IsometrikError(errorMessage: "not able to fetch messages!")
            completionHandler(isometrikError)
        }
        
    }
    
    func sendMessage(messageType: Int64 = 0, message: String, completionHandler: @escaping(_ message: ISMComment?, _ error: IsometrikError?) -> Void){
        
        guard let streamInfo = streamInfo else {
            completionHandler(nil, IsometrikError(errorMessage: "No Stream Data"))
            return
        }
        
        guard let isometrik = isometrik else {
            completionHandler(nil, IsometrikError(errorMessage: "Isometrik found nil"))
            return
        }
        
        let currentUserSession = isometrik.getUserSession()
        
        let userId = ""
        let userName = ""
        let metaData = MessageMetaDataBody(userName: userName, userId: userId, userProfile: currentUserSession.getUserImage(), fullName: "")
        
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
        skip = 0
    }
    
}

