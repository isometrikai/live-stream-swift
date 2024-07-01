//
//  ISMTokenModel.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 25/10/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ISMTokenModel: Codable {
    let message: String
    let data: ISMTokenData
}

// MARK: - DataClass
struct ISMTokenData: Codable {
    let userToken, userID, msg: String

    enum CodingKeys: String, CodingKey {
        case userToken
        case userID = "userId"
        case msg
    }
}
