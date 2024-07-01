//
//  UserSession.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 10/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

public enum UserType {
    case viewer
    case host
    case member
    case moderator
    case guest
    case none
}

public enum PkBattleStatus {
    case on
    case off
}

public class UserSession: NSObject {
    
    private var userType: UserType = .none
    private var memberForPK: Bool = false
    private var pkBattleStatus: PkBattleStatus = .off
    private var pkBattleId: String = ""
    private var isRTMPStream: Bool = false
    private var currentStreamData: ISMStream?
    
    public static var shared = UserSession()
    
    // MARK: - SETTERS
    
    public func setUserId(userId: String){
        UserDefaults.standard.set(userId, forKey: ISM_AppConstants.userdefaultUserIdKey)
    }
    
    public func setUserImage(userImage: String){
        UserDefaults.standard.set(userImage, forKey: ISM_AppConstants.userdefaultUserImage)
    }
    
    public func setUserIdentifier(userIdentifier: String){
        UserDefaults.standard.set(userIdentifier, forKey: ISM_AppConstants.userdefaultUserIdentifier)
    }
    
    public func setUserName(userName: String){
        UserDefaults.standard.set(userName, forKey: ISM_AppConstants.userdefaultUserName)
    }
    
    public func setFirstName(userName: String){
        UserDefaults.standard.set(userName, forKey: ISM_AppConstants.userdefaultFirstName)
    }
    
    public func setLastName(userName: String){
        UserDefaults.standard.set(userName, forKey: ISM_AppConstants.userdefaultLastName)
    }
    
    public func setUserType(userType: UserType) {
        self.userType = userType
    }
    
    public func setPKStatus(pkBattleStatus: PkBattleStatus) {
        self.pkBattleStatus = pkBattleStatus
    }
    
    public func setPKBattleId(pkId: String) {
        self.pkBattleId = pkId
    }
    
    public func setCurrentStreamData(streamData: ISMStream?) {
        self.currentStreamData = streamData
    }
    
    public func setUserToken(userToken: String) {
        UserDefaults.standard.set(userToken, forKey: ISM_AppConstants.userdefaultUserToken)
    }
    
    public func setMemberForPKStatus(_ status: Bool) {
        self.memberForPK = status
    }
    
    public func setRTMPStreamStatus(_ status: Bool) {
        self.isRTMPStream = status
    }
    
    // MARK: - GETTERS
    
    public func getUserId() -> String {
        guard let userId = UserDefaults.standard.string(forKey: ISM_AppConstants.userdefaultUserIdKey) else { return "" }
        return userId
    }
    
    public func getUserImage() -> String {
        guard let userImage = UserDefaults.standard.string(forKey: ISM_AppConstants.userdefaultUserImage), !userImage.isEmpty else { return "https://cdn.getfudo.com/adminAssets/0/0/Logo.png" }
        return userImage
    }
    
    public func getUserIdentifier() -> String {
        guard let userIdentifier = UserDefaults.standard.string(forKey: ISM_AppConstants.userdefaultUserIdentifier) else { return "" }
        return userIdentifier
    }
    
    public func getUserName() -> String {
        guard let userIdentifier = UserDefaults.standard.string(forKey: ISM_AppConstants.userdefaultUserName) else { return "" }
        return userIdentifier
    }
    
    public func getFirstName() -> String {
        guard let userIdentifier = UserDefaults.standard.string(forKey: ISM_AppConstants.userdefaultFirstName) else { return "" }
        return userIdentifier
    }
    
    public func getLastName() -> String {
        guard let userIdentifier = UserDefaults.standard.string(forKey: ISM_AppConstants.userdefaultLastName) else { return "" }
        return userIdentifier
    }
    
    public func getUserToken() -> String {
        guard let userToken = UserDefaults.standard.string(forKey: ISM_AppConstants.userdefaultUserToken) else { return "" }
        return userToken
    }
    
    public func getUserType() -> UserType {
        self.userType
    }
    
    public func getPKStatus() -> PkBattleStatus {
        self.pkBattleStatus
    }
    
    public func getPKBattleId() -> String {
        self.pkBattleId
    }
    
    public func getCurrentStreamData() -> ISMStream? {
        return currentStreamData
    }
    
    public func getMemberForPKStatus() -> Bool {
        return memberForPK
    }
    
    public func getRTMPStatus() -> Bool {
        return isRTMPStream
    }
    
    // MARK: - DEFAULTS
    
    public func clearUserSession(){
        UserDefaults.standard.removeObject(forKey: ISM_AppConstants.userdefaultUserIdKey)
        UserDefaults.standard.removeObject(forKey: ISM_AppConstants.userdefaultUserImage)
        UserDefaults.standard.removeObject(forKey: ISM_AppConstants.userdefaultUserIdentifier)
        UserDefaults.standard.removeObject(forKey: ISM_AppConstants.userdefaultUserName)
        UserDefaults.standard.removeObject(forKey: ISM_AppConstants.userdefaultUserToken)
    }
    
    public func switchUser(userId: String, userImage: String, userIdentifier: String, userName: String, userToken: String = ""){
        UserDefaults.standard.set(userId, forKey: ISM_AppConstants.userdefaultUserIdKey)
        UserDefaults.standard.set(userImage, forKey: ISM_AppConstants.userdefaultUserImage)
        UserDefaults.standard.set(userIdentifier, forKey: ISM_AppConstants.userdefaultUserIdentifier)
        UserDefaults.standard.set(userName, forKey: ISM_AppConstants.userdefaultUserName)
        UserDefaults.standard.set(userToken, forKey: ISM_AppConstants.userdefaultUserToken)
    }
    
    public func getUserModel() -> ISMStreamUser {
        return ISMStreamUser(userId: getUserId(), identifier: getUserIdentifier(), name: getUserName(), imagePath: getUserImage(), userToken: getUserToken())
    }
    
    
}
