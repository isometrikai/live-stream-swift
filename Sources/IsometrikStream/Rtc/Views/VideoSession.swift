//
//  VideoSession.swift
//  OpenLive
//
//  Created by GongYuhua on 6/25/16.
//  Copyright © 2016 Agora. All rights reserved.
//

import UIKit
import LiveKit

public enum SessionFrom {
    case liveKit
}

public enum SessionType {
    case local, remote
    
    var isLocal: Bool {
        switch self {
        case .local:  return true
        case .remote: return false
        }
    }
}

public class VideoSession: NSObject {
    
    public var uid: UInt
    public var userData: ISMMember?
    
    public var hostingView: CustomVideoView!
    public var liveKitVideoView: VideoView?
    public var liveKitAudioTrack: AudioTrack?
    public var liveKitPublication: LocalTrackPublication?
    
    public var type: SessionType
    public var sessionFrom: SessionFrom
    public var isAudioMute: Bool = false
    public var isVideoMute: Bool = false
    
    public var winnersData: ISM_PK_WinnerModel?
    public var pkId: String = ""
    public var contributionStarted: Bool? = false
    
    public init(uid: UInt, type: SessionType = .remote , sessionFrom: SessionFrom = .liveKit) {
        self.uid = uid
        self.type = type
        self.sessionFrom = sessionFrom
        
        liveKitVideoView = VideoView()
        liveKitVideoView?.mirrorMode = .auto
        //liveKitVideoView?.isDebugMode = true
        
    }
}

extension VideoSession {
    
    static func localSession(uid: UInt) -> VideoSession {
        return VideoSession(uid: uid, type: .local)
    }
    
    static func remoteSession(with uid: UInt) -> VideoSession {
        return VideoSession(uid: uid, type: .remote)
    }
    
}
