//
//  RtcWrapper.swift
//  AppTesting
//
// Created by Appscrip on 30/08/20.
//

import Foundation
import LiveKit


public enum RTCUsing {
    case livekit
}

/// Implements Agora rtc wrapper protocol methods to expose them to the client app
public protocol RtcWrapperProtocol: AnyObject {
    func videoSessionsDidSet()
    func didUserJoinedAsCohost(withId Id: String)
    func didUserGoesOffline(user: ISMMember)
    func didUpdateVideoTrack(track: VideoTrack?, uid: UInt)
}

extension RtcWrapperProtocol {
    func didUpdateVideoTrack(track: VideoTrack?, uid: UInt){}
    func didUserJoinedAsCohost(withId Id: String){}
    func didUserGoesOffline(user: ISMMember){}
}

/// `RtcWrapper`.
public class RtcWrapper: NSObject {
    
    private var liveKitManager: RTCLiveKitManager?
    
    public weak var rtcWrapperDelegate: RtcWrapperProtocol?
    
    public var configuration : ISMConfiguration? {
        didSet {
            liveKitManager?.configuration = configuration
        }
    }
    
    var setting = Settings()
    
    public var rtcUsing: RTCUsing = .livekit {
        didSet {
            guard let configuration = configuration else { return }
            self.liveKitManager = RTCLiveKitManager(configuration: configuration)
            self.liveKitManager?.delegate = self
            self.videoSessions = liveKitManager?.videoSessions ?? []
        }
    }
    
    public var videoSessions: [VideoSession] = [] {
        didSet {
            self.rtcWrapperDelegate?.videoSessionsDidSet()
        }
    }
    
    init(config : ISMConfiguration, isLoad: Bool, rtcUsing: RTCUsing = .livekit) {
        super.init()
        self.configuration = config
        self.rtcUsing = rtcUsing
    }
    
    public func getLiveKitManager() -> RTCLiveKitManager? {
        if self.liveKitManager != nil {
            return self.liveKitManager
        }
        return nil
    }
    
    func videoSession(of uid: UInt, _ type: SessionType = .local) -> VideoSession? {
        let rtcUsing = self.rtcUsing
        switch rtcUsing {
        case .livekit:
            return getLiveKitManager()?.videoSession(of: uid, type)
        }
    }
    
}

extension RtcWrapper: RTCLiveKitManagerDelegate {
    
    func didUpdateVideoTrack(track: VideoTrack?, uid: UInt) {
        self.rtcWrapperDelegate?.didUpdateVideoTrack(track: track, uid: uid)
    }
    
    func videoSessionDidUpdate(session: [VideoSession]) {
        self.videoSessions = session
    }
    
}
