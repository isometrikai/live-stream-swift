//
//  RestreamRequests.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 12/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

/**
    Isometrik `Restream` Requests
 */

public typealias restreamPayloadResponse = ((ISMRestreamData?, IsometrikError?) -> Void)

extension IsometrikStream {
    
    public func fetchRestreamChannels(completionHandler: @escaping (ISMRestreamData)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: ISMLiveUserRouter.fetchRestreamChannels, requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMRestreamData, ISMLiveAPIError> ) in
            
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
    
    public func addRestreamChannel(ingestUrl: String, enabled: Bool, channelType: RestreamChannelType, channelName: String, completionHandler: @escaping (ISMRestreamData)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let restreamBody = RestreamBody(
            ingestUrl: ingestUrl,
            channelType: channelType, 
            enabled: enabled,
            channelName: channelName
        )
        
        let request =  ISMLiveAPIRequest(endPoint: ISMLiveUserRouter.addRestreamingChannel, requestBody:restreamBody)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMRestreamData, ISMLiveAPIError> ) in
            
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
    
    public func updateRestreamChannel(channelId: String, ingestUrl: String, enabled: Bool, channelType: RestreamChannelType, channelName: String, completionHandler: @escaping (ISMRestreamData)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let restreamBody = RestreamBody(
            channelId: channelId,
            ingestUrl: ingestUrl,
            channelType: channelType,
            enabled: enabled,
            channelName: channelName
        )
        
        let request =  ISMLiveAPIRequest(endPoint: ISMLiveUserRouter.updateRestreamChannel, requestBody:restreamBody)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMRestreamData, ISMLiveAPIError> ) in
            
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
    
    public func updateAllRestreamChannel(enabled: Bool,completionHandler: @escaping (ISMRestreamData)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        
        let restreamBody = RestreamBody(
            enabled: enabled
        )
        
        let request =  ISMLiveAPIRequest(endPoint: ISMLiveUserRouter.updateAllRestreamChannelStatus, requestBody:restreamBody)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMRestreamData, ISMLiveAPIError> ) in
            
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
    
    public func deleteRestreamingChannel(channelId: String, completionHandler: @escaping (ISMRestreamData)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: ISMLiveUserRouter.deleteRestreamChannel(channelId: channelId), requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMRestreamData, ISMLiveAPIError> ) in
            
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
