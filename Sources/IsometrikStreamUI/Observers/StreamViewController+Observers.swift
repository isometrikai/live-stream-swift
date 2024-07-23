//
//  StreamViewController+Observers.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 31/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit
import IsometrikStream

/**
    Extension to manage the `Observers` used in the `StreamViewController` class
*/

extension StreamViewController {
    
    // MARK: - ADD OBSERVER FUNCTIONS
    
    /// Adds App Life Cycle Observers
    func addAppLifeCycleObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIScene.willDeactivateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIScene.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIScene.didActivateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIScene.willEnterForegroundNotification, object: nil)
    }
    
    /// Adds MQTT Observers
    func addMqttObservers(){
        
        let isometrik = viewModel.isometrik
        /**
         MQTT observers for `Member`
         */
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttMemberAdded), name: ISMMQTTNotificationType.mqttMemberAdded.name, object: nil)
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttMemberRemoved), name: ISMMQTTNotificationType.mqttMemberRemoved.name, object: nil)
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttMemberLeft), name: ISMMQTTNotificationType.mqttMemberLeft.name, object: nil)
        
        
        /**
         MQTT observers for `Viewer`
         */
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttViewerJoined), name: ISMMQTTNotificationType.mqttViewerJoined.name, object: nil)
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttViewerRemoved), name: ISMMQTTNotificationType.mqttViewerRemoved.name, object: nil)
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttViewerRemoved), name: ISMMQTTNotificationType.mqttViewerTimeout.name, object: nil)
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttViewerRemovedByInitiator), name: ISMMQTTNotificationType.mqttViewerRemovedByInitiator.name, object: nil)
        
        /**
         MQTT observers for `Message`
         */
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttSentMessage), name: ISMMQTTNotificationType.mqttMessageSent.name, object: nil)
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttMessageReply), name: ISMMQTTNotificationType.mqttMessageReplySent.name, object: nil)
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttRemoveMessage), name: ISMMQTTNotificationType.mqttMessageRemoved.name, object: nil)
        
        /**
         MQTT observers for `Stream`
         */
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttStreamStopped), name: ISMMQTTNotificationType.mqttStreamStopped.name, object: nil)
        
        
        /**
         MQTT observers for `Publisher`
         */
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttPublisherTimeout), name: ISMMQTTNotificationType.mqttPublisherTimeout.name, object: nil)
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttPublisherStopped), name: ISMMQTTNotificationType.mqttPublishStopped.name, object: nil)
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttRequestToBeCoPublisherAdded), name: ISMMQTTNotificationType.mqttRequestToBeCoPublisherAdded.name, object: nil)
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttRequestToBeCoPublisherRemoved), name: ISMMQTTNotificationType.mqttRequestToBeCoPublisherRemoved.name, object: nil)
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttCopublishRequestAccepted), name: ISMMQTTNotificationType.mqttCopublishRequestAccepted.name, object: nil)
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttProfileSwitched), name: ISMMQTTNotificationType.mqttProfileSwitched.name, object: nil)
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttCopublishRequestDenied), name: ISMMQTTNotificationType.mqttCopublishRequestDenied.name, object: nil)
        
        /**
         MQTT observers for `Moderators`
         */
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttModeratorAdded), name: ISMMQTTNotificationType.mqttModeratorAdded.name, object: nil)
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttModeratorRemoved), name: ISMMQTTNotificationType.mqttModeratorRemoved.name, object: nil)
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttModeratorLeft), name: ISMMQTTNotificationType.mqttModeratorLeft.name, object: nil)
        
        /**
         MQTT observers for `Pubsub`
         */
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.pubsubMessagePublished), name: ISMMQTTNotificationType.mqttPubsubMessagePublished.name, object: nil)
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.pubsubDirectMessagePublished), name: ISMMQTTNotificationType.mqttPubsubDirectMessagePublished.name, object: nil)
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.pubsubMessageOnTopicPublished), name: ISMMQTTNotificationType.mqttPubsubMessageOnTopicPublished.name, object: nil)
        
        
    }
    
    func addStreamObservers(){
        addAppLifeCycleObservers()
        addMqttObservers()
    }
    
    // MARK: - REMOVE OBSERVES FUNCTIONS
    
    /// Removing App Life Cycle Observers
    func removeAppLifeCycleObservers(){
        NotificationCenter.default.removeObserver(self, name: UIScene.willDeactivateNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIScene.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIScene.didActivateNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIScene.willEnterForegroundNotification, object: nil)
    }
    
    func removeMQTTObservers(){
        /// Removing MQTT Observers

        let isometrik = viewModel.isometrik
        
        /**
         Remove observers for `Member`
         */
        
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttMemberAdded.name, object: nil)
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttMemberRemoved.name, object: nil)
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttMemberLeft.name, object: nil)
        
        /**
         Remove observers for `Viewer`
         */
        
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttViewerJoined.name, object: nil)
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttViewerRemoved.name, object: nil)
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttViewerRemovedByInitiator.name, object: nil)
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttViewerTimeout.name, object: nil)
        
        /**
         Remove observers for `Message`
         */
        
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttMessageSent.name, object: nil)
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttMessageReplySent.name, object: nil)
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttMessageRemoved.name, object: nil)
        
        /**
         Remove observers for `Stream`
         */
    
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttStreamStopped.name, object: nil)
        
        /**
         Remove observers for `Publisher`
         */
        
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttPublisherTimeout.name, object: nil)
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttPublishStopped.name, object: nil)
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttRequestToBeCoPublisherAdded.name, object: nil)
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttRequestToBeCoPublisherRemoved.name, object: nil)
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttCopublishRequestAccepted.name, object: nil)
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttProfileSwitched.name, object: nil)
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttCopublishRequestDenied.name, object: nil)
        
        /**
         MQTT observers for `Moderators`
         */
        
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttModeratorAdded.name, object: nil)
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttModeratorRemoved.name, object: nil)
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttModeratorLeft.name, object: nil)
        
        /**
         MQTT observers for `Pubsub`
         */
        
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttPubsubMessagePublished.name, object: nil)
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttPubsubDirectMessagePublished.name, object: nil)
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttPubsubMessageOnTopicPublished.name, object: nil)

    }
    
    func removeAllObservers(){
        removeAppLifeCycleObservers()
        removeMQTTObservers()
    }
    
}
