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
    private var userSession: UserSession?
    private var mqttSession: ISMMQTTSessionWrapper?
    
    private var streams: [ISMStream]?
    
    private var willBeHostUserId: String?
    
    /// If need to add custom profile controller
    private var isCustomProfileView: Bool?
    
    /// if need to add custom ending stream controller
    private var isCustomEndingStreamView: Bool?
    
    /// if need to add custom gift controller
    private var isCustomGiftView: Bool?
    
    /// whether pk battle feature is enabled or not
    private var isPKBattlesEnable: Bool?
    
    private static var sharedInstance : IsometrikSDK!
    
    public static func getInstance()-> IsometrikSDK{
        if sharedInstance == nil {
            sharedInstance = IsometrikSDK(isometrik: IsometrikStream(configuration: ISMConfiguration()))
        }
        return sharedInstance
    }
    
    public func setStreams(streams: [ISMStream]?) {
        self.streams = streams
    }
    
    public func setHostUserId(userId: String){
        self.willBeHostUserId = userId
    }
    
    init(isometrik: IsometrikStream) {
        self.isometrik = isometrik
    }
    
    public func createConfiguration(accountId: String, projectId: String , keysetId: String, licenseKey: String, appSecret: String, userSecret: String, rtcAppId: String , userInfo: ISMStreamUser, isCustomProfileView: Bool = false , isCustomEndingStreamView: Bool = false , isCustomGiftView: Bool = false , isPKBattlesEnable: Bool = false, authToken: String = "",banubaClientToken : String = "", userToken: String = "", userType: UserType = .none, productConfig: ISMProductConfiguration) {
        
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
        ISMConfiguration.shared.accountId = accountId
        ISMConfiguration.shared.projectId = projectId
        ISMConfiguration.shared.keySetId = keysetId
        ISMConfiguration.shared.licensekey = licenseKey
        ISMConfiguration.shared.rtcAppId = rtcAppId
        ISMConfiguration.shared.authToken = authToken
        ISMConfiguration.shared.userToken = userInfo.userToken.unwrap
        ISMConfiguration.shared.userSecret = userSecret
        ISMConfiguration.shared.appSecret = appSecret
        
        // Product Config
        
        ISMConfiguration.shared.storeCategoryId = productConfig.storeCategoryId
        ISMConfiguration.shared.lang = productConfig.lang
        ISMConfiguration.shared.language = productConfig.language
        ISMConfiguration.shared.currencyCode = productConfig.currencyCode
        ISMConfiguration.shared.currencySymbol = productConfig.currencySymbol
            
        //:
        
        let userSession = UserSession()
        userSession.setUserId(userId: userInfo.userId.unwrap)
        userSession.setUserName(userName: userInfo.name.unwrap)
        userSession.setUserImage(userImage: userInfo.imagePath.unwrap)
        userSession.setUserIdentifier(userIdentifier: userInfo.identifier.unwrap)
        userSession.setFirstName(userName: userInfo.firstName.unwrap)
        userSession.setLastName(userName: userInfo.lastName.unwrap)
        userSession.setUserType(userType: userType)
        
        self.isCustomProfileView = isCustomProfileView
        self.isCustomGiftView = isCustomGiftView
        self.isCustomEndingStreamView = isCustomEndingStreamView
        self.isPKBattlesEnable = isPKBattlesEnable
        
        
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
    
    public func getUserSession() -> UserSession {
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
    
    public func isCustomProfileViewAdded() -> Bool {
        if isCustomProfileView == nil {
            fatalError("Create configuration before trying to access custom profile view status.")
        }
        return isCustomProfileView!
    }
    
    public func isCustomEndingStreamViewAdded() -> Bool {
        if isCustomEndingStreamView == nil {
            fatalError("Create configuration before trying to access custom ending view status.")
        }
        return isCustomEndingStreamView!
    }
    
    public func isCustomGiftViewAdded() -> Bool {
        if isCustomGiftView == nil {
            fatalError("Create configuration before trying to access custom gift view status.")
        }
        return isCustomGiftView!
    }
    
    public func isPKBattlesEnabled() -> Bool {
        if isPKBattlesEnable == nil {
            fatalError("Create configuration before trying to access pkBattle status.")
        }
        return isPKBattlesEnable!
    }
    
    func onTerminate() {
        if mqttSession != nil {
            self.mqttSession?.unsubscribeMessaging()
            self.mqttSession?.unsubscribePresenceEvents()
            self.mqttSession?.disconnectMQTT()
            self.mqttSession?.unsubscribeUserEvents()
        }
    }
    
}
