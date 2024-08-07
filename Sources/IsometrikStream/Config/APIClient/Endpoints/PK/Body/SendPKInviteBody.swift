//
//  SendPKInviteBody.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 01/12/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import Foundation

public struct SendPKInviteBody: Codable, Hashable {
    
    private let reciverStreamId: String?
    private let senderStreamId: String?
    private let userId: String?
    
    public init(reciverStreamId: String? = nil, senderStreamId: String? = nil, userId: String? = nil) {
        self.reciverStreamId = reciverStreamId
        self.senderStreamId = senderStreamId
        self.userId = userId
    }
    
}
