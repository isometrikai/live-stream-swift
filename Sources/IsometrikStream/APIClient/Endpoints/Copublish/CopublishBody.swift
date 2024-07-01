//
//  CopublishBody.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 11/11/22.
//

import Foundation

public struct CopublishBody: Codable, Hashable {
    private let isPublic: Bool?
    private let streamId : String
    private let memberId: String?
    private let initiatorId: String?
    private let requestByUserId: String?
    private let userId: String?
    private let startPublish: Bool?
    
    public init(streamId: String, memberId: String? = nil ,initiatorId:String? = nil ,userId : String? = nil, isPublic: Bool? = nil, startPublish: Bool? = nil, requestByUserId: String? = nil) {
        self.userId = userId
        self.isPublic = isPublic
        self.streamId = streamId
        self.memberId = memberId
        self.initiatorId = initiatorId
        self.startPublish = startPublish
        self.requestByUserId = requestByUserId
    
    }
    
}

