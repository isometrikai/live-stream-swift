//
//  Settings.swift
//  OpenVideoCall
//
//  Created by CavanSu on 2019/5/14.
//  Copyright © 2019 Agora. All rights reserved.
//

import Foundation

public enum ISMClientRole : Int{
    case Broadcaster = 1
    case Audience = 2
}

struct Settings {
    var roomName: String?
    var userId: UInt = 0
    var role : ISMClientRole = .Broadcaster
    var dimension = CGSize.zero
    var frameRate = "15 fps"
}
