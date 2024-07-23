//
//  File.swift
//
//
// Created by Appscrip on 04/08/20.
//

import UIKit
import Foundation
import CocoaMQTT

/// `ISMMQTTSessionWrapperCompletionBlock` will used as a completion handler.
public typealias ISMMQTTSessionWrapperCompletionBlock = (Result<String, Error>) -> Void

// MARK: Intialization
/// `ISMMQTTSessionWrapper` will handle the MQTT session funcs.
open class ISMMQTTSessionWrapper: NSObject {
    
    var mqtt: CocoaMQTT?
    var configuration : ISMConfiguration
    
    /// User Id using for client Id.
    var clientId: String = ""
    var isometrikId: String = ""
    
    public var isConnected = false
    
    /// Init funcs.
    init(configuration : ISMConfiguration = ISMConfiguration.shared) {
        self.configuration = configuration
        super.init()
    }
    
    /// Establish connection for `MQTTSessionManager`
    /// - Parameter clientId: User Id using for client Id.
    open func establishConnection(withUserId clientId: String) {
        
        let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? ""
        self.isometrikId = clientId
        
        if self.clientId == "" {
            self.clientId = clientId + "/STREAM/" + deviceID
        }
        
        let userName = "2" + configuration.accountId + configuration.projectId
        let password = configuration.licenseKey + configuration.keySetId
        
        let clientID = clientId + "/STREAM/" + deviceID
        let port = UInt16(configuration.MQTTPort)
        
        LogManager.shared.logMQTT("ClientId: \(clientID)", type: .info)
        
        mqtt = CocoaMQTT(clientID: clientID, host: configuration.MQTTHost, port: port)
        mqtt?.logLevel = .off
        mqtt?.username = userName
        mqtt?.password = password
        mqtt?.willMessage = nil
        mqtt?.keepAlive = 60
        mqtt?.delegate = self
        mqtt?.autoReconnect = false
        
        _ = mqtt?.connect()
        
    }
    
    /// Adds an entry to the notification center to call the provided selector with the notification.
    /// - Parameters:
    ///   - observer: observer, Class refernce.
    ///   - aSelector: Selector func
    ///   - aName: Notification name
    ///   - anObject: anObject,
    open func addObserverForMQTT(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?) {
        NotificationCenter.default.addObserver(observer, selector: aSelector, name: aName, object: anObject)
    }
    
    open func removeObserverForMQTT(_ observer: Any, name aName: NSNotification.Name?, object anObject: Any?) {
        NotificationCenter.default.removeObserver(observer, name: aName, object: anObject)
    }
    
}

// MARK: Subscriptions
extension ISMMQTTSessionWrapper {
    
    
    public func subscribeStreamEvents(with streamId: String){
        if let mqtt = mqtt {
            let channel = "/" + configuration.accountId + "/" + configuration.projectId + "/" + streamId
            LogManager.shared.logMQTT("Subscribing to streaming events with topic: \(channel)", type: .info)
            mqtt.subscribe(channel, qos: .qos0)
        }
    }
    
    public func unsubscribeStreamEvents(with streamId: String){
        if let mqtt = mqtt {
            let channel = "/" + configuration.accountId + "/" + configuration.projectId + "/" + streamId
            LogManager.shared.logMQTT("Unsubscribing to streaming events with topic: \(channel)", type: .info)
            mqtt.unsubscribe(channel)
        }
    }
    
    public func subscribeUserEvents() {
        if let mqtt = mqtt {
            let channel = "/" + configuration.accountId + "/" + configuration.projectId + "/User/" + isometrikId
            LogManager.shared.logMQTT("Subscribing to user events with topic: \(channel)", type: .info)
            mqtt.subscribe(channel, qos: .qos0)
        }
    }
    
    public func unsubscribeUserEvents(){
        if let mqtt = mqtt {
            let channel = "/" + configuration.accountId + "/" + configuration.projectId + "/User/" + isometrikId
            LogManager.shared.logMQTT("Unsubscribing to user events with topic: \(channel)", type: .info)
            mqtt.unsubscribe(channel)
        }
    }

    /// subscribe presence events channel.
    /// - Parameter completion: completionHandler for response data.
    public func subscribePresenceEvents() {
//        if let mqtt = mqtt {
//            let channel = "/" + configuration.accountId + "/" + configuration.projectId + "/Status/" + clientId
//            mqtt.subscribe(channel, qos: CocoaMQTTQoS.qos0)
//        }
    }
    
    /// subscribe presence events channel.
    /// - Parameter completion: completionHandler for response data.
    public func unsubscribePresenceEvents() {
//        if let mqtt = mqtt {
//            let channel = "/" + configuration.accountId + "/" + configuration.projectId + "/Status/" + clientId
//            mqtt.unsubscribe(channel)
//        }
    }
    
    

    public func disconnectMQTT(){
        if mqtt != nil {
            mqtt?.disconnect()
            mqtt = nil
        }
    }

}
