//
//  ModeratorEvent.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 16/02/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import Foundation

public struct ModeratorEvent: Codable, Hashable {
    
    public let action: String?
    public let timestamp: Double?
    public let streamId: String?
    public let moderatorsCount: Int?
    public let moderatorName: String?
    public let moderatorProfilePic: String?
    public let moderatorId: String?
    public let initiatorName: String?
    public let initiatorId: String?
    public let moderatorIdentifier: String?
    
}
