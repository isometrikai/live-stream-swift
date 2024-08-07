//
//  ViewerBody.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 11/11/22.
//

import Foundation

public struct ViewerBody: Codable, Hashable {
    
    private let streamId : String
    private let viewerId: String?
    private let initiatorId: String?
    private let userId: String?
    private let isPublic: Bool?
    private let removeLocally: Bool?
    
    public init(streamId: String, viewerId: String? = nil ,initiatorId:String? = nil ,userId : String? = nil, isPublic: Bool? = nil, removeLocally: Bool? = nil) {
        self.userId = userId
        self.isPublic = isPublic
        self.streamId = streamId
        self.viewerId = viewerId
        self.initiatorId = initiatorId
        self.removeLocally = removeLocally
    }
    
}
