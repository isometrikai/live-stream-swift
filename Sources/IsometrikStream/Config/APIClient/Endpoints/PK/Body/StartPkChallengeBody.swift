//
//  StartPkChallengeBody.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 04/12/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import Foundation

public struct StartPkChallengeBody: Codable, Hashable {
    
    private let battleTimeInMin: Int?
    private let inviteId: String?
    
    public init(battleTimeInMin: Int, inviteId: String) {
        self.inviteId = inviteId
        self.battleTimeInMin = battleTimeInMin
    }
    
}
