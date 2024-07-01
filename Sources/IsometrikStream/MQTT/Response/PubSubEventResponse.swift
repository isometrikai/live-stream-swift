//
//  PubSubEventResponse.swift
//  PicoAdda
//
//  Created by Appscrip 3Embed on 12/06/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import Foundation

/**
 *  Pubsub MQTT Response
 */

extension ISMMQTTSessionWrapper {
    
    func pubsubMessageEventReponse(_ data: Data, completionHandler: @escaping(MqttResult<PubsubEvent>) -> Void) {
        
        do {
            let pubsubObj = try data.decode() as PubsubEvent
            completionHandler(.success(pubsubObj))

        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * PubsubEvent *.")
            completionHandler(.failure(error))
        }
        
    }
    
    func pubsubDirectMessagePublishedEventReponse(_ data: Data, completionHandler: @escaping(MqttResult<PubsubPayloadResponse>) -> Void) {
        
        do {
            let pubsubObj = try data.decode() as PubsubPayloadResponse
            completionHandler(.success(pubsubObj))

        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * PubsubEvent *.")
            completionHandler(.failure(error))
        }
        
    }
    
    
    func pubsubMessageOnTopicPublishedEventReponse(_ data: Data, completionHandler: @escaping(MqttResult<PubsubPayloadResponse>) -> Void) {
        
        do {
            let pubsubObj = try data.decode() as PubsubPayloadResponse
            completionHandler(.success(pubsubObj))

        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * PubsubEvent *.")
            completionHandler(.failure(error))
        }
        
    }
    
}
