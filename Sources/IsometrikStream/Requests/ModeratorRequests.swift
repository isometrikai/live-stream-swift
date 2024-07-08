//
//  ModeratorRequests.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 14/02/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import Foundation

/**
    Isometrik `Moderators` Requests
 */

extension IsometrikStream {
    
    public func fetchModerators(streamId: String, skip: Int, limit: Int = 20, completionHandler: @escaping (ISMModerator)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: ModeratorRouter.fetchModerators(streamId: streamId, searchTags: nil, limit: limit, skip: skip) , requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMModerator, ISMLiveAPIError> ) in
            
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
    
    public func stopModerating(streamId: String, moderatorId: String,  completionHandler: @escaping (ISMModerator)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        let request =  ISMLiveAPIRequest<Any>(endPoint: ModeratorRouter.stopModerating(streamId:streamId ) , requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMModerator, ISMLiveAPIError> ) in
            
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
    
    public func addModerator(streamId: String, moderatorId: String, initiatorId: String, completionHandler: @escaping (ISMModerator)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let addModeratorBody = ModeratorBody.init(streamId: streamId, moderatorId: moderatorId)
        let request =  ISMLiveAPIRequest<Any>(endPoint: ModeratorRouter.addModerator , requestBody:addModeratorBody)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMModerator, ISMLiveAPIError>) in
            
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
    
    public func removeModerator(streamId: String, moderatorId: String, initiatorId: String,completionHandler: @escaping (ISMModerator)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        let request =  ISMLiveAPIRequest<Any>(endPoint: ModeratorRouter.removeModerator(streamId:streamId , moderatorId: moderatorId), requestBody:nil)
        
          ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMModerator, ISMLiveAPIError> ) in
            
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
