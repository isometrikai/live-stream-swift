//
//  InviteUserListModel.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 30/11/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import Foundation


public struct ISM_PK_InviteUserData: Codable {
    
    public private(set) var streams: [ISM_PK_InviteStream]?
    public private(set) var message: String?
    public private(set) var totalCount: Int?
    public private(set) var pkId: String?

    enum CodingKeys: String, CodingKey {
        case streams = "streams"
        case message = "message"
        case totalCount = "totalCount"
        case pkId
    }
    
}

public struct ISM_PK_InviteStream: Codable {
    public var streamId: String?
    public var firstName : String?
    public var lastName: String?
    public var profilePic: String?
    public var streamPic: String?
    public var streamUserId: String?
    public var userId: String?
    public var userName: String?
    public var viewerCount: Int?
    public var userMetaData: ISM_PK_InviteUserMetaData?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "firstName"
        case lastName = "lastName"
        case profilePic = "profilePic"
        case streamId = "streamId"
        case streamPic = "streamPic"
        case streamUserId = "streamUserId"
        case userId = "userId"
        case userName = "userName"
        case viewerCount = "viewerCount"
        case userMetaData
    }
}

public struct ISM_PK_InviteUserMetaData: Codable {
    
    public var firstName : String?
    public var lastName: String?
    
}
