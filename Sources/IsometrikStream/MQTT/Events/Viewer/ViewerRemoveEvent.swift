//
//  ViewerRemoveEvent.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 14/11/22.
//

import Foundation

public struct ViewerRemoveEvent: Codable, Hashable {
    
    public let action: String?
    public let streamId: String?
    public let timestamp: Int64?
    public let viewerId: String?
    public let viewerName: String?
    public let initiatorId: String?
    public let initiatorName: String?
    public let membersCount: Int?
    public let viewersCount: Int?
    
}
