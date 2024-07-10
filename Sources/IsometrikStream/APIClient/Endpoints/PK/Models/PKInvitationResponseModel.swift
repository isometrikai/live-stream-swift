//
//  PKInvitationResponseModel.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 06/12/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import Foundation

public struct ISM_PK_InvitationRepsonse: Codable {
    
    public private(set) var message: String?
    public private(set) var streamData: ISM_PK_Stream?

    enum CodingKeys: String, CodingKey {
        case message
        case streamData
    }
    
}

public struct ISM_PK_Stream: Codable, Hashable {
    
    public var streamId: String?
    public var firstName : String?
    public var lastName: String?
    public var profilePic: String?
    public var streamPic: String?
    public var streamUserId: String?
    public var userId: String?
    public var userName: String?
    public var viewerCount: Int?
    
    public var streamTitle : String?
    public var streamImage: String?
    public var startDateTime: Double?
    public var recordUrl: String?
    public var streamDescription: String?
    public var isRecorded: Bool?
    public var isGroupStream: Bool?
    public var isPublicStream: Bool?
    public var userType: Int?
    public var audioOnly: Bool?
    public var isPaid: Bool?
    public var isStar: Bool?
    public var alreadyPaid: Bool?
    public var isScheduledStream: Bool?
    public var paymentCurrencyCode: String
    public var country: String?
    public var duration: Double?
    public var paymentAmount: Double?
    public var paymentType: Int?
    public var viewersCount: Int?
    public var coinsCount: Int?
    public var userDetails: StreamUserDetails?
    public var type: String?
    public var hdBroadcast: Bool?
    public var restream: Bool?
    public var productsLinked: Bool?
    public var productsCount: Int?
    public var firstUserDetails: ISM_PK_User?
    public var secondUserDetails: ISM_PK_User?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "firstName"
        case lastName = "lastName"
        case profilePic = "profilePic"
        case streamId = "streamId"
        case streamPic = "streamPic"
        case streamUserId = "streamUserId"
        case userId = "userId"
        case userName = "userName"
        case viewerCount = "viewerCount"
        
        case streamTitle
        case streamImage
        case startDateTime
        case recordUrl
        case streamDescription
        case isRecorded
        case isGroupStream
        case isPublicStream
        case userType
        case audioOnly
        case isPaid
        case isStar
        case alreadyPaid
        case isScheduledStream
        case paymentCurrencyCode
        case country
        case duration
        case paymentAmount
        case paymentType
        case viewersCount
        case coinsCount
        case userDetails
        case type
        case hdBroadcast
        case restream
        case productsLinked
        case productsCount
        case firstUserDetails
        case secondUserDetails
    }
    
}

public struct ISM_PK_User: Codable, Hashable {
    
    public var userId: String?
    public var userName: String?
    public var firstName: String?
    public var lastName: String?
    public var profilePic: String?
    public var streamImage: String?
    public var coins: Double?
    public var streamUserId: String?
    public var streamId: String?
    
    enum CodingKeys: String, CodingKey {

        case userId
        case userName
        case firstName
        case lastName
        case profilePic
        case streamImage
        case coins
        case streamUserId = "isometrikUserId"
        case streamId
        
    }
    
    public init(userId: String? = nil,
                userName: String? = nil,
                firstName: String? = nil,
                lastName: String? = nil,
                profilePic: String? = nil,
                streamImage: String? = nil,
                coins: Double? = 0,
                streamUserId: String? = nil,
                streamId: String? = nil){
        self.userId = userId
        self.userName = userName
        self.firstName = firstName
        self.lastName = lastName
        self.profilePic = profilePic
        self.streamImage = streamImage
        self.coins = coins
        self.streamUserId = streamUserId
        self.streamId = streamId
    }
    
    public init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userId =  try? values.decodeIfPresent(String.self, forKey: .userId)
        userName =  try? values.decodeIfPresent(String.self, forKey: .userName)
        firstName =  try? values.decodeIfPresent(String.self, forKey: .firstName)
        lastName =  try? values.decodeIfPresent(String.self, forKey: .lastName)
        profilePic =  try? values.decodeIfPresent(String.self, forKey: .profilePic)
        streamImage =  try? values.decodeIfPresent(String.self, forKey: .streamImage)
        coins =  try? values.decodeIfPresent(Double.self, forKey: .coins)
        streamUserId =  try? values.decodeIfPresent(String.self, forKey: .streamUserId)
        streamId = try? values.decodeIfPresent(String.self, forKey: .streamId)
        
    }
    
    
}

