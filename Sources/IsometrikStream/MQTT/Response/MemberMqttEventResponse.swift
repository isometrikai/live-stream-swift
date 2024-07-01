//
//  MemberMqttEventResponse.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 14/11/22.
//

import Foundation

/**
 *  Member MQTT Response
 */

extension ISMMQTTSessionWrapper {
    
    func memberAddEventResponse(_ data: Data , completionHandler: @escaping (MqttResult<MemberAddEvent>) -> ()) {
        
        do {
            let memberObj = try data.ism_live_decode() as MemberAddEvent
            completionHandler(.success(memberObj))
            
        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * MemberAddEventResponse *.")
            completionHandler(.failure(error))
        }
    }
    
    
    func memberLeaveEventResponse(_ data: Data , completionHandler: @escaping (MqttResult<MemberLeaveEvent>) -> ()) {
        
        do {
            let memberObj = try data.ism_live_decode() as MemberLeaveEvent
            completionHandler(.success(memberObj))
            
        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * MemberLeaveEventResponse *.")
            completionHandler(.failure(error))
        }
    }
    
    func memberRemoveEventResponse(_ data: Data , completionHandler: @escaping (MqttResult<MemberRemoveEvent>) -> ()) {
        
        do {
            let memberObj = try data.ism_live_decode() as MemberRemoveEvent
            completionHandler(.success(memberObj))
            
        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * MemberRemoveEventResponse *.")
            completionHandler(.failure(error))
        }
    }
    
    
    func memberTimeoutEventResponse(_ data: Data , completionHandler: @escaping (MqttResult<MemberTimeoutEvent>) -> ()) {
        
        do {
            let memberObj = try data.ism_live_decode() as MemberTimeoutEvent
            completionHandler(.success(memberObj))
            
        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * MemberTimeoutEventResponse *.")
            completionHandler(.failure(error))
        }
    }
    
    func publishStartEventResponse(_ data: Data , completionHandler: @escaping (MqttResult<ISMStream>) -> ()) {
        
        do {
            let publishObj = try data.ism_live_decode() as PublishStartEvent
            
            /// Convert json into member info data.
            let memberInfo = ISMMember(userID: publishObj.memberId.unwrap, userName: publishObj.memberName.unwrap)
            
            /// Convert json into stream info data.
            let streamInfo = ISMStream(streamId: publishObj.streamId.unwrap,
                                       viewersCount: Int64(publishObj.viewersCount.unwrap),
                                       startTime: Int64(publishObj.timestamp.unwrap),
                                       membersPublishingCount: Int64(publishObj.membersCount.unwrap),
                                       membersCount: Int64(publishObj.membersCount.unwrap),
                                       members: [memberInfo])
            
            completionHandler(.success(streamInfo))
            
        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * PublishStartEventResponse *.")
            completionHandler(.failure(error))
        }
    }
    
    
    func publishStopEventResponse(_ data: Data , completionHandler: @escaping (MqttResult<ISMStream>) -> ()) {
        
        do {
            let publishObj = try data.ism_live_decode() as PublishStopEvent
            
            /// Convert json into member info data.
            let memberInfo = ISMMember(userID: publishObj.memberId.unwrap, userName: publishObj.memberName.unwrap)
            
            /// Convert json into stream info data.
            let streamInfo = ISMStream(streamId: publishObj.streamId.unwrap,
                                       viewersCount: Int64(publishObj.viewersCount.unwrap),
                                       startTime: Int64(publishObj.timestamp.unwrap),
                                       membersPublishingCount: Int64(publishObj.membersCount.unwrap),
                                       membersCount: Int64(publishObj.membersCount.unwrap),
                                       members: [memberInfo])
            
            completionHandler(.success(streamInfo))
            
        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * PublishStopEventResponse *.")
            completionHandler(.failure(error))
        }
    }
    
}
