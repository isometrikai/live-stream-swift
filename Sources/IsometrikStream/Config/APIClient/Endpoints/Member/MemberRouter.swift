//
//  MemberRouter.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 11/11/22.
//

import UIKit

enum MemberRouter: ISMLiveURLConvertible, CustomStringConvertible {
    
    case addMember
    case fetchEligibleMembers(streamId: String, searchTag: String?, skip: Int, limit: Int)
    case fetchMembers(streamId: String, searchTag: String?, skip: Int, limit: Int)
    case leaveMember(streamId: String)
    case removeMember(streamId: String, memberId: String)
    case fetchMemberWithUid(streamId: String, userId: String)
    case updatePublishStatus
    case updateUserPublishStatus
    
    var description: String {
        switch self {
        case .addMember:
            return "Add member to a stream"
        case .fetchEligibleMembers:
            return "Fetch eligible members to add to a stream in a project in an account."
        case .fetchMembers:
            return "Fetch streaming memebers in a stream"
        case .leaveMember:
            return "Leave stream group by a member call."
        case .removeMember:
            return "Remove member from a stream group call."
        case .fetchMemberWithUid:
            return "Fetch member details by uid call."
        case .updatePublishStatus:
            return "Update publishing status in a stream for a project in an account."
        case .updateUserPublishStatus:
            return "Update publishing status of a user for a project in an account."
        }
    }
    
    var baseURL: URL{
        return URL(string:"\(ISMConfiguration.shared.primaryOrigin)")!
    }
    
    var method: ISMLiveHTTPMethod {
        switch self {
        case .addMember :
            return .post
        case .fetchMembers, .fetchMemberWithUid, .fetchEligibleMembers:
            return .get
        case .updateUserPublishStatus, .updatePublishStatus:
            return .put
        default:
            return .delete
        }
    }
    
    var path: String {
        let path: String
        switch self {
        case .addMember :
            path = "/streaming/v2/member"
        case .fetchEligibleMembers:
            path = "/streaming/v2/members/eligible"
        case .fetchMembers :
            path = "/streaming/v2/members"
        case .leaveMember:
            path = "/streaming/v2/member/leave"
        case .removeMember :
            path = "/streaming/v2/member"
        case .fetchMemberWithUid:
            path = "/streaming/v2/member"
            
        case .updatePublishStatus:
            path = "/streaming/v2/publish"
            
        case .updateUserPublishStatus:
            path = "/streaming/v2/publish/user"
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
        case let .fetchMembers(streamId, searchTag, skip, limit):
            param = [
                "limit":"\(limit)",
                "skip":"\(skip)",
                "streamId":"\(streamId)"
            ]
            
            if let searchTag {
                param += ["searchTag":"\(searchTag)"]
            }
            break
        case let .fetchEligibleMembers(streamId, searchTag, skip, limit):
            param = [
                "limit":"\(limit)",
                "skip":"\(skip)",
                "streamId":"\(streamId)"
            ]
            
            if let searchTag {
                param += ["searchTag":"\(searchTag)"]
            }
            break
        case let .leaveMember(streamId):
            param = [
                "streamId": "\(streamId)"
            ]
            break
        case let .removeMember(streamId, memberId):
            param = [
                "streamId": "\(streamId)",
                "memberId": "\(memberId)"
            ]
        case let .fetchMemberWithUid(streamId, userId):
            param = [
                "streamId": "\(streamId)",
                "uid": "\(userId)"
            ]
        default:
            break
            
        }
        
        return param
    }
    
}

public typealias MemberPayloadResponse = ((Result<Any?, IsometrikError>) -> Void)
