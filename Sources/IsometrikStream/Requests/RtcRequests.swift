//
//  RtcRequests.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 12/11/22.
//

import Foundation

/**
    Isometrik `RTC` Requests
 */

extension IsometrikStream {
    
    public func joinChannel(userId: UInt, hdBroadCast: Bool = false, isRestream: Bool = false, isRecorded: Bool = false) {
        rtcWrapper.getLiveKitManager()?.connectToRoom(withUid: userId, hdBroadcast: hdBroadCast, isRestream: isRestream, isRecorded: isRecorded)
    }
    
    public func leaveChannel() {
        rtcWrapper.getLiveKitManager()?.disconnectFromRoom()
    }
    
    public func switchCamera() {
        if let liveKitManager = rtcWrapper.getLiveKitManager() {
            liveKitManager.isRearCamera = !liveKitManager.isRearCamera
        }
    }
    
    public func setUserRoleInStream(_ userRole : ISMClientRole){
        rtcWrapper.getLiveKitManager()?.settings.role = userRole
    }
    
    public func setMuteStatusForAudio() {
        if let liveKitManager = rtcWrapper.getLiveKitManager() {
            liveKitManager.isMicrophoneMute = !liveKitManager.isMicrophoneMute
        }
    }
    
    public func setMuteStatusForVideo() {
        if let liveKitManager = rtcWrapper.getLiveKitManager() {
            liveKitManager.isCameraMute = !liveKitManager.isCameraMute
        }
    }
    
    public func setMuteStatusForAudio(status: Bool) {
        if let liveKitManager = rtcWrapper.getLiveKitManager() {
            liveKitManager.isMicrophoneMute = status
        }
    }
    
    public func setMuteStatusForVideo(status: Bool) {
        if let liveKitManager = rtcWrapper.getLiveKitManager() {
            liveKitManager.isCameraMute = status
        }
    }
    
    public func getMuteStatusForAudio() -> Bool{
        if let liveKitManager = rtcWrapper.getLiveKitManager() {
            return liveKitManager.isMicrophoneMute
        }
        return false
    }
    
    public func getMuteStatusForVideo() -> Bool{
        if let liveKitManager = rtcWrapper.getLiveKitManager() {
            return liveKitManager.isCameraMute
        }
        return false
    }
    
    public func setAudioStatusForRemoteSession(uid: UInt, status: Bool) {
        rtcWrapper.getLiveKitManager()?.muteRemoteAudioTrack(participantId: uid, mute: status)
    }
    
    public func setVideoStatusForRemoteSession(uid: UInt, status: Bool) {
        rtcWrapper.getLiveKitManager()?.muteRemoteVideoTrack(participantId: uid, mute: status)
    }
    
    public func updateCameraStatus(){
        guard let liveKitManager = rtcWrapper.getLiveKitManager(), rtcWrapper.rtcUsing == .livekit else{
           return
        }
        guard liveKitManager.updateLiveKitCameraStatus  else{
            return
        }
        
       // on 1st iteration CameraMute will go true to disable the camera
       // on 2nd iteration CameraMute will go false to enable the camera
            liveKitManager.isCameraMute = !liveKitManager.isCameraMute
        // If camera become enabled, break the condition and stop updating camera state
            if  liveKitManager.isCameraMute == false{
                liveKitManager.updateLiveKitCameraStatus = false
            }
        
    }
    
}

