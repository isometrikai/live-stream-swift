//
//  ISMTokenModel.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 25/10/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import Foundation

// MARK: - Welcome
public struct ISMTokenModel: Codable {
    public let message: String
    public let data: ISMTokenData
}

// MARK: - DataClass
public struct ISMTokenData: Codable {
    public let userToken, userID, msg: String

    public enum CodingKeys: String, CodingKey {
        case userToken
        case userID = "userId"
        case msg
    }
}
