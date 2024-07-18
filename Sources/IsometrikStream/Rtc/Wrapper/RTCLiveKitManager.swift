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
    var updateLiveKitCameraStatus = false
    
    public var videoSessions: [VideoSession] = [] {
        didSet {
            self.delegate?.videoSessionDidUpdate(session: videoSessions)
        }
    }
    
    var isCameraMute: Bool = false {
        didSet {
            Task {
                try await self.room.localParticipant.setCamera(enabled:!self.isCameraMute)
            }
        }
    }
    

    var isMicrophoneMute: Bool = true {
        didSet {
            DispatchQueue.main.async {
                print("LIVEKIT :: IS MICROPHONE ENABLE \(!self.isMicrophoneMute)")
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
            
            print("LIVEKIT :: URL => \(url)")
            print("LIVEKIT :: RTCTOKEN => \(rtcToken)")
            
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
            
            print("::::::: ==== >>>> VideoSession ( uid: \(newSession.uid) , type : \(newSession.type))")
            
            return newSession
        }
    }

    
}

extension RTCLiveKitManager: RoomDelegate {
    
    public func room(_ room: Room, didUpdateConnectionState connectionState: ConnectionState, from oldConnectionState: ConnectionState) {
        
        switch connectionState {
        case .connected:
            if oldConnectionState == .reconnecting, !self.isCameraMute {
                self.updateLiveKitCameraStatus = true
            }
            print("CONNECTED ---->")
            break
        case .disconnected:
            print("DISCONNECTED ---->")
            break
        case .connecting:
            print("CONNECTING ---->")
            break
        case .reconnecting:
            print("RECONNECTING ---->")
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
  
        print("Remote track publication method")
        
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
    
//    func room(_ room: Room, participant: Participant, didUpdate publication: TrackPublication, muted: Bool) {
//        
//        let participantUid = participant.identity.ism_userIdUInt() ?? 0
//        
//        let session = getSession(of: participantUid)
////        print("Camera Mute :: for user session named: \(session?.userData?.name ?? "Unk") is set to be \(!participant.isCameraEnabled())")
////
////        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "streamAudioVideo"), object: nil, userInfo: ["eventName": "streamVideo", "value": !participant.isCameraEnabled(), "uid": participantUid])
////
////        print("Microphone Mute :: for user session named: \(session?.userData?.name ?? "Unk") is set to be \(!participant.isMicrophoneEnabled())")
////
////        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "streamAudioVideo"), object: nil, userInfo: ["eventName": "streamAudio", "value": !participant.isMicrophoneEnabled(), "uid": participantUid])
//        
////        if let videoTrack = publication.track as? VideoTrack {
////            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "streamAudioVideo"), object: nil, userInfo: ["eventName": "streamVideo", "value": muted, "uid": participantUid])
////        }
////
////        if let audioTrack = publication.track as? AudioTrack {
////            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "streamAudioVideo"), object: nil, userInfo: ["eventName": "streamAudio", "value": muted, "uid": participantUid])
////        }
//        
//    }

    
}
