//
//  PresenceMqttEventResponse.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 14/11/22.
//

import Foundation

/**
 *  Presence MQTT Response
 */

extension ISMMQTTSessionWrapper {
    
    func presenceStreamStartEventResponse(_ data: Data , completionHandler: @escaping (MqttResult<ISMStream>) -> ()) {
        
        do {
            let streamObj = try data.ism_live_decode() as PresenceStreamStartEvent
            
            
            /// Convert json into stream info data.
//            let streamInfo = ISMStream(streamId: streamObj.streamId.unwrap, viewersCount: Int64(streamObj.viewersCount.unwrap), streamImage: streamObj.streamImage.unwrap, streamDescription: streamObj.streamDescription.unwrap, startTime: Int64(streamObj.timestamp.unwrap), membersPublishingCount: Int64(streamObj.membersCount.unwrap), membersCount: Int64(streamObj.membersCount.unwrap), memberIds: streamObj.memberIds ?? [], initiatorName: streamObj.initiatorName.unwrap, createBy: streamObj.createdBy.unwrap, initiatorimage: streamObj.initiatorImage.unwrap, initiatorId: streamObj.initiatorId.unwrap, streamKey: streamObj.streamKey.unwrap, ingestEndpoint: streamObj.ingestEndPoint.unwrap, playbackUrl: streamObj.playbackUrl.unwrap, multiLive: streamObj.multiLive, rtcToken: streamObj.rtcToken.unwrap, restreamChannelCount: streamObj.restreamChannelsCount.unwrap, restream: streamObj.restream, productsLinked: streamObj.productLinked, productsCount: streamObj.productsCount.unwrap, initiatorIdentifier: streamObj.initiatorIdentifier.unwrap)
//
//            completionHandler(.success(streamInfo))
            
        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * PresenceStreamStartEventResponse *.")
            completionHandler(.failure(error))
        }
    }
    
}
