//
//  StopPKBody.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 13/02/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import Foundation

public struct StopPKBody: Codable, Hashable {
    
    private let action: String
    private let pkId: String
    
    public init(action: String, pkId: String) {
        self.action = action
        self.pkId = pkId
    }
    
}
