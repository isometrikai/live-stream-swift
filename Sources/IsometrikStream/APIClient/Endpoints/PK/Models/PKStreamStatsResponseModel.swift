//
//  PKStreamStatsResponseModel.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 12/12/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import Foundation

public struct ISM_PK_StreamStatsData: Codable {
    
    public private(set) var message: String?
    public private(set) var data: ISM_PK_StreamStats?

    enum CodingKeys: String, CodingKey {
        case data
    }
}

public struct ISM_PK_StreamStats: Codable {
    
    public private(set) var pkId: String?
    public private(set) var streamId: String?
    public private(set) var firstUserId: String?
    public private(set) var secoundUserId: String?
    public private(set) var firstUserDetails: ISM_PK_User?
    public private(set) var secondUserDetails: ISM_PK_User?
    public private(set) var firstUserCoins: Int?
    public private(set) var secondUserCoins: Int?
    public private(set) var timeRemain: Int?
    public private(set) var creationTimestamp: Int64?

    enum CodingKeys: String, CodingKey {
        case pkId
        case streamId
        case firstUserId
        case secoundUserId
        case firstUserDetails
        case secondUserDetails
        case firstUserCoins
        case secondUserCoins
        case timeRemain
        case creationTimestamp
    }
    
}
