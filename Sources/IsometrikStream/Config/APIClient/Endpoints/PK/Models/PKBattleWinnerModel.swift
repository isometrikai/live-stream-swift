//
//  PKBattleWinnerModel.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 15/12/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import Foundation

public struct ISM_PK_WinnerData: Codable {
    
    public private(set) var data: ISM_PK_WinnerModel?
    public private(set) var message: String?
    
    enum CodingKeys: String, CodingKey {
        case data
        case message
    }
    
}

public struct ISM_PK_WinnerModel: Codable {
    
    public private(set) var winnerId: String?
    public private(set) var percentageOfCoinsFirstUser: Double?
    public private(set) var percentageOfCoinsSecondUser: Double?
    public private(set) var totalCoinsFirstUser: Double?
    public private(set) var totalCoinsSecondUser: Double?
    public private(set) var status: String?
    public private(set) var winnerStreamUserId: String?
    
    enum CodingKeys: String, CodingKey {
        case winnerId
        case percentageOfCoinsFirstUser
        case percentageOfCoinsSecondUser
        case totalCoinsFirstUser
        case totalCoinsSecondUser
        case status
        case winnerStreamUserId
    }
    
}
