//
//  SubscriptionRequests.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 12/11/22.
//

import Foundation

/**
    Isometrik `Subscriptions` Requests
 */

extension IsometrikStream {
    
    /// Subscribe MQTT events
    /// - Parameter completionHandler: completionHandler for response data.
    public func subsribeForMQTT(clientId: String, streamStartChannel: Bool, completionHandler: @escaping (ISMCommentsData)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let requestBody = SubscriptionBody(streamStartChannel: streamStartChannel, clientId: clientId)
        let request =  ISMLiveAPIRequest(endPoint: SubscriptionRouter.addSubscription(streamStartChannel:streamStartChannel) , requestBody:requestBody)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMCommentsData, ISMLiveAPIError> ) in
            
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
    
    /// Unsubscribe MQTT events
    /// - Parameter completionHandler: completionHandler for response data.
    public func unsubscribeForMQTT(clientId: String, startStreamChannel: Bool,  completionHandler: @escaping (ISMReplyDeleteResponse)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: SubscriptionRouter.addSubscription(streamStartChannel:startStreamChannel ) , requestBody:nil)
        
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
