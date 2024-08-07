//
//  PublisherViewModel.swift
//  LiveStream
//
//  Created by Dheeraj Kumar Sharma on 29/06/23.
//

import Foundation
import IsometrikStream
import UIKit

enum PublisherRequest {
    case success
    case failure(msg: String)
}

enum RequestingType {
    case sending
    case accepting
}

protocol StreamRequestsActionDelegate {
//    func didRequestToCoPublisher(user: ISMStreamUser , streamInfo: ISMStream)
    func didStartPublishingVideo()
//    func didDeleteRequestTapped(user: ISMStreamUser , streamInfo: ISMStream)
    func didLeaveStream()
}

class PublisherViewModel {
    
    var isometrik: IsometrikSDK
    var streamData: ISMStream
    var user: ISMStreamUser?
    
    var requestList: [ISMRequest] = []
    var publisherStatus: ISMPublisher? = nil
    var requestingType: RequestingType? = .sending
    var imagesArr: [String] = []
    
    var success_callback: ((ISMPublisher?) -> Void)?
    var delegate: StreamRequestsActionDelegate?
    var stackViewHeightConstraint: NSLayoutConstraint?
    var stackViewWidthConstraint: NSLayoutConstraint?
    
    init(isometrik: IsometrikSDK, streamData: ISMStream) {
        self.isometrik = isometrik
        self.streamData = streamData
    }
    
    func getRequestList(completion: @escaping(PublisherRequest) -> Void){
        let streamId = streamData.streamId.unwrap
        isometrik.getIsometrik().fetchCopublishRequests(streamId: streamId) { result in
            self.requestList = result.requests ?? []
            completion(.success)
        } failure: { error in
            switch error{
            case .noResultsFound(_):
                // handle noresults found here
                break
            case .invalidResponse:
                completion(.failure(msg: "CoPublish Error : Invalid Response"))
            case.networkError(let error):
                completion(.failure(msg: "Network Error \(error.localizedDescription)"))
            case .httpError(let errorCode, let errorMessage):
                completion(.failure(msg: "\(errorCode) \(errorMessage?.error ?? "")"))
            default :
                break
            }
        }
        
    }
    
    func sendCopublishingRequest(completion: @escaping(PublisherRequest) -> Void){
        
        let streamId = streamData.streamId.unwrap
        isometrik.getIsometrik().addCopublishRequest(streamId: streamId) { result in
            DispatchQueue.main.async {
                completion(.success)
            }
        } failure: { error in
            switch error{
            case .noResultsFound(_):
                // handle noresults found here
                break
            case .invalidResponse:
                completion(.failure(msg: "CoPublish Error : Invalid Response"))
            case.networkError(let error):
                completion(.failure(msg: "Network Error \(error.localizedDescription)"))
            case .httpError(let errorCode, let errorMessage):
                completion(.failure(msg: "\(errorCode) \(errorMessage?.error ?? "")"))
            default :
                break
            }
        }

        
    }
    
    func getCopublisherStatus(completion: @escaping(PublisherRequest) -> Void){
        let streamId = streamData.streamId.unwrap
        isometrik.getIsometrik().fetchCopublishRequestStatus(streamId: streamId) { response in
            DispatchQueue.main.async {
                self.publisherStatus = response
                completion(.success)
            }
        } failure: { error in
            switch error{
            case .noResultsFound(_):
                completion(.failure(msg: ""))
                break
            case .invalidResponse:
                completion(.failure(msg: "CoPublish Error : Invalid Response"))
            case.networkError(let error):
                completion(.failure(msg: "Network Error \(error.localizedDescription)"))
            case .httpError(let errorCode, let errorMessage):
                completion(.failure(msg: "\(errorCode) \(errorMessage?.error ?? "")"))
            default :
                break
            }
        }
    }
    
    func deleteCopublishingRequest(completion: @escaping(PublisherRequest) -> Void){
        let streamId = streamData.streamId.unwrap
        isometrik.getIsometrik().deleteCopublishRequest(streamId: streamId) { response in
            DispatchQueue.main.async {
                completion(.success)
            }
        } failure: { error in
            switch error{
            case .noResultsFound(_):
                // handle noresults found here
                break
            case .invalidResponse:
                completion(.failure(msg: "CoPublish Error : Invalid Response"))
            case.networkError(let error):
                completion(.failure(msg: "Network Error \(error.localizedDescription)"))
            case .httpError(let errorCode, let errorMessage):
                completion(.failure(msg: "\(errorCode) \(errorMessage?.error ?? "")"))
            default :
                break
            }
        }

    }

    func addRequest(requestData: ISMRequest, completion: @escaping(Bool) -> Void){
        
        let userId = requestData.userId.unwrap
        
        userRequestAlreadyExists(with: userId) { [weak self] isExist in
            guard let self = self else { return }
            if !isExist {
                if self.requestList.count == 0 {
                    self.requestList = [requestData]
                } else {
                    self.requestList.append(requestData)
                }
                completion(true)
            }
        }
        
    }
    
    func removeRequest(requestData: ISMRequest, completion: @escaping(Bool) -> Void){
        
        for i in 0..<requestList.count {
            let userId = requestList[i].userId
            if userId == requestData.userId {
                requestList.remove(at: i)
                completion(true)
                break
            }
        }
        
    }
    
    func updateRequestStatus(requestData: ISMRequest, completion: @escaping(Bool) -> Void){
        
        for i in 0..<requestList.count {
            let user = requestList[i]
            if requestData.userId == user.userId {
                requestList[i] = requestData
                completion(true)
                break
            }
        }
        
    }
    
    func userRequestAlreadyExists(with userId: String, completion: @escaping(_ exist: Bool) -> Void) {
        
        let isExist = requestList.filter { user -> Bool in
            return user.userId == userId
        }
        
        if isExist.count > 0 {
            completion(true)
        } else {
            completion(false)
        }
        
    }
    
}
