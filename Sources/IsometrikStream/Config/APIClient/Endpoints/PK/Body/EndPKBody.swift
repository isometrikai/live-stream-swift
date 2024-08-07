//
//  EndPKBody.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 13/02/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import Foundation

public struct EndPKBody: Codable, Hashable {

    private let action: String
    private let InviteId: String
    private let intentToStop: Bool
    
    public init(action: String, InviteId: String, intentToStop: Bool) {
        self.action = action
        self.InviteId = InviteId
        self.intentToStop = intentToStop
    }
    
}

