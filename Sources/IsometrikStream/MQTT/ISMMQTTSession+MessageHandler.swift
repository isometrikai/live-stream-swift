//
//  ISMMQTTSession+MessageHandler.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 14/11/22.
//

import Foundation
import CocoaMQTT

/// Extension of `ISMMQTTSessionWrapper` to use for `MQTTSessionManagerDelegate` funcs.

extension ISMMQTTSessionWrapper: CocoaMQTTDelegate {
    
    public func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        TRACE("ack: \(ack)")

        if ack == .accept {
            subscribeUserEvents()
            subscribeMessaging()
            subscribePresenceEvents()
            
            // re-subscribing to the stream events
            let isometrik = IsometrikSDK.getInstance()
            if let streamData = isometrik.getUserSession().getCurrentStreamData() {
                subscribeStreamEvents(with: streamData.streamId ?? "")
            }
        }
        
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didStateChangeTo state: CocoaMQTTConnState) {
        TRACE("new state: \(state)")
        switch state {
        case .disconnected:
            isConnected = false
            
            // Try to reconnect manually when disconnected
            if self.mqtt != nil {
                establishConnection(withUserId: self.clientId)
            }
            
            break
        case .connecting:
            isConnected = false
            break
        case .connected:
            isConnected = true
            break
        }
        
    }

    public func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        TRACE("message: \(message.string?.description), id: \(id)")
    }

    public func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        TRACE("id: \(id)")
    }

    public func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        TRACE("message topic: \(message.topic)")
        TRACE("message: \(message.string?.description), id: \(id)")
        
        let messageString = "\(message.string?.description ?? "")"
        let data = Data(messageString.utf8)
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let actionName = json["action"] as? String else {
            return
        }
        
        print("Event triggered with ACTION NAME :: \(actionName)")
        
        switch MQTTData.dataType(actionName) {
        case .mqttMessageSent:
            self.messageAddEventResponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttMessageSent.name,
                                                    object: nil,
                                                    userInfo: ["data": data , "error" : ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttMessageSent.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }

        case .mqttMessageReplySent:

            self.messageReplyAddEventResponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttMessageReplySent.name,
                                                    object: nil,
                                                    userInfo: ["data": data , "error" : ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttMessageReplySent.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }

        case .mqttMessageRemoved:

            self.messageRemoveEventResponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttMessageRemoved.name,
                                                    object: nil,
                                                    userInfo: ["data": data , "error" : ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttMessageRemoved.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }
        case .mqttMessageReplyRemoved:

            self.messageReplyRemoveEventResponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttMessageReplyRemoved.name,
                                                    object: nil,
                                                    userInfo: ["data": data , "error" : ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttMessageReplyRemoved.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }

        case .mqttStreamStarted:

            self.streamStartEventResponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttStreamStarted.name,
                                                    object: nil,
                                                    userInfo: ["data": data , "error" : ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttStreamStarted.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }

        case .mqttStreamStopped:

            self.streamStopEventResponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttStreamStopped.name,
                                                    object: nil,
                                                    userInfo: ["data": data , "error" : ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttStreamStopped.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }

        case .mqttMemberAdded:

            self.memberAddEventResponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttMemberAdded.name,
                                                    object: nil,
                                                    userInfo: ["data": data , "error" : ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttMemberAdded.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }

        case .mqttMemberLeft:

            self.memberLeaveEventResponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttMemberLeft.name,
                                                    object: nil,
                                                    userInfo: ["data": data , "error" : ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttMemberLeft.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }

        case .mqttMemberRemoved:

            self.memberRemoveEventResponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttMemberRemoved.name,
                                                    object: nil,
                                                    userInfo: ["data": data , "error" : ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttMemberRemoved.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }

        case .mqttViewerJoined:

            self.viewerJoinEventResponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttViewerJoined.name,
                                                    object: nil,
                                                    userInfo: ["data": data , "error" : ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttViewerJoined.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }

        case .mqttViewerRemoved:

            self.viewerRemoveEventResponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttViewerRemoved.name,
                                                    object: nil,
                                                    userInfo: ["data": data , "error" : ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttViewerRemoved.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }

        case .mqttViewerTimeout:

            self.viewerTimeoutEventResponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttViewerTimeout.name,
                                                    object: nil,
                                                    userInfo: ["data": data , "error" : ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttViewerTimeout.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }

        case .mqttPublishStarted:

            self.publishStartEventResponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttPublishStarted.name,
                                                    object: nil,
                                                    userInfo: ["data": data , "error" : ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttPublishStarted.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }

        case .mqttPublishStopped:

            self.publishStopEventResponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttPublishStopped.name,
                                                    object: nil,
                                                    userInfo: ["data": data , "error" : ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttPublishStopped.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }

        case .mqttPublisherTimeout:

            self.memberTimeoutEventResponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttPublisherTimeout.name,
                                                    object: nil,
                                                    userInfo: ["data": data , "error" : ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttPublisherTimeout.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }

        case .mqttviewerRemovedByInitiator:

            self.viewerRemoveEventResponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttViewerRemovedByInitiator.name,
                                                    object: nil,
                                                    userInfo: ["data": data , "error" : ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttViewerRemovedByInitiator.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }

        case .mqttRequestToBeCoPublisherAdded:

            self.copublishRequestAddEventResponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttRequestToBeCoPublisherAdded.name,
                                                    object: nil,
                                                    userInfo: ["data": data , "error" : ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttRequestToBeCoPublisherAdded.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }

        case .mqttCopublishRequestAccepted:

            self.copublishRequestAcceptEventResponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttCopublishRequestAccepted.name,
                                                    object: nil,
                                                    userInfo: ["data": data , "error" : ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttCopublishRequestAccepted.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }
            
        case .mqttRequestToBeCoPublisherRemoved:

            self.copublishRequestRemovedEventResponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttRequestToBeCoPublisherRemoved.name,
                                                    object: nil,
                                                    userInfo: ["data": data , "error" : ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttRequestToBeCoPublisherRemoved.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }
            
        case .mqttCopublishRequestDenied:
            
            self.copublishRequestDeniedEventResponse(data) { result  in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttCopublishRequestDenied.name,
                                                    object: nil,
                                                    userInfo: ["data": data , "error" : ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttCopublishRequestDenied.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }

        case .mqttProfileSwitched:

            self.copublishRequestSwitchProfileEventResponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttProfileSwitched.name,
                                                    object: nil,
                                                    userInfo: ["data": data , "error" : ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttProfileSwitched.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }

        case .mqttStreamStartedPresence:

            self.presenceStreamStartEventResponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttStreamStartedPresence.name,
                                                    object: nil,
                                                    userInfo: ["data": data , "error" : ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttStreamStartedPresence.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }
            
        case .mqttModeratorRemoved:
            
            self.moderatorRemovedEventResponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttModeratorRemoved.name,
                                                    object: nil,
                                                    userInfo: ["data": data , "error" : ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttModeratorRemoved.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }
            
        case .mqttModeratorAdded:
            
            self.moderatorAddedEventResponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttModeratorAdded.name,
                                                    object: nil,
                                                    userInfo: ["data": data , "error" : ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttModeratorAdded.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }
            
        case .mqttModeratorLeft:
            
            self.moderatorLeftEventResponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttModeratorLeft.name,
                                                    object: nil,
                                                    userInfo: ["data": data , "error" : ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttModeratorLeft.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }
            
        case .mqttPubsubDirectMessagePublished:
            
            self.pubsubDirectMessagePublishedEventReponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttPubsubDirectMessagePublished.name,
                                                    object: nil,
                                                    userInfo: ["data": data, "error": ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttPubsubDirectMessagePublished.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }
            
            break
        case .mqttPubsubMessagePublished:
            
            self.pubsubMessageEventReponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttPubsubMessagePublished.name,
                                                    object: nil,
                                                    userInfo: ["data": data, "error": ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttPubsubMessagePublished.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }
            
            break
        case .mqttPubsubMessageOnTopicPublished:
            
            self.pubsubMessageOnTopicPublishedEventReponse(data) { result in
                switch result {
                case .success(let data):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttPubsubMessageOnTopicPublished.name,
                                                    object: nil,
                                                    userInfo: ["data": data, "error": ""])
                case .failure(let error):
                    NotificationCenter.default.post(name: ISMMQTTNotificationType.mqttPubsubMessageOnTopicPublished.name,
                                                    object: nil,
                                                    userInfo: ["data": "", "error": error])
                }
            }
            break
            

        default: break
        }
    }

    public func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        TRACE("subscribed: \(success), failed: \(failed)")
    }

    public func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
        TRACE("topic: \(topics)")
    }

    public func mqttDidPing(_ mqtt: CocoaMQTT) {
        TRACE()
    }

    public func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        TRACE()
    }

    public func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        TRACE("\(err?.localizedDescription)")
    }
    
    public func TRACE(_ message: String = "", fun: String = #function) {
        let names = fun.components(separatedBy: ":")
        var prettyName: String
        if names.count == 2 {
            prettyName = names[0]
        } else {
            prettyName = names[1]
        }
        
        if fun == "mqttDidDisconnect(_:withError:)" {
            prettyName = "didDisconnect"
        }

        print("[TRACE] [\(prettyName)]: \(message)")
    }
    
}



