//
//  PKRouter.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 30/11/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import Foundation

public enum PKInvitationResponse: String {
    case accept = "Accepted"
    case reject = "Rejected"
}

enum PKRouter: ISMLiveURLConvertible, CustomStringConvertible {
    
    case inviteUser
    case inviteUserList(query: String, skip: Int = 0, limit: Int = 10)
    case updateInvitationStatus
    case startPkChallenge
    case getPkStreamStats(streamId: String)
    case sendCoinInPk
    case getPKWinners(pkId: String)
    case stopPK
    case endPK
    
    var description: String {
        switch self {
        case .inviteUser:
            return "it sends invitation to the user to be invite."
        case .inviteUserList:
            return "it fetches the list of users that can be invite for pk."
        case .updateInvitationStatus:
            return "it updates the invitation responses from user."
        case .startPkChallenge:
            return "it starts PK challenge for given time."
        case .getPkStreamStats:
            return "it gets the PK stream stats."
        case .sendCoinInPk:
            return "it sends coin data to the stream while PK Battle."
        case .getPKWinners:
            return "it gets the winners of a PK battle"
        case .stopPK:
            return "it stops PK battle, option for forcefully too."
        case .endPK:
            return "it ends PK battle and stream too"
        }
    }
    
    var baseURL: URL{
        return URL(string:"\(ISMConfiguration.shared.primaryOrigin)")!
    }
    
    var method: ISMLiveHTTPMethod {
        switch self {
        case .inviteUser, .updateInvitationStatus, .startPkChallenge, .sendCoinInPk, .stopPK , .endPK:
            return .post
        case .inviteUserList, .getPkStreamStats, .getPKWinners:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .inviteUser, .inviteUserList :
            return "/live/v1/invite/users"
        case .updateInvitationStatus:
            return "/live/v1/invites"
        case .startPkChallenge:
            return "/live/v1/pk/start"
        case .getPkStreamStats:
            return "/live/v1/pk/stream/stats"
        case .sendCoinInPk:
            return "/live/v1/pk/sendcoins"
        case  .getPKWinners:
            return "/live/v1/pk/winner"
        case .stopPK:
            return "/live/v1/pk/stop"
        case .endPK:
            return "/live/v1/pk/end"
        }
    }
    
    // We are sending default headers for api, add additonal headers here
    var headers: [String : String]?{
        return nil
    }
    
    var queryParams: [String : String]? {
        switch self {
        case  let .inviteUserList(query, skip, limit) :
            return ["limit" : "\(limit)",
                    "skip" : "\(skip)",
                    "q" : query
              ]

        case  let .getPkStreamStats(streamId) :
            return ["streamId" : "\(streamId)"]
            
        case let .getPKWinners(pkId):
            return ["pkId" : "\(pkId)"]
        default:
            return [:]
        }
    }
    
}

public typealias PKBattlePayloadResponse = ((Result<Any?, IsometrikError>) -> Void)
