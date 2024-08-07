//
//  PKBattleLocalWinnerModel.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 21/12/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import Foundation

public struct ISM_PK_LocalGiftModel {
    
    public var streamer1: ISM_PK_User?
    public var streamer2: ISM_PK_User?
    
    public init(streamer1: ISM_PK_User, streamer2: ISM_PK_User){
        self.streamer1 = streamer1
        self.streamer2 = streamer2
    }
    
}
