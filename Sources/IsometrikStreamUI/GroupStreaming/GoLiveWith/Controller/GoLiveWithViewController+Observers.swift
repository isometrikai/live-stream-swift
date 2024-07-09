//
//  GoLiveWithViewController+Observers.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 20/06/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import Foundation
import IsometrikStream

extension GoLiveWithViewController {
    
    func addObservers(){
        let isometrik = viewModel.isometrik
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttStreamStopped), name: ISMMQTTNotificationType.mqttStreamStopped.name, object: nil)
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttViewerJoined), name: ISMMQTTNotificationType.mqttViewerJoined.name, object: nil)
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttViewerRemoved), name: ISMMQTTNotificationType.mqttViewerRemoved.name, object: nil)
    }
    
    func removeObservers(){
        let isometrik = self.viewModel.isometrik
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttViewerJoined.name, object: nil)
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttViewerRemoved.name, object: nil)
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttStreamStopped.name, object: nil)
    }
    
    // MARK: - MQTT Events ACTIONS
    
    @objc private func mqttStreamStopped(notification: NSNotification) {
        guard let _ = notification.userInfo?["data"] as? ISMStream else {
            return
        }
        self.dismiss(animated: true)
    }
    
    @objc private func mqttViewerJoined(notification: NSNotification) {
        
//        guard let viewerData = notification.userInfo?["data"] as? ViewerJoinEvent,
//              viewerData.streamId.unwrap == viewModel.streamData?.streamId.unwrap,
//              !viewerExists(withId: viewerData.viewerId.unwrap)
//        else { return }
        
        if self.viewModel.selectedOption == .viewer {
            self.loadViewers(isRefresh: true)
        }
        
    }
    
    @objc private func mqttViewerRemoved(notification: NSNotification) {
        
//        guard let _ = notification.userInfo?["data"] as? ISMStream else {
//            return
//        }
        
        if self.viewModel.selectedOption == .viewer {
            self.loadViewers(isRefresh: true)
        }
    }
    
    func viewerExists(withId id: String) -> Bool {
        
        let viewers = self.viewModel.viewers.filter { viewers in
            viewers.viewerId == id
        }
        
        return viewers.count > 0
    }
    
}
