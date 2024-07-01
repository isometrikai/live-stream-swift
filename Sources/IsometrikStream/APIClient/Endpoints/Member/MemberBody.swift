//
//  MemberBody.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 11/11/22.
//

import Foundation

public struct MemberBody: Codable, Hashable {
    
    private let streamId : String?
    private let memberId: String?
    private let initiatorId: String?
    private let userId: String?
    private let isPublic: Bool?
    private let startPublish: Bool?
    
    public init(streamId: String? = nil, memberId: String? = nil ,initiatorId:String? = nil ,userId : String? = nil, isPublic: Bool? = nil, startPublish: Bool? = nil) {
        self.userId = userId
        self.isPublic = isPublic
        self.streamId = streamId
        self.memberId = memberId
        self.initiatorId = initiatorId
        self.startPublish = startPublish
    }
    
}
