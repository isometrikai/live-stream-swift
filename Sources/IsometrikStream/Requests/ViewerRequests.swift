//
//  ViewerRequests.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 12/11/22.
//

/**
    Isometrik `Viewers` Requests
 */

import Foundation
import UIKit

extension IsometrikStream {
    
    /// Add viewer into stream.
    /// - Parameters:
    ///   - viewerId: Which viewer need to add into stream, Type should be **String**
    ///   - streamId: Which stream need to add the viewer, Type should be **String**
    ///   - completionHandler: completionHandler for response data.
    public func addViewer(viewerId: String, streamId: String,completionHandler: @escaping (ISMStream)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        let viewerBody = ViewerBody(streamId: streamId,viewerId: viewerId)
        
        let request =  ISMLiveAPIRequest(endPoint: ViewerRouter.addViewer(streamId: streamId) , requestBody:viewerBody)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMStream, ISMLiveAPIError>) in
            
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
    
    /// Fetch stream viewer count
    /// - Parameters:
    ///   - streamId: Which stream viewer count need to fetch, Type should be **String**
    ///   - completionHandler: completionHandler for response data.
    public func fetchViewersCount(streamId: String,completionHandler: @escaping (ISMViewerCount)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        let request =  ISMLiveAPIRequest<Any>(endPoint: ViewerRouter.fetchViewersCount(streamId: streamId) , requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMViewerCount, ISMLiveAPIError> ) in
            
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
    
    /// Fetch stream viewers.
    /// - Parameters:
    ///   - streamId: Which stream viewer need to fetch, Type should be **String**
    ///   - completionHandler: completionHandler for response data.
    public func fetchViewers(streamId: String, skip: Int = 0 ,limit: Int = 10, searchTag: String? = nil, completionHandler: @escaping (ISMViewersData)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        let request =  ISMLiveAPIRequest<Any>(endPoint: ViewerRouter.fetchViewers(streamId: streamId,skip: skip, limit: limit, searchTag: searchTag) , requestBody:nil)
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMViewersData, ISMLiveAPIError> ) in
            
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
    
    /// Remove viewer from stream.
    /// - Parameters:
    ///   - streamId: Which stream need to remove the viewer, Type should be **String**
    ///   - viewerId: Which viewer need to remove from stream, Type should be **String**
    ///   - completionHandler: completionHandler for response data.
    public func leaveViewer(streamId: String, viewerId: String, completionHandler: @escaping (ISMViewer)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: ViewerRouter.leaveViewer(streamId: streamId), requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMViewer, ISMLiveAPIError>) in
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
    
    /// Delete viewer from stream
    /// - Parameters:
    ///   - streamId: Which stream need to remove the viewer, Type should be **String**
    ///   - initiatorId: Which viewer need to remove from stream, Type should be **String**
    ///   - viewerId: Which viewer need to remove from stream, Type should be **String**
    ///   - completionHandler: completionHandler for response data.
    public func removeViewer(streamId: String, viewerId: String, initiatorId: String, completionHandler: @escaping (ISMViewer)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let viewerBody = ViewerBody(streamId: streamId,viewerId: viewerId,initiatorId: initiatorId)
        
        let request =  ISMLiveAPIRequest(endPoint: ViewerRouter.removeViewer(streamId: streamId, viewerId: viewerId), requestBody:viewerBody)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMViewer, ISMLiveAPIError>) in
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
    
    public func fetchViewersForAnalytics(streamId: String, skip: Int = 0, limit: Int = 20, completionHandler: @escaping (StreamAnalyticViewersResponseModel)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        let request =  ISMLiveAPIRequest<Any>(endPoint: ViewerRouter.fetchViewersForAnalytics(streamId: streamId, skip: skip, limit: limit), requestBody:nil)
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<StreamAnalyticViewersResponseModel, ISMLiveAPIError> ) in
            
            switch result{
            case .success(let response, _) :
                DispatchQueue.main.async {
                    completionHandler(response)
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
