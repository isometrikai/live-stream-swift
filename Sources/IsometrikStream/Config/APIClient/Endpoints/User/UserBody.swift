//
//  UserBody.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 10/11/22.
//

import Foundation

public struct UserBody: Codable, Hashable {
    
    private let userName: String
    private let userId: String
    private let userIdentifier: String
    private let userProfileImageUrl: String
    private let password: String?
    private let notification: Bool
    private let metaData: UserMetaData
    
    init(userName: String = "", userId: String = "", userIdentifier: String = "", imagePath: String = "", password: String? = nil, metaData: UserMetaData = UserMetaData(country: "India"), enableNotification: Bool = true) {
        self.userId = userId
        self.userName = userName
        self.userProfileImageUrl = imagePath
        self.password = password
        self.userIdentifier = userIdentifier
        self.metaData = metaData
        self.notification = enableNotification
    }
    
}

public struct UserMetaData: Codable, Hashable {
    
    private let country: String
    
    init(country: String) {
        self.country = country
    }
    
}
