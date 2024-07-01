//
//  StreamMqttEventResponse.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 14/11/22.
//

import Foundation

/**
 *  Stream MQTT Response
 */

extension ISMMQTTSessionWrapper {
    
    func streamStartEventResponse(_ data: Data , completionHandler: @escaping (MqttResult<ISMStream>) -> ()) {
        
        do {
            let streamObj = try data.ism_live_decode() as StreamStartEvent
            
            var members: [ISMMember] = []
            let streaObjMembers = streamObj.members ?? []
            for member in streaObjMembers {
//                let memberInfo = ISMMember(memberId: member.memberId.unwrap,
//                                           identifier: member.memberIdentifier.unwrap,
//                                           name: member.memberName.unwrap,
//                                           imagePath: "",
//                                           joinTime: 0,
//                                           isPublishing: false,
//                                           isHost: member.isAdmin!)
//                members.append(memberInfo)
            }
            
            /// Convert json into stream info data.
            let streamInfo = ISMStream(streamId: streamObj.streamId.unwrap,
                                       streamImage: streamObj.streamImage,
                                       streamDescription: streamObj.streamDescription,
                                       startTime: Int64(streamObj.timestamp.unwrap),
                                       membersPublishingCount: Int64(streamObj.membersCount.unwrap),
                                       membersCount: Int64(streamObj.membersCount.unwrap),
                                       initiatorName: streamObj.initiatorName,
                                       createdBy: streamObj.initiatorId,
                                       members: members)
            
            completionHandler(.success(streamInfo))
            
        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * StreamStartEvent *.")
            completionHandler(.failure(error))
        }
    }
    
    func streamStopEventResponse(_ data: Data , completionHandler: @escaping (MqttResult<ISMStream>) -> ()) {
        
        do {
            let streamObj = try data.ism_live_decode() as StreamStartEvent
            
            /// Convert json into stream info data.
            let streamInfo = ISMStream(streamId: streamObj.streamId.unwrap, startTime: streamObj.timestamp.unwrap, createdBy: streamObj.initiatorId)
            
            completionHandler(.success(streamInfo))
            
        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * StreamStopEvent *.")
            completionHandler(.failure(error))
        }
    }
    
}
