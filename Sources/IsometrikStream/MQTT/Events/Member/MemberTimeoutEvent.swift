//
//  MemberTimeoutEvent.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 14/11/22.
//

import Foundation

public struct MemberTimeoutEvent: Codable, Hashable {
    
    public let action: String?
    public let streamId: String?
    public let timestamp: Int64?
    public let memberId: String?
    public let memberName: String?
    public let membersCount: Int?
    public let viewersCount: Int?
    
}

