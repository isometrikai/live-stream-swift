//
//  ISMMQTTEnum.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 14/11/22.
//

import Foundation

extension Notification.Name {
    public static let didPublishTrackNotification = Notification.Name("didPublishTrackNotification")
}

/// MQTT data Type
public enum ISMMQTTNotificationType: String {
    case mqttMessageSent = "MQTTmessageSent"
    case mqttMessageReplySent = "MQTTmessageReplySent"
    case mqttMessageRemoved = "MQTTmessageRemoved"
    case mqttMessageReplyRemoved = "MQTTmessageReplyRemoved"
    case mqttStreamStarted = "MQTTstreamStarted"
    case mqttStreamStopped = "MQTTstreamStopped"
    case mqttMemberAdded = "MQTTmemberAdded"
    case mqttMemberLeft = "MQTTmemberLeft"
    case mqttProfileSwitched = "MQTTprofileSwithed"
    case mqttMemberRemoved = "MQTTmemberRemoved"
    case mqttViewerJoined = "MQTTviewerJoined"
    case mqttViewerRemoved = "MQTTviewerRemoved"
    case mqttViewerTimeout = "MQTTviewerTimeout"
    case mqttPublishStarted = "MQTTpublishStarted"
    case mqttPublishStopped = "MQTTpublishStopped"
    case mqttPublisherTimeout = "MQTTpublisherTimeout"
    case mqttViewerRemovedByInitiator = "MQTTviewerRemovedByInitiator"
    case mqttRequestToBeCoPublisherAdded = "MQTTRequestToBeCoPublisherAdded"
    case mqttCopublishRequestAccepted = "MQTTCopublishRequestAccepted"
    case mqttRequestToBeCoPublisherRemoved = "MQTTRequestToBeCoPublisherRemoved"
    case mqttCopublishRequestDenied = "MQTTCopublishRequestDenied"
    case mqttStreamStartedPresence = "MQTTStreamStartedPresence"
    case mqttModeratorAdded = "MQTTModeratorAdded"
    case mqttModeratorRemoved = "MQTTModeratorRemoved"
    case mqttModeratorLeft = "MQTTModeratorLeft"
    case mqttPubsubMessagePublished = "MQTTPubsubMessagePublished"
    case mqttPubsubDirectMessagePublished = "MQTTPubsubDirectMessagePublished"
    case mqttPubsubMessageOnTopicPublished = "MQTTPubsubMessageOnTopicPublished"
    
    public var name: Notification.Name {
        return Notification.Name(rawValue: self.rawValue)
    }
}

/// MQTT Data.
public enum MQTTData {
    case mqttMessageSent
    case mqttMessageReplySent
    case mqttMessageRemoved
    case mqttMessageReplyRemoved
    case mqttStreamStarted
    case mqttStreamStopped
    case mqttMemberAdded
    case mqttMemberLeft
    case mqttProfileSwitched
    case mqttMemberRemoved
    case mqttViewerJoined
    case mqttViewerRemoved
    case mqttViewerTimeout
    case mqttPublishStarted
    case mqttPublishStopped
    case mqttPublisherTimeout
    case mqttModeratorAdded
    case mqttModeratorRemoved
    case mqttviewerRemovedByInitiator
    case mqttRequestToBeCoPublisherAdded
    case mqttRequestToBeCoPublisherRemoved
    case mqttCopublishRequestDenied
    case mqttCopublishRequestAccepted
    case mqttStreamStartedPresence
    case mqttModeratorLeft
    case mqttPubsubMessagePublished
    case mqttPubsubDirectMessagePublished
    case mqttPubsubMessageOnTopicPublished
    case none
    
    static func dataType(_ type: String) -> MQTTData {
        switch type {
        case "messageSent": return .mqttMessageSent
        case "messageReplySent": return .mqttMessageReplySent
        case "messageRemoved": return .mqttMessageRemoved
        case "messageReplyRemoved": return .mqttMessageReplyRemoved
        case "streamStarted": return .mqttStreamStarted
        case "streamStopped": return .mqttStreamStopped
        case "memberAdded": return .mqttMemberAdded
        case "memberLeft": return .mqttMemberLeft
        case "memberRemoved": return .mqttMemberRemoved
        case "viewerJoined": return .mqttViewerJoined
        case "viewerLeft": return .mqttViewerRemoved
        case "viewerTimeout": return .mqttViewerTimeout
        case "publishStarted": return .mqttPublishStarted
        case "publishStopped": return .mqttPublishStopped
        case "publisherTimeout": return .mqttPublisherTimeout
        case "viewerRemoved": return .mqttviewerRemovedByInitiator
        case "copublishRequestAdded": return .mqttRequestToBeCoPublisherAdded
        case "copublishRequestAccepted": return .mqttCopublishRequestAccepted
        case "copublishRequestDenied": return .mqttCopublishRequestDenied
        case "copublishRequestRemoved": return .mqttRequestToBeCoPublisherRemoved
        case "profileSwitched": return .mqttProfileSwitched
        case "streamStartPresence": return .mqttStreamStartedPresence
        case "moderatorAdded": return .mqttModeratorAdded
        case "moderatorRemoved": return .mqttModeratorRemoved
        case "moderatorLeft": return .mqttModeratorLeft
        case "pubsubMessagePublished": return .mqttPubsubMessagePublished
        case "pubsubDirectMessagePublished": return .mqttPubsubDirectMessagePublished
        case "pubsubMessageOnTopicPublished": return .mqttPubsubMessageOnTopicPublished
        default: return .none
        }
    }
}

public enum MqttResult<T> {
    case success(T)
    case failure(IsometrikError)
}
