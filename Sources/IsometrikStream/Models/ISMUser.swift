//
//  User.swift
//  ISOMetrikSDK
//
//  Created by Rahul Sharma on 18/06/21.
//  Copyright © 2021 Appscrip. All rights reserved.
//

import Foundation

public struct ISMUsersData:Codable {
    public private(set) var users:[ISMStreamUser]?
    public private(set) var pageToken:String?
    public private(set) var message:String?
    
    /// Codable keys to confirm Codable protocol
    enum CodingKeys: String, CodingKey {
        case users = "users"
        case pageToken = "pageToken"
        case message = "msg"
        
    }
    
    init(users:[ISMStreamUser],pageToken:String,message:String){
        self.users = users
        self.pageToken = pageToken
        self.message = message
    }
    /// Public initlizer decoder.
    ///
    /// - Parameter decoder: decoder
    /// - Throws: throw error while decoding
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pageToken = try? values.decodeIfPresent(String.self, forKey: .pageToken)
        message = try? values.decodeIfPresent(String.self, forKey: .message)
        users = try? values.decodeIfPresent([ISMStreamUser].self, forKey: .users)
    }
    
    /// Encode user model.
    ///
    /// - Parameter encoder: encoder
    /// - Throws: throws error & exception while converting model
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pageToken, forKey: .pageToken)
        try container.encode(message, forKey: .message)
    }
}
/// Model class for `UserInfo`. Inheriting protocol for `decodable/Encodable`.
public struct ISMStreamUser: Codable {
    public var userId: String?
    public var identifier: String?
    public var name: String?
    public var imagePath: String? = ""
    public var isAHost: Bool?
    public var streamUserId: String?
    public var userToken: String?
    public var rtmpIngestUrl: String?
    
    public var createdAt: Double?
    public var updatedAt: Double?
    public var metaData: UserMetaData?

    public var error: Any?
    public var errorCode: Int?
    public var msg: String?
    
    public var isometrikUserId: String?
    public var firstName: String?
    public var lastName: String?
    public var followStatus: Int?
    public var privacy: Int?
    
    /// Codable keys to confirm Codable protocol
    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case identifier = "user_identifier"
        case name = "user_name"
        case imagePath = "userProfileImageUrl"
        case isAHost = "isAHost"
        case userProfilePic = "userProfilePic"
        case userName = "userName"
        case userIdentifier = "userIdentifier"
        case userToken = "userToken"
        case isometrikUserId
        case updatedAt
        case createdAt
        case rtmpIngestUrl
        case followStatus
        case privacy
    }
    
    /// `Initialization` for user info
    /// - Parameters:
    ///   - userId: Id for user, Type should be **String**
    ///   - identifier: Identifier for user, Type should be **String**
    ///   - name: User name, Type should be **String**
    ///   - imagePath: Path for image, Type should be **String**
    public init(userId: String, isometrikUserId: String = "", identifier: String, name: String, imagePath: String , streamUserId: String? = "", isAHost: Bool = false, userToken: String = "", firstName: String = "", lastName: String = "", followStatus: Int = 0, privacy: Int = 0) {
        self.userId = userId
        self.isometrikUserId = isometrikUserId
        self.identifier = identifier
        self.name = name
        self.imagePath = imagePath
        self.streamUserId = streamUserId
        self.isAHost = isAHost
        self.userToken = userToken
        self.firstName = firstName
        self.lastName = lastName
        self.followStatus = followStatus
        self.privacy = privacy
    }
    
    /// Public initlizer decoder.
    ///
    /// - Parameter decoder: decoder
    /// - Throws: throw error while decoding
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userId = try? values.decodeIfPresent(String.self, forKey: .userId)
        identifier = try? values.decodeIfPresent(String.self, forKey: .identifier)
        name = try? values.decodeIfPresent(String.self, forKey: .name)
        imagePath = try? values.decodeIfPresent(String.self, forKey: .imagePath)
        
        if name == nil{
            name = try? values.decodeIfPresent(String.self, forKey: .userName)
        }
        if identifier == nil{
            identifier = try? values.decodeIfPresent(String.self, forKey: .userIdentifier)
        }
        if imagePath == nil{
            imagePath = try? values.decodeIfPresent(String.self, forKey: .userProfilePic)
        }
        userToken = try? values.decodeIfPresent(String.self, forKey: .userToken)
        
        updatedAt = try? values.decodeIfPresent(Double.self, forKey: .updatedAt)
        createdAt = try? values.decodeIfPresent(Double.self, forKey: .createdAt)
        isometrikUserId = try? values.decodeIfPresent(String.self, forKey: .isometrikUserId)
        rtmpIngestUrl = try? values.decodeIfPresent(String.self, forKey: .rtmpIngestUrl)
        followStatus = try? values.decodeIfPresent(Int.self, forKey: .followStatus)
        privacy = try? values.decodeIfPresent(Int.self, forKey: .privacy)
    }
    
    /// Encode user model.
    ///
    /// - Parameter encoder: encoder
    /// - Throws: throws error & exception while converting model
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(name, forKey: .name)
        try container.encode(imagePath, forKey: .imagePath)
        try container.encode(userToken, forKey: .userToken)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(createdAt, forKey: .createdAt)
    }
    
    init(from data: [String: Any]) {
        
        if let userId = data["userId"] as? String{
            self.userId = userId
        }
        
        if let identifire = data["identifire"] as? String{
            self.identifier = identifire
        }
        
        if let name = data["name"] as? String{
            self.name = name
        }
        
        if let imagePath = data["imagePath"] as? String{
            self.imagePath = imagePath
        }
        
        if let isHost = data["isHost"] as? Bool{
            self.isAHost = isHost
        }
    }
}




