//
//  CopublishMqttEventResponse.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 14/11/22.
//

import Foundation

/**
 *  Copublish MQTT Response
 */

extension ISMMQTTSessionWrapper {
    
    func copublishRequestAddEventResponse(_ data: Data , completionHandler: @escaping (MqttResult<ISMRequest>) -> ()) {
        
        do {
            let copublishObj = try data.ism_live_decode() as CopublishRequestAddEvent
            
            /// Convert json into member info data.
            let userInfo = ISMRequest(userProfilePic: copublishObj.userProfilePic.unwrap, userName: copublishObj.userName.unwrap, pending: nil, accepted: nil, userId: copublishObj.userId.unwrap, userIdentifier: copublishObj.userIdentifier.unwrap, requestTime: Double(copublishObj.timestamp.unwrap), streamId: copublishObj.streamId.unwrap)
            
            completionHandler(.success(userInfo))
            
        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * CopublishRequestAddEventResponse *.")
            completionHandler(.failure(error))
        }
    }
    
    func copublishRequestAcceptEventResponse(_ data: Data , completionHandler: @escaping (MqttResult<ISMRequest>) -> ()) {
        
        do {
            let copublishObj = try data.ism_live_decode() as CopublishRequestAcceptEvent
            
            /// Convert json into member info data.
            let userInfo = ISMRequest(userProfilePic: copublishObj.userProfilePic.unwrap, userName: copublishObj.userName.unwrap, pending: false, accepted: true, userId: copublishObj.userId.unwrap, userIdentifier: copublishObj.userIdentifier.unwrap, requestTime: Double(copublishObj.timestamp.unwrap), streamId: copublishObj.streamId.unwrap)
            
            completionHandler(.success(userInfo))
            
        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * CopublishRequestAcceptEventResponse *.")
            completionHandler(.failure(error))
        }
    }
    
    func copublishRequestRemovedEventResponse(_ data: Data, completionHandler: @escaping ((MqttResult<ISMRequest>) -> Void)) {
        
        do {
            let copublishObj = try data.ism_live_decode() as CopublishRequestAcceptEvent
            
            /// Convert json into member info data.
            let userInfo = ISMRequest(userProfilePic: copublishObj.userProfilePic.unwrap, userName: copublishObj.userName.unwrap, pending: false, accepted: true, userId: copublishObj.userId.unwrap, userIdentifier: copublishObj.userIdentifier.unwrap, requestTime: Double(copublishObj.timestamp.unwrap), streamId: copublishObj.streamId.unwrap)
            
            completionHandler(.success(userInfo))
        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * CopublishRequestRemovedEventResponse *.")
            completionHandler(.failure(error))
        }
        
    }
    
    func copublishRequestDeniedEventResponse(_ data: Data, completionHandler: @escaping ((MqttResult<ISMRequest>) -> Void)) {
        
        do {
            let copublishObj = try data.ism_live_decode() as CopublishRequestAcceptEvent
            
            /// Convert json into member info data.
            let userInfo = ISMRequest(userProfilePic: copublishObj.userProfilePic.unwrap, userName: copublishObj.userName.unwrap, pending: false, accepted: false, userId: copublishObj.userId.unwrap, userIdentifier: copublishObj.userIdentifier.unwrap, requestTime: Double(copublishObj.timestamp.unwrap), streamId: copublishObj.streamId.unwrap)
            
            completionHandler(.success(userInfo))
        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * CopublishRequestDeniedEventResponse *.")
            completionHandler(.failure(error))
        }
        
    }
    
    func copublishRequestSwitchProfileEventResponse(_ data: Data , completionHandler: @escaping (MqttResult<ProfileSwitched>) -> ()) {
        
        do {
            let copublishObj = try data.ism_live_decode() as CopublishRequestSwitchProfileEvent
            
            /// Convert json into member info data.
            let profile = ProfileSwitched(streamId: copublishObj.streamId.unwrap, viewersCount: copublishObj.viewersCount.unwrap, userProfilePic: copublishObj.userProfilePic.unwrap, timeStamp: String(copublishObj.timestamp.unwrap), action: copublishObj.action.unwrap, membersCount: copublishObj.membersCount.unwrap, userId: copublishObj.userId.unwrap, userName: copublishObj.userName.unwrap, userIdentifier: copublishObj.userIdentifier.unwrap)
            
            completionHandler(.success(profile))
        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * CopublishRequestSwitchProfileEventResponse *.")
            completionHandler(.failure(error))
        }
        
    }
    
}
