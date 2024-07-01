//
//  UpdateInvitationResponseBody.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 02/12/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import Foundation

public struct UpdateInvitationResponseBody: Codable, Hashable {
    
    private let inviteId: String?
    private let streamId: String?
    private let response: String?
    
    public init(inviteId: String? = nil, streamId: String? = nil, response: String? = nil) {
        self.inviteId = inviteId
        self.streamId = streamId
        self.response = response
    }
    
}
