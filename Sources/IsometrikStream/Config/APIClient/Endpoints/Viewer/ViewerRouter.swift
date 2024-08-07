//
//  ViewerRouter.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 11/11/22.
//

import UIKit

enum ViewerRouter: ISMLiveURLConvertible, CustomStringConvertible {
    
    case addViewer(streamId: String)
    case fetchViewersCount(streamId: String)
    case leaveViewer(streamId: String)
    case removeViewer(streamId: String, viewerId: String)
    case fetchViewers(streamId: String, skip: Int = 0, limit: Int = 10, searchTag: String?)
    case fetchViewersForAnalytics(streamId: String, skip: Int = 0, limit: Int = 10)
    
    var description: String {
        switch self {
        case .addViewer:
            return "Join stream group as viewer call."
        case .fetchViewersCount:
            return "Fetch viewers count in a stream group call."
        case .leaveViewer:
            return "Leave as viewer from a stream group call."
        case .removeViewer:
            return "Remove a viewer from a stream group call."
        case .fetchViewers:
            return "Fetch viewers in a stream group call."
        case .fetchViewersForAnalytics:
            return "Fetch viewers for analytics page, after stream ended."
            
        }
    }
    
    var baseURL: URL{
        switch self {
        case .fetchViewersForAnalytics:
            return URL(string:"https://service-\(ISMConfiguration.shared.primaryOrigin)")!
        default:
            return URL(string:"https://\(ISMConfiguration.shared.primaryOrigin)")!
        }
    }
    
    var method: ISMLiveHTTPMethod {
        switch self {
        case .addViewer :
            return .post
        case .removeViewer, .leaveViewer :
            return .delete
        default:
            return .get
        }
    }
    
    var path: String {
        let path: String
        switch self {
        case .addViewer :
            path = "/streaming/v2/viewer"
        case .fetchViewersCount :
            path = "/streaming/v2/viewers/count"
        case .leaveViewer:
            path = "/streaming/v2/viewer/leave"
        case .removeViewer:
            path = "/streaming/v2/viewer"
        case .fetchViewers:
            path = "/streaming/v2/viewers"
        case .fetchViewersForAnalytics:
            path = "/live/v2/stream/viewer"
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
        case let .fetchViewersCount(streamId):
            param = ["streamId": "\(streamId)"]
            break
        case let .leaveViewer(streamId):
            param = ["streamId": "\(streamId)"]
            break
        case let .removeViewer(streamId, viewerId):
            param = ["streamId": "\(streamId)","viewerId": "\(viewerId)"]
            break
        case let .fetchViewers(streamId, skip, limit, searchTag):
            
            param = [
                "streamId": "\(streamId)",
                "skip": "\(skip)",
                "limit": "\(limit)"
            ]
            
            if let searchTag {
                param = [
                    "searchTag": "\(searchTag)"
                ]
            }
            
            break
        case let .fetchViewersForAnalytics(streamId, skip, limit):
            
            param = [
                "streamId": "\(streamId)",
                "skip": "\(skip)",
                "limit": "\(limit)"
            ]
            
            break
        default: break
            
        }
        
        return param
    }
    
}

public typealias ViewerPayloadResponse = ((Result<Any?, IsometrikError>) -> Void)

