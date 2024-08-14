//
//  UserRouter.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 10/11/22.
//

import Foundation

enum ISMLiveUserRouter: ISMLiveURLConvertible, CustomStringConvertible {
    
    case fetchUsers(skip: Int, searchTag: String?, limit: Int)
    case userDetails
    case createUser
    case updateUser
    case authenticateUser
    case deleteUser
    
    // Restream Channels
    case addRestreamingChannel
    case fetchRestreamChannels
    case updateRestreamChannel
    case deleteRestreamChannel(channelId: String)
    case updateAllRestreamChannelStatus
    
    var description: String {
        switch self {
        case .fetchUsers:
            return "User List"
        case .userDetails:
            return "User details"
        case .createUser:
            return "User Create"
        case .updateUser:
            return "User update"
        case .authenticateUser:
            return "Authenticate User"
        case .deleteUser:
            return "User Delete"
            
        case .addRestreamingChannel:
            return "Add Restreaming Channels for a user"
        case .fetchRestreamChannels:
            return "Fetch Restream Channels of a user"
        case .deleteRestreamChannel:
            return "Delete Restream Channel for a user"
        case .updateRestreamChannel:
            return "Update Restream Channel for a user"
        case .updateAllRestreamChannelStatus:
            return "Update Status of a Restream Channel for a user"
        }
    }
    
    var baseURL: URL{
        return URL(string:"\(ISMConfiguration.shared.primaryOrigin)")!
    }
    
    var method: ISMLiveHTTPMethod {
        switch self {
        case .createUser, .authenticateUser, .addRestreamingChannel:
            return .post
        case .updateUser , .updateRestreamChannel, .updateAllRestreamChannelStatus:
            return .patch
        case .deleteUser, .deleteRestreamChannel :
            return .delete
        default:
            return .get
        }
    }
    
    var path: String {
        let path: String
        switch self {
        case .fetchUsers , .createUser, .updateUser, .deleteUser:
            path = "/streaming/v2/users"
        case .userDetails:
            path = "/streaming/v2/user/details"
        case .authenticateUser:
            path = "/streaming/v2/user/authenticate"
        case .addRestreamingChannel , .fetchRestreamChannels, .updateRestreamChannel, .deleteRestreamChannel:
            path = "/streaming/v2/restream/channel"
        case .updateAllRestreamChannelStatus:
            path = "/streaming/v2/restream/channel/all"
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
        case let .fetchUsers(skip, searchTag, limit):
            param = [
                "count":"\(limit)",
                "skip":"\(skip)"
            ]
            
            if let searchTag {
                param += [
                    "searchTag":"\(searchTag)"
                ]
            }
            
        case let .deleteRestreamChannel(channelId):
            param = [
                "channelId":"\(channelId)"
            ]
            break
        default:
            break
            
        }
        
        return param
    }
    
}

public typealias UserPayloadResponse = ((Result<Any?, IsometrikError>) -> Void)
