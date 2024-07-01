//
//  ViewerMqttEventResponse.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 14/11/22.
//

import Foundation

/**
 *  Viewer MQTT Response
 */

extension ISMMQTTSessionWrapper {
    
    func viewerJoinEventResponse(_ data: Data , completionHandler: @escaping (MqttResult<ViewerJoinEvent>) -> ()) {
        
        do {
            let viewerObj = try data.ism_live_decode() as ViewerJoinEvent
            completionHandler(.success(viewerObj))
            
        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * ViewerJoinEvent *.")
            completionHandler(.failure(error))
        }
    }
    
    
    func viewerLeaveEventResponse(_ data: Data , completionHandler: @escaping (MqttResult<ViewerLeaveEvent>) -> ()) {
        
        do {
            let viewerObj = try data.ism_live_decode() as ViewerLeaveEvent
            completionHandler(.success(viewerObj))
            
        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * ViewerLeaveEvent *.")
            completionHandler(.failure(error))
        }
    }
    
    func viewerRemoveEventResponse(_ data: Data , completionHandler: @escaping (MqttResult<ViewerRemoveEvent>) -> ()) {
        
        do {
            let viewerObj = try data.ism_live_decode() as ViewerRemoveEvent
            completionHandler(.success(viewerObj))
            
        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * ViewerRemoveEvent *.")
            completionHandler(.failure(error))
        }
    }
    
    func viewerTimeoutEventResponse(_ data: Data , completionHandler: @escaping (MqttResult<ISMStream>) -> ()) {
        
        do {
            let viewerObj = try data.ism_live_decode() as ViewerTimeoutEvent
            
            /// Convert json into viewer info data.
            let viewerInfo = ISMViewer(viewerId: viewerObj.viewerId.unwrap, name: viewerObj.viewerName.unwrap)
            
            /// Convert json into stream info data.
            let streamInfo = ISMStream(streamId: viewerObj.streamId.unwrap,
                                       viewersCount: Int64(viewerObj.viewersCount.unwrap),
                                       startTime: Int64(viewerObj.timestamp.unwrap),
                                       membersPublishingCount: Int64(viewerObj.membersCount.unwrap),
                                       membersCount: Int64(viewerObj.membersCount.unwrap),
                                       viewers: [viewerInfo])
            
            completionHandler(.success(streamInfo))
            
        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * ViewerTimeoutEvent *.")
            completionHandler(.failure(error))
        }
    }
    
}
