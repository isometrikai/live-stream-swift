//
//  GiftRouter.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 19/06/24.
//

import Foundation

enum GiftRouter: ISMLiveURLConvertible, CustomStringConvertible {
    
    case getGiftCategories(skip: Int, limit: Int)
    case getGiftForACategory(giftGroupId: String, skip: Int, limit: Int)
    case sendGiftToStreamer
    
    var description: String {
        switch self {
        case .getGiftCategories:
            return "Get gift groups or categories."
        case .getGiftForACategory:
            return "Get gift for a gift groups or categories."
        case .sendGiftToStreamer:
            return "Send gift to a streamer"
        }
    }
    
    var baseURL: URL {
        return URL(string: "https://admin-\(ISMConfiguration.shared.primaryOrigin)")!
    }
    
    var method: ISMLiveHTTPMethod {
        switch self {
        case .getGiftCategories, .getGiftForACategory:
            return .get
        case .sendGiftToStreamer:
            return .post
        }
    }
    
    var path: String {
        let path: String
        switch self {
        case .getGiftCategories:
            path = "/v1/app/giftGroup"
        case .getGiftForACategory:
            path = "/v1/app/virtualGifts"
        case .sendGiftToStreamer:
            path = "/live/v4/giftTransfer"
        }
        return path
    }
    
    var headers: [String : String]?{
        return nil
    }
    
    var queryParams: [String : String]? {
        var param: [String: String] = [:]
        
        switch self {
        case let .getGiftCategories(skip, limit):
            param = [
                "skip": "\(skip)",
                "limit": "\(limit)"
            ]
        case let .getGiftForACategory(giftGroupId, skip, limit):
            param = [
                "giftGroupId": "\(giftGroupId)",
                "skip": "\(skip)",
                "limit": "\(limit)"
            ]
        default:
            break
        }
        
        return param
    }
    
}
