//
//  PKChangeStreamEvent.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 08/12/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import Foundation

public struct PKChangeStreamEvent: Codable {
    
    public let streamId: String?
    public let viewerId: String?
    public let intentToStop: Bool?
    public let streamData: ISM_PK_Stream?
    public let userId: String?
    public let action: String?
    
}
