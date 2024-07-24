//
//  StreamViewModel+Subscription.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 25/10/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import Foundation

extension StreamViewModel {
    
    /// subscribe MQTT events
    func subscribeToMqttEvents() {
        let clientId = isometrik.getUserSession().getUserId()
        isometrik.getIsometrik().subsribeForMQTT(clientId: clientId, streamStartChannel: true) { result in
            print("Subscription Api Success")
        } failure: { error in
            print("Subscription api failure \(error.localizedDescription)")
        }
        
    }
    
    func unsubscribeToMqttEvents() {
        let clientId = isometrik.getUserSession().getUserId()
        isometrik.getIsometrik().unsubscribeForMQTT(clientId: clientId, startStreamChannel: false) { result in
            print("Unsubscription Api Success")
        } failure: { error in
            print("Unsubscription api failure \(error.localizedDescription)")
        }
        
    }
    
    func subscribeToStreamEvents(streamId: String) {
        isometrik.getMqttSession().subscribeStreamEvents(with: streamId)
    }
    
    func unsubscribeToStreamEvents(streamId: String) {
        isometrik.getMqttSession().unsubscribeStreamEvents(with: streamId)
    }
    
}
