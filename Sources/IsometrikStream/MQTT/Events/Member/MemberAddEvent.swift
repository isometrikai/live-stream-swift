//
//  MemberAddEvent.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 14/11/22.
//

import Foundation

public struct MemberAddEvent: Codable, Hashable {
    
    public let action: String?
    public let streamId: String?
    public let timestamp: Int64?
    public let memberId: String?
    public let memberIdenitifer: String?
    public let memberProfilePic: String?
    public let initiatorId: String?
    public let memberName: String?
    public let initiatorName: String?
    public let membersCount: Int?
    public let viewersCount: Int?
    
}
