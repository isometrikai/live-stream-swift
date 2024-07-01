//
//  MemberRequests.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 12/11/22.
//



/**
    Isometrik `Members` Requests
 */

import Foundation
import UIKit

extension IsometrikStream {
    
    /// Add members
    /// - Parameters:
    ///   - streamId: Current runing stream Id, Type should be **String**.
    ///   - memberId: Which member need to add, Type should be **String**.
    ///   - initiatorId: Create by, Type should be **String**.
    ///   - completionHandler: completionHandler for response data.
    public func addMember(streamId: String, memberId: String, completionHandler: @escaping (ISMMember)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let memberBody = MemberBody.init(streamId: streamId,memberId:memberId)
        
        let request =  ISMLiveAPIRequest(endPoint: MemberRouter.addMember, requestBody:memberBody)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMMember, ISMLiveAPIError> ) in
    
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
    
    /// Fetch members
    /// - Parameters:
    ///   - streamId: Current runing stream Id, Type should be **String**.
    ///   - completionHandler: completionHandler for response data.
    public func fetchMembers(streamId: String, skip: Int = 0, limit: Int = 20, completionHandler: @escaping ([ISMMember])->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: MemberRouter.fetchMembers(streamId:streamId, searchTag: nil, skip: skip, limit: limit), requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request, showLoader: false) { (result :ISMLiveResult<ISMMembersData, ISMLiveAPIError> ) in
    
            switch result{
            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse.members ?? [])
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
        
    }
    
    /// Remove member from stream.
    /// - Parameters:
    ///   - streamId: Current runing stream Id, Type should be **String**.
    ///   - memberId: Stream member id, Type should be **String**.
    ///   - completionHandler: completionHandler for response data.
    public func leaveMember(streamId: String, completionHandler: @escaping (ISMMember)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: MemberRouter.leaveMember(streamId:streamId), requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMMember, ISMLiveAPIError> ) in
    
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
    
    /// Remove member from stream by Initiator.
    /// - Parameters:
    ///   - streamId: Current runing stream Id, Type should be **String**.
    ///   - initiatorId: Stream start by user,  Type should be **String**.
    ///   - memberId: Stream member id, Type should be **String**.
    ///   - completionHandler: completionHandler for response data.
    public func removeMember(streamId: String, memberId: String, completionHandler: @escaping (ISMMember)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: MemberRouter.removeMember(streamId:streamId, memberId: memberId), requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMMember, ISMLiveAPIError> ) in
    
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
    
    public func updatePublishStatus(streamId: String, startPublish: Bool,completionHandler: @escaping (ISMPublishStatus)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let memberBody = MemberBody.init(streamId: streamId,startPublish:startPublish)
        let request =  ISMLiveAPIRequest(endPoint: MemberRouter.updatePublishStatus, requestBody:memberBody)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMPublishStatus, ISMLiveAPIError> ) in
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
    
    public func updateUserPublishStatus(userId: String,completionHandler: @escaping (ISMPublishStatus)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        let memberBody = MemberBody.init(userId: userId)
        let request =  ISMLiveAPIRequest(endPoint: MemberRouter.updateUserPublishStatus, requestBody:memberBody)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMPublishStatus, ISMLiveAPIError> ) in
    
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
