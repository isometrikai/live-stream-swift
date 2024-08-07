//
//  ModeratorBody.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 14/02/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import Foundation

public struct ModeratorBody: Codable, Hashable {
    
    private let streamId: String
    private let moderatorId: String
    
    public init(streamId: String, moderatorId: String) {
        self.streamId = streamId
        self.moderatorId = moderatorId
    }
    
}
