//
//  SubscriptionRouter.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 12/11/22.
//

import Foundation

enum SubscriptionRouter: ISMLiveURLConvertible, CustomStringConvertible {
    
    case addSubscription(streamStartChannel: Bool)
    case removeSubscription(streamStartChannel: Bool?)
    
    var description: String {
        switch self {
        case .addSubscription:
            return "Add subscription call."
        case .removeSubscription:
            return "Remove subscription call."
        }
    }
    
    var baseURL: URL{
        return URL(string:"\(ISMConfiguration.shared.primaryOrigin)")!
    }
    
    var method: ISMLiveHTTPMethod {
        switch self {
        case .addSubscription :
            return .put
        case .removeSubscription:
            return .delete
        }
    }
    
    var path: String {
        let path: String
        switch self {
        case .addSubscription:
            path = "/gs/v2/subscription/"
        case .removeSubscription:
            path = "/gs/v2/subscription/"
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
        case let .removeSubscription(streamStartChannel):
            if let streamStartChannel {
                param = ["streamStartChannel": "\(streamStartChannel)"]
            }
            break
        default:
            break
            
        }
        
        return param
    }
    
}

public typealias SubscriptionPayloadResponse = ((Result<Any?, IsometrikError>) -> Void)



