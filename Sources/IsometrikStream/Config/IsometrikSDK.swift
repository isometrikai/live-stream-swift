//
//  IsometrikSDK.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 29/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

public class IsometrikSDK {
    
    private var isometrik: IsometrikStream
    private var userSession: IsometrikUserSession?
    private var mqttSession: ISMMQTTSessionWrapper?
    private var streamOptionsConfiguration: ISMOptionsConfiguration?
    
    private static var sharedInstance : IsometrikSDK!
    
    private var streams: [ISMStream]?
    private var willBeHostUserId: String?
    
    public static func getInstance()-> IsometrikSDK{
        if sharedInstance == nil {
            sharedInstance = IsometrikSDK(isometrik: IsometrikStream(configuration: ISMConfiguration.shared))
        }
        return sharedInstance
    }
    
    init(isometrik: IsometrikStream) {
        self.isometrik = isometrik
    }
    
    public func createConfiguration(
        accountId: String,
        projectId: String,
        keysetId: String, 
        licenseKey: String,
        appSecret: String,
        userSecret: String,
        rtcAppId: String ,
        userInfo: ISMStreamUser,
        banubaClientToken : String = "",
        userToken: String = "",
        userType: UserType = .none,
        streamOptionsConfiguration: ISMOptionsConfiguration =  ISMOptionsConfiguration(enableProfileDelegate: false, enableGroupStream: false, enablePKStream: false, enableProductInStream: false, enableRTMPStream: false, enablePaidStream: false, enableRestream: false, enableScheduleStream: false)
    ) {
        
        if accountId.isEmpty {
            fatalError("Pass a valid accountId for isometrik sdk initialization.")
        } else if projectId.isEmpty {
            fatalError("Pass a valid projectId for isometrik sdk initialization.")
        } else if keysetId.isEmpty {
            fatalError("Pass a valid keysetId for isometrik sdk initialization.")
        } else if licenseKey.isEmpty {
            fatalError("Pass a valid licenseKey for isometrik sdk initialization.")
        } else if rtcAppId.isEmpty {
            fatalError("Pass a valid rtcAppId for isometrik sdk initialization.")
        }
        
        let configuration = ISMConfiguration.shared
        
        configuration.updateConfig(
            licenseKey: licenseKey,
            accountId: accountId,
            projectId: projectId,
            keySetId: keysetId,
            appSecret: appSecret,
            userSecret: userSecret,
            rtcToken: "",
            userToken: userInfo.userToken.unwrap,
            rtcAppId: rtcAppId
        )
        
        let userSession = IsometrikUserSession()
        userSession.setUserId(userId: userInfo.userId.unwrap)
        userSession.setUserName(userName: userInfo.name.unwrap)
        userSession.setUserImage(userImage: userInfo.imagePath.unwrap)
        userSession.setUserIdentifier(userIdentifier: userInfo.identifier.unwrap)
        userSession.setFirstName(userName: userInfo.firstName.unwrap)
        userSession.setLastName(userName: userInfo.lastName.unwrap)
        userSession.setUserType(userType: userType)
        
        self.streamOptionsConfiguration = streamOptionsConfiguration
        self.isometrik = IsometrikStream(configuration: configuration)
        self.userSession = userSession
        
        let mqttSession = ISMMQTTSessionWrapper(configuration: configuration)
        mqttSession.establishConnection(withUserId: userSession.getUserId())
        self.mqttSession = mqttSession
        
    }
    
    
    public func getStreams() -> [ISMStream]? {
        return self.streams
    }
    
    public func getHostUserId() -> String {
        return self.willBeHostUserId ?? ""
    }
    
    public func getUserSession() -> IsometrikUserSession {
        if userSession == nil {
            fatalError("Create configuration before trying to access user session object.")
        }
        return userSession!
    }
    
    public func getMqttSession() -> ISMMQTTSessionWrapper {
        if mqttSession == nil {
            fatalError("Create configuration before trying to access mqtt session object.")
        }
        return mqttSession!
    }
    
    public func getIsometrik() -> IsometrikStream {
        return isometrik
    }
    
    public func getStreamOptionsConfiguration() -> ISMOptionsConfiguration {
        if streamOptionsConfiguration == nil {
            return ISMOptionsConfiguration()
        }
        return streamOptionsConfiguration!
    }
    
    public func setStreams(streams: [ISMStream]?) {
        self.streams = streams
    }
    
    public func setHostUserId(userId: String){
        self.willBeHostUserId = userId
    }
    
    public func onTerminate() {
        
        if mqttSession != nil {
            self.mqttSession?.unsubscribePresenceEvents()
            self.mqttSession?.disconnectMQTT()
            self.mqttSession?.unsubscribeUserEvents()
        }
        
        // removing user defaults
        UserDefaultsProvider.shared.removeUserDefaults()
        
        // reseting singletons
        ISMLogManager.shared.isLoggingEnabled = true
        
        userSession = nil
        mqttSession = nil
        streamOptionsConfiguration = nil
        streams = nil
        willBeHostUserId = nil
        
    }
    
}
