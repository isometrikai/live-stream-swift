//
//  CopublishRequests.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 12/11/22.
//

import Foundation

/**
    Isometrik `Copublish` Requests
 */

extension IsometrikStream {
    
    public func addCopublishRequest(streamId: String, completionHandler: @escaping (ISMPublisher)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let copublisherBody = CopublishBody(streamId: streamId)
        
        let request =  ISMLiveAPIRequest(endPoint: CopublishRouter.addCopublishRequest, requestBody:copublisherBody)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMPublisher, ISMLiveAPIError> ) in
            
            switch result{

            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
    
    }
    
    public func acceptCopublishRequest(streamId: String, requestByUserId: String, completionHandler: @escaping (ISMPublisher)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        
        let copublisherBody = CopublishBody(streamId: streamId,requestByUserId: requestByUserId)
        
        let request =  ISMLiveAPIRequest(endPoint: CopublishRouter.acceptCopublishRequest, requestBody:copublisherBody)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMPublisher, ISMLiveAPIError> ) in
            
            switch result{

            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
    
    }
    
    public func denyCopublishRequest(streamId: String, requestByUserId: String, completionHandler: @escaping (ISMPublisher)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
    
        let copublisherBody = CopublishBody(streamId: streamId,requestByUserId: requestByUserId)
        
        let request =  ISMLiveAPIRequest(endPoint: CopublishRouter.denyCopublishRequest, requestBody:copublisherBody)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMPublisher, ISMLiveAPIError> ) in
            
            switch result{

            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
    
    }
    
    public func deleteCopublishRequest(streamId: String,  completionHandler: @escaping (ISMPublisher)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: CopublishRouter.deleteCopublishRequest(streamId:streamId ), requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMPublisher, ISMLiveAPIError> ) in
            
            switch result{

            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
        
    }
    
    public func switchProfile(streamId: String, requestByUserId : String, isPublic: Bool = true,  completionHandler: @escaping (ISMPublisher)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let copublisherBody = CopublishBody.init(streamId: streamId,isPublic: isPublic)
        let request =  ISMLiveAPIRequest(endPoint: CopublishRouter.switchProfile, requestBody:copublisherBody)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMPublisher, ISMLiveAPIError> ) in
            
            switch result{

            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
    
    }
    
    public func fetchCopublishRequestStatus(streamId: String,  completionHandler: @escaping (ISMPublisher)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: CopublishRouter.fetchCopublishRequestStatus(streamId:streamId ), requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMPublisher, ISMLiveAPIError> ) in
            
            switch result{

            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
    
    }
    
    public func fetchCopublishRequests(streamId: String,completionHandler: @escaping (ISMPublisher)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: CopublishRouter.fetchCopublishRequests(streamId:streamId ), requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMPublisher, ISMLiveAPIError> ) in
            
            switch result{

            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
    
    }
    
    public func updatePublishStatus(streamId: String, memberId: String, publishStatus: Bool, completionHandler: @escaping (ISMPublisher)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        let copublisherBody = CopublishBody.init(streamId: streamId,memberId: memberId,startPublish: publishStatus)
        
        let request =  ISMLiveAPIRequest(endPoint: CopublishRouter.updatePublishStatus, requestBody:copublisherBody)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMPublisher, ISMLiveAPIError> ) in
            
            switch result{

            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
        
    }
    
}
