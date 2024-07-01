//
//  CopublishRequestAddEvent.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 14/11/22.
//

import Foundation

public struct CopublishRequestAddEvent: Codable {
    
    public let action: String?
    public let streamId: String?
    public let timestamp: Int64?
    public let membersCount: Int?
    public let viewersCount: Int?
    public let userId: String?
    public let userIdentifier: String?
    public let userProfilePic: String?
    public let userName: String?

    
}
