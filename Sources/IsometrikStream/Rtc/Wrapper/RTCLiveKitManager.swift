//
//  RTCLiveKitManager.swift
//  LiveStream
//
//  Created by Dheeraj Kumar Sharma on 30/06/23.
//

import UIKit
import LiveKit

protocol RTCLiveKitManagerDelegate {
    func videoSessionDidUpdate(session: [VideoSession])
    func didUpdateVideoTrack(track: VideoTrack?, uid: UInt)
}

public class RTCLiveKitManager: NSObject {
    
    // MARK: - PROPERTIES
    
    var delegate: RTCLiveKitManagerDelegate?
    var configuration: ISMConfiguration?
    lazy var room = Room(
        delegate: self,
        roomOptions: RoomOptions(
            defaultAudioCaptureOptions: AudioCaptureOptions(
                echoCancellation: true
            )
        )
    )
    
    var settings = Settings()
    var captureOption: CameraCaptureOptions?
    public var updateLiveKitCameraStatus = false
    
    public var videoSessions: [VideoSession] = [] {
        didSet {
            self.delegate?.videoSessionDidUpdate(session: videoSessions)
        }
    }
    
    public var isCameraMute: Bool = false {
        didSet {
            DispatchQueue.main.async {
                LogManager.shared.logLiveKit("is camera enabled : \(!self.isCameraMute)", type: .debug)
                Task {
                    try await self.room.localParticipant.setCamera(enabled:!self.isCameraMute)
                }
            }
        }
    }
    

    var isMicrophoneMute: Bool = true {
        didSet {
            DispatchQueue.main.async {
                LogManager.shared.logLiveKit("is mic enabled : \(!self.isMicrophoneMute)", type: .debug)
                Task {
                    try await self.room.localParticipant.setMicrophone(enabled: !self.isMicrophoneMute)
                }
            }
        }
    }
    
    var isRearCamera: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.switchCamera()
            }
        }
    }
    
    // MARK: - MAIN
    
    init(configuration: ISMConfiguration) {
        super.init()
        self.configuration = configuration
    }
    
    // MARK: - FUNCTIONS
    
    func connectToRoom(withUid uid: UInt, hdBroadcast: Bool, isRestream: Bool, isRecorded: Bool) {
        Task {
            
            await room.disconnect()
            
            guard let configuration = configuration else { return }
            
            let url = configuration.liveKitUrl
            let rtcToken = configuration.rtcToken
            
            LogManager.shared.logLiveKit("serverUrl : \(url) \n rtcToken : \(rtcToken)", type: .debug)
            
            // Setting video presets based on the hdBroadcast param
            
            var videoParameters: [VideoParameters] = []
            
            if hdBroadcast {
                videoParameters = [
                    VideoParameters.presetH1080_43
                ]
            } else {
                videoParameters = [
                    VideoParameters.presetH720_43
                ]
            }
            
            //:
            
            var dimensions: Dimensions = .h720_169
            var videoEncoding: VideoEncoding?
            
            if hdBroadcast && (isRestream || isRecorded) {
                dimensions = Dimensions(width: 720, height: 1280)
                videoEncoding = VideoEncoding(maxBitrate: 4_000_000, maxFps: 30)
            } else if (isRestream || isRecorded) {
                dimensions = Dimensions(width: 480, height: 640)
                videoEncoding = VideoEncoding(maxBitrate: 2_500_000, maxFps: 30)
            } else {
                dimensions = .h720_169
                videoEncoding = VideoEncoding(maxBitrate: 1_500_000, maxFps: 30)
            }
            
            let roomOptions = RoomOptions(
                defaultCameraCaptureOptions: CameraCaptureOptions(
                    position: .front,
                    dimensions: dimensions,
                    fps: 30
                ),
                defaultVideoPublishOptions: VideoPublishOptions(
                  encoding: videoEncoding,
                  simulcastLayers: videoParameters
                ),
                dynacast: true
            )
            
            try await room.connect(url:url,token:rtcToken, roomOptions: roomOptions)
            
            if self.settings.role == .Broadcaster {
                
                self.isCameraMute = false
                self.isMicrophoneMute = false
                
            }
            
        }
    }
    
    func disconnectFromRoom(){
        Task {
            await room.disconnect()
        }
    }
    
    func switchCamera(){
        
        guard let trackPublication = room.localParticipant.localVideoTracks.first,
                  let videoTrack = trackPublication.track as? LocalVideoTrack,
                  let cameraCapturer = videoTrack.capturer as? CameraCapturer else { return }

        Task {
            try await cameraCapturer.switchCameraPosition()
        }
        
    }
    
    open func muteRemoteAudioTrack(participantId: UInt, mute: Bool) {
        let videoSession = videoSessions.filter { session in
            session.uid == participantId
        }
        
        Task {
            if videoSession.count > 0 {
                if mute {
                    try await videoSession.first?.liveKitAudioTrack?.stop()
                } else {
                    try await videoSession.first?.liveKitAudioTrack?.start()
                }
            }
        }
        
    }
    
    open func muteRemoteVideoTrack(participantId: UInt, mute: Bool) {
        
        let videoSession = videoSessions.filter { session in
            session.uid == participantId
        }
        
        Task {
            if videoSession.count > 0 {
                if mute {
                    try await videoSession.first?.liveKitVideoView?.track?.stop()
                } else {
                    try await videoSession.first?.liveKitVideoView?.track?.start()
                }
            }
        }
        
    }
    
    func getSession(of uid: UInt) -> VideoSession? {
        for session in videoSessions {
            if session.uid == uid {
                return session
            }
        }
        return nil
    }
    
    public func videoSession(of uid: UInt, _ type: SessionType = .local) -> VideoSession {
        if let fetchedSession = getSession(of: uid) {
            return fetchedSession
        } else {
            let newSession = VideoSession(uid: uid, type: type, sessionFrom: .liveKit)
            videoSessions.append(newSession)
            
            LogManager.shared.logLiveKit("videoSession created : (uid: \(newSession.uid) , type : \(newSession.type))", type: .debug)
            
            return newSession
        }
    }

    
}

