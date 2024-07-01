//
//  ModeratorMqttEventResponse.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 16/02/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import Foundation

/**
 *  Moderator MQTT Response
 */

extension ISMMQTTSessionWrapper {
    
    func moderatorAddedEventResponse(_ data: Data, completionHandler: @escaping(MqttResult<ModeratorEvent>) -> Void) {
        
        do {
            let moderatorObj = try data.ism_live_decode() as ModeratorEvent
            completionHandler(.success(moderatorObj))
            
        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * ModeratorEvent *.")
            completionHandler(.failure(error))
        }
        
    }
    
    func moderatorRemovedEventResponse(_ data: Data, completionHandler: @escaping(MqttResult<ModeratorEvent>) -> Void) {
        do {
            let moderatorObj = try data.ism_live_decode() as ModeratorEvent
            completionHandler(.success(moderatorObj))
            
        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * ModeratorEvent *.")
            completionHandler(.failure(error))
        }
    }
    
    func moderatorLeftEventResponse(_ data: Data, completionHandler: @escaping(MqttResult<ModeratorEvent>) -> Void) {
        do {
            let moderatorObj = try data.ism_live_decode() as ModeratorEvent
            completionHandler(.success(moderatorObj))
            
        } catch {
            let error = IsometrikError(errorMessage: "Error while parsing * ModeratorEvent *.")
            completionHandler(.failure(error))
        }
    }
    
}
