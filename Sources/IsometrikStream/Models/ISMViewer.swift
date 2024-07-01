//
//  ISMViewer.swift
//  ISOMetrikSDK
//
//  Created by Rahul Sharma on 18/06/21.
//  Copyright © 2021 Appscrip. All rights reserved.
//

import Foundation

/// Model class for `ViewerInfo`. Inheriting protocol for `decodable/Encodable`.

public struct ISMViewersData:Codable {
    public private(set) var viewers:[ISMViewer]?
    public private(set) var pageToken:String?
    public private(set) var message:String?
    public private(set) var totalCount: Int?

    /// Codable keys to confirm Codable protocol
    enum CodingKeys: String, CodingKey {
        case viewers = "viewers"
        case pageToken = "pageToken"
        case message = "msg"
        case totalCount = "viewersCount"
    }

}

public struct ISMViewer: Codable, Equatable, Hashable {
    public private(set) var viewerId: String?
    public private(set) var viewerUserId: String?
    public private(set) var identifier: String?
    public private(set) var name: String?
    public private(set) var imagePath: String?
    public private(set) var joinTime: Int64?
    public private(set) var streamUserId: String?
    public var isFollow: Int?
    public var isPrivate: Bool?
    public private(set) var coinsSent: Int?
    
    /// Codable keys to confirm Codable protocol
    enum CodingKeys: String, CodingKey {
        case viewerId = "userId"
        case viewerUserId
        case identifier = "viewerIdentifier"
        case name = "userName"
        case imagePath = "userProfileImageUrl"
        case joinTime = "sessionStartTime"
        case streamUserId
        
        case joinTimestamp
        case coinsSent
        case isFollow = "isFollow"
        case isPrivate
    }
    
    /// `Initialization` for viewer info
    /// - Parameters:
    ///   - viewerId: Id for viewer, Type should be **String**
    ///   - identifier: Identifier for viewer, Type should be **String**
    ///   - name: User name, Type should be **String**
    ///   - imagePath: Path for image, Type should be **String**
    ///   - joinTime: viewer join time, Type should be **Int64**
    public init(viewerId: String,
                identifier: String? = nil,
                name: String,
                imagePath: String? = nil,
                joinTime: Int64? = nil,
                streamUserId: String? = nil,
                isFollow: Int? = nil) {
        self.viewerId = viewerId
        self.identifier = identifier
        self.name = name
        self.imagePath = imagePath
        self.joinTime = joinTime
        self.streamUserId = streamUserId
        self.isFollow = isFollow
    }
    
    /// Public initlizer decoder.
    ///
    /// - Parameter decoder: decoder
    /// - Throws: throw error while decoding
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        viewerId = try? values.decodeIfPresent(String.self, forKey: .viewerId)
        viewerUserId = try? values.decodeIfPresent(String.self, forKey: .viewerUserId)
        identifier = try? values.decodeIfPresent(String.self, forKey: .identifier)
        name = try? values.decodeIfPresent(String.self, forKey: .name)
        imagePath = try? values.decodeIfPresent(String.self, forKey: .imagePath)
        streamUserId = try? values.decodeIfPresent(String.self, forKey: .streamUserId)
        isFollow = try? values.decodeIfPresent(Int.self, forKey: .isFollow)
        
        joinTime = try? values.decodeIfPresent(Int64.self, forKey: .joinTime)
        if joinTime == nil {
            joinTime = try? values.decodeIfPresent(Int64.self, forKey: .joinTimestamp)
        }
        
        coinsSent = try? values.decodeIfPresent(Int.self, forKey: .coinsSent)
    }
    
    /// Encode user model.
    ///
    /// - Parameter encoder: encoder
    /// - Throws: throws error & exception while converting model
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(viewerId, forKey: .viewerId)
        try? container.encode(viewerUserId, forKey: .viewerUserId)
        try? container.encode(identifier, forKey: .identifier)
        try? container.encode(name, forKey: .name)
        try? container.encode(imagePath, forKey: .imagePath)
        try? container.encode(joinTime, forKey: .joinTime)
        try? container.encode(isFollow, forKey: .isFollow)
        try? container.encode(streamUserId, forKey: .streamUserId)
    }
    
    public static func == (lhs: ISMViewer, rhs: ISMViewer) -> Bool {
        return lhs.viewerId == rhs.viewerId
    }
}

public struct ISMViewerCount: Codable {
    public let numberOfViewers: Int?
    public let msg: String?
    public let error: String?
    public let errorCode: Int?
}