extension RTCLiveKitManager: RoomDelegate {
    
    public func room(_ room: Room, didUpdateConnectionState connectionState: ConnectionState, from oldConnectionState: ConnectionState) {
        
        LogManager.shared.logLiveKit("state : \(connectionState.description)", type: .debug)
        
        switch connectionState {
        case .connected:
            if oldConnectionState == .reconnecting, !self.isCameraMute {
                self.updateLiveKitCameraStatus = true
            }
            break
        case .disconnected:
            break
        case .connecting:
            break
        case .reconnecting:
            break
        }
        
    }

    
    public func room(_ room: Room, participant: LocalParticipant, didPublishTrack publication: LocalTrackPublication) {
        
        let participantId = participant.identity?.stringValue.ism_userIdUInt() ?? 0
        
        if let videoTrack = publication.track as? LocalVideoTrack {
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                // create video session for local participant if not created
                let session = self.videoSession(of: participantId)
                session.liveKitVideoView?.track = videoTrack
                
                // Update the track
                self.delegate?.didUpdateVideoTrack(track: videoTrack, uid: participantId)
                
            }
            
        }
        
    }
    
    public func room(_ room: Room, participant: RemoteParticipant, didSubscribeTrack publication: RemoteTrackPublication) {
        
        let participantId = participant.identity?.stringValue.ism_userIdUInt() ?? 0
        
        if let videoTrack = publication.track as? RemoteVideoTrack {
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                // create video session for remote participant if not created
                let session = self.videoSession(of: participantId, .remote)
                session.liveKitVideoView?.track = videoTrack
                
                // Update the track
                self.delegate?.didUpdateVideoTrack(track: videoTrack, uid: participantId)
                
            }
            
        }
        
        if let audioTrack = publication.track as? RemoteAudioTrack {
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                // create video session for remote participant if not created
                let session = self.videoSession(of: participantId, .remote)
                session.liveKitAudioTrack = audioTrack
                
            }
            
        }
        
    }
    
    public func room(_ room: Room, participant: Participant, trackPublication: TrackPublication, didUpdateIsMuted isMuted: Bool) {
        
        
        let userInfo: [String: Any] = ["trackKind": trackPublication.kind, "participant": participant , "isMuted" : isMuted]
                
        NotificationCenter.default.post(name: .didPublishTrackNotification, object: nil, userInfo: userInfo)

    }
    
}
