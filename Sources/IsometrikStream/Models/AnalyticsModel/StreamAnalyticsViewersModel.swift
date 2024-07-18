//
//  StreamAnalyticViewersModel.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 08/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import Foundation

public struct StreamAnalyticViewersResponseModel: Codable {
    public let message: String?
    public let viewers: [StreamAnalyticViewers]?
    public let totalCount: Int?
}

public struct StreamAnalyticViewers: Codable {
    public let isometrikUserID, appUserID, firstName, lastName: String?
    public let timestamp: Int?
    public let profilePic: String?
    public let isFollowing: Bool?
    public let statusLogs: [StreamStatusLog]?
    public var followStatus: Int?
    public var userName: String?
    public var userMetaData: StreamAnalyticsUserMetaData?
    public let privacy: Int?

    enum CodingKeys: String, CodingKey {
        case isometrikUserID = "isometrikUserId"
        case appUserID = "appUserId"
        case firstName, lastName, timestamp, profilePic, isFollowing, statusLogs
        case followStatus, privacy = "private"
        case userMetaData
        case userName
    }
}

public struct StreamAnalyticsUserMetaData: Codable {
    public let firstName: String?
    public let lastName: String?
    public let profilePic: String?
}

public struct StreamStatusLog: Codable {
    let timestamp: Int?
    let status: String?
}
