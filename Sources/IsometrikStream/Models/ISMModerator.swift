//
//  ISMModerator.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 14/02/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import Foundation

// MARK: - Welcome
public struct ISMModerator: Codable {
    public let msg: String?
    public let moderatorsCount: Int?
    public let moderators: [Moderator]?
}

// MARK: - Moderator
public struct Moderator: Codable {
    public let moderatorProfilePic: String?
    public let moderatorName, moderatorIdentifier, moderatorID: String?
    public let isAdmin: Bool?

    enum CodingKeys: String, CodingKey {
        case moderatorProfilePic = "userProfileImageUrl"
        case moderatorName = "userName"
        case moderatorIdentifier = "userIdentifier"
        case moderatorID = "userId"
        case isAdmin
    }
}

