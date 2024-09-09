//
//  CopublishRouter.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 10/11/22.
//

import Foundation

enum CopublishRouter: ISMLiveURLConvertible, CustomStringConvertible {
    
    case addCopublishRequest
    case acceptCopublishRequest
    case denyCopublishRequest
    case deleteCopublishRequest(streamId: String)
    case switchProfile
    case fetchCopublishRequestStatus(streamId: String)
    case fetchCopublishRequests(streamId: String)
    case updatePublishStatus
    
    var description: String {
        switch self {
        case .addCopublishRequest:
            return "Request user to become copulisher in a stream."
        case .acceptCopublishRequest:
            return "Accept Request to become copublisher in a stream."
        case .denyCopublishRequest:
            return "Deny Request to become copublisher in a stream."
        case .deleteCopublishRequest:
            return "Delete copublish request call."
        case .switchProfile:
            return "Switch profile from viewer to member."
        case .fetchCopublishRequestStatus:
            return "Fetch user copublish request status"
        case .fetchCopublishRequests:
            return "Fetch Requests that are pending, accepted or declined in a stream."
        case .updatePublishStatus:
            return "Updates the publish status in a stream for a project in an account."
        }
    }
    
    var baseURL: URL{
        return URL(string:"\(ISMConfiguration.shared.primaryOrigin)")!
    }
    
    var method: ISMLiveHTTPMethod {
        switch self {
        case .addCopublishRequest, .denyCopublishRequest, .acceptCopublishRequest, .switchProfile :
            return .post
        case .fetchCopublishRequestStatus, .fetchCopublishRequests:
            return .get
        case .deleteCopublishRequest:
            return .delete
        case .updatePublishStatus:
            return .put
        }
    }
    
    var path: String {
        let path: String
        switch self {
        case .addCopublishRequest:
            path = "/streaming/v2/copublish/request"
        case .acceptCopublishRequest:
            path = "/streaming/v2/copublish/accept"
        case .denyCopublishRequest:
            path = "/streaming/v2/copublish/deny"
        case .deleteCopublishRequest:
            path = "/streaming/v2/copublish/request"
        case .switchProfile:
            path = "/streaming/v2/switchprofile"
        case .fetchCopublishRequestStatus:
            path = "/streaming/v2/copublish/status"
        case .fetchCopublishRequests:
            path = "/streaming/v2/copublish/requests"
        case .updatePublishStatus:
            path = "/streaming/v2/publish"
        }
        return path
    }
    
    // We are sending default headers for api, add additonal headers here
    var headers: [String : String]?{
        return nil
    }
    
    var queryParams: [String : String]? {
        var param: [String: String] = [:]
        
        switch self {
        case let .deleteCopublishRequest(streamId):
            param = [
                "streamId": "\(streamId)"
            ]
        case let .fetchCopublishRequestStatus(streamId):
            param = [
                "streamId": "\(streamId)"
            ]
            break
        case let .fetchCopublishRequests(streamId):
            param = [
                "streamId": "\(streamId)"
            ]
            break
        default:
            break
            
        }
        
        return param
    }
    
}

public typealias CopublishPayloadResponse = ((Result<Any?, IsometrikError>) -> Void)