//extension ISMMQTTSessionWrapper: MQTTSessionManagerDelegate {
//
//    public func handleMessage(_ data: Data!, onTopic topic: String!, retained: Bool) {
//
//        /// Convert data into json.
//        print("MQTT_Topic ISM: %s", topic)
//        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let actionName = json["action"] as? String else {
//            return
//        }
//
//        print("ACTION NAME ::: \(actionName)")
//        print("JSON ::: \(json)")
//
//
//    }
//
//    public func sessionManager(_ sessionManager: MQTTSessionManager!, didChange newState: MQTTSessionManagerState) {
//        switch newState {
//        case .starting:
//            isConnected = false
//            os_log("Invalid switch condition", type: .default)
//        case .connecting:
//            isConnected = false
//            os_log("Session connecting", type: .default)
//        case .error:
//            isConnected = false
//            print(sessionManager.lastErrorCode.localizedDescription)
//            os_log("Session error!", type: .error)
//        case .connected:
//            isConnected = true
//            os_log("Session connected", type: .default)
//            subscribeMessaging { (_) in }
//            subscribePresenceEvents { (_) in }
//        case .closing:
//            isConnected = false
//            os_log("Session closing", type: .default)
//        case .closed:
//         //   self.disconnectISMMQTTConnection()
//            isConnected = false
//            print(sessionManager.lastErrorCode?.localizedDescription ?? "")
//            os_log("Session closed", type: .default)
//        @unknown default:
//            fatalError()
//        }
//    }
//
//
//
//}
