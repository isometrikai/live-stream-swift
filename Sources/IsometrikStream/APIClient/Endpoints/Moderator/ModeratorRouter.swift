//
//  ModeratorRouter.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 14/02/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import Foundation

enum ModeratorRouter: ISMLiveURLConvertible, CustomStringConvertible {
    
    case fetchModerators(streamId: String, searchTags: String?)
    case stopModerating(streamId: String)
    case addModerator
    case removeModerator(streamId: String, moderatorId: String)
    
    var description: String {
        switch self {
        case .fetchModerators:
            return "It fetches moderator in existing stream."
        case .stopModerating:
            return "It allows moderator to stop moderating in a stream"
        case .addModerator:
            return "It adds any user as a moderator to a stream."
        case .removeModerator:
            return "It allows host to remove moderator from stream."
        }
    }
    
    var baseURL: URL{
        return URL(string:"https://\(ISMConfiguration.shared.primaryOrigin)")!
    }
    
    var method: ISMLiveHTTPMethod {
        switch self {
        case .addModerator:
            return .post
        case .stopModerating, .removeModerator:
            return .delete
        default:
            return .get
        }
    }
    
    var path: String {
        let path: String
        switch self {
        case .fetchModerators:
            path = "/streaming/v2/moderators"
        case .stopModerating:
            path = "/streaming/v2/moderator/leave"
        case .addModerator:
            path = "/streaming/v2/moderator"
        case .removeModerator:
            path = "/streaming/v2/moderator"
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
        case let .fetchModerators(streamId, searchTag):
            param = [
                "streamId": "\(streamId)",
                "limit": "20",
                "skip": "0"
            ]
            
            if let searchTag {
                param += [
                    "searchTag": "\(searchTag)"
                ]
            }
            break
        case let .stopModerating(streamId):
            
            param = [
                "streamId": "\(streamId)"
            ]
            break
        case let .removeModerator(streamId, moderatorId):
            
            param = [
                "streamId": "\(streamId)",
                "moderatorId": "\(moderatorId)"
            ]
            
            break
        default:
            break
            
        }
        
        return param
    }
    
}

public typealias ModeratorPayloadResponse = ((Result<Any?, IsometrikError>) -> Void)
