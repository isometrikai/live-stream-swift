//
//  ISMMember.swift
//  ISOMetrikSDK
//
//  Created by Rahul Sharma on 18/06/21.
//  Copyright © 2021 Appscrip. All rights reserved.
//

import Foundation

public struct ISMMembersData: Codable {
    public let msg: String?
    public let members: [ISMMember]?
    public let membersCount: Int?
}

public struct ISMEligibleMemberData: Codable {
    public let streamEligibleMembers: [ISMMember]?
}

// MARK: - Member
public struct ISMMember: Codable {
    
    public var userID, userName: String?
    public var userProfileImageURL: String?
    //let rtmpIngestURL: String?
    public var userIdentifier: String?
    public var metaData: ISMMetaData?
    public var joinTime: Int64?
    public var isPublishing, isAdmin: Bool?
    //let ingressID: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case userName
        case userProfileImageURL = "userProfileImageUrl"
        //case rtmpIngestURL = "rtmpIngestUrl"
        case userIdentifier, metaData, joinTime, isPublishing, isAdmin
        //case ingressID = "ingressId"
    }
    
    public init(
        userID: String?,
        userName: String? = nil,
        userProfileImageURL: String? = nil,
        userIdentifier: String? = nil,
        metaData: ISMMetaData? = nil,
        joinTime: Int64? = nil,
        isPublishing: Bool? = nil,
        isAdmin: Bool? = nil
    ){
        self.userID = userID
        self.userName = userName
        self.userProfileImageURL = userProfileImageURL
        self.userIdentifier = userIdentifier
        self.metaData = metaData
        self.joinTime = joinTime
        self.isPublishing = isPublishing
        self.isAdmin = isAdmin
    }
    
}

// MARK: - MetaData
public struct ISMMetaData: Codable, Hashable {
    public let lastName, firstName, userID, userName, profilePic: String?

    enum CodingKeys: String, CodingKey {
        case lastName, firstName, userName
        case userID = "userId"
        case profilePic
    }
    
}
