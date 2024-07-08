//
//  ISMPublisher.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 14/06/22.
//

import Foundation

public struct ISMPublisher: Codable {
    public private(set) var msg: String?
    public private(set) var pending: Bool?
    public private(set) var accepted: Bool?
    public private(set) var errorCode: Int?
    public private(set) var error: String?
    public private(set) var pageToken: String?
    public var requests: [ISMRequest]?
    public private(set) var rtcToken: String?
    
    enum CodingKeys: String, CodingKey {
        case msg = "message"
        case pending
        case accepted
        case error
        case errorCode
        case pageToken
        case requests = "copublishRequests"
        case rtcToken
    }
    public init(message: String, accepted: Bool, pending: Bool, error: String, errorCode: Int, pageToken: String, requests: [ISMRequest], rtcToken: String = "") {
        self.msg = message
        self.accepted = accepted
        self.pending = pending
        self.error = error
        self.errorCode = errorCode
        self.pageToken = pageToken
        self.requests = requests
        self.rtcToken = rtcToken
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        msg = try? values.decodeIfPresent(String.self, forKey: .msg)
        pending = try? values.decodeIfPresent(Bool.self, forKey: .pending)
        accepted = try? values.decodeIfPresent(Bool.self, forKey: .accepted)
        error = try? values.decodeIfPresent(String.self, forKey: .error)
        errorCode = try? values.decodeIfPresent(Int.self, forKey: .errorCode)
        pageToken = try? values.decodeIfPresent(String.self, forKey: .pageToken)
        requests = try? values.decodeIfPresent([ISMRequest].self, forKey: .requests)
        rtcToken = try? values.decodeIfPresent(String.self, forKey: .rtcToken )
    }
}

public struct ISMRequest: Codable {
    public private(set) var userProfilePic: String?
    public private(set) var userName: String?
    public private(set) var userIdentifier: String?
    public private(set) var userId: String?
    public private(set) var requestTime: Double?
    public private(set) var pending: Bool? = nil
    public private(set) var accepted: Bool? = nil
    public private(set) var streamId: String?
    
    enum CodingKeys: String, CodingKey {
        case userProfilePic = "userProfileImageUrl"
        case userName
        case pending
        case accepted
        case userId
        case userIdentifier
        case requestTime = "timestamp"
        case streamId
    }
    public init(userProfilePic: String, userName: String, pending: Bool?, accepted: Bool?, userId: String, userIdentifier: String, requestTime: Double, streamId: String) {
        self.userProfilePic = userProfilePic
        self.userName = userName
        self.pending = pending
        self.accepted = accepted
        self.userId = userId
        self.userIdentifier = userIdentifier
        self.requestTime = requestTime
        self.streamId = streamId
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userProfilePic = try? values.decodeIfPresent(String.self, forKey: .userProfilePic)
        userName = try? values.decodeIfPresent(String.self, forKey: .userName)
        pending = try? values.decodeIfPresent(Bool.self, forKey: .pending)
        accepted = try? values.decodeIfPresent(Bool.self, forKey: .accepted)
        userId = try? values.decodeIfPresent(String.self, forKey: .userId)
        userIdentifier = try? values.decodeIfPresent(String.self, forKey: .userIdentifier)
        requestTime = try? values.decodeIfPresent(Double.self, forKey: .requestTime)
        streamId = try? values.decodeIfPresent(String.self, forKey: .streamId)
        
    }
}

public struct ProfileSwitched {
    public var streamId: String?
    public var viewersCount: Int?
    public var userProfilePic: String?
    public var timeStamp: String?
    public var action: String?
    public var membersCount: Int?
    public var userId: String?
    public var userName: String?
    public var userIdentifier: String?
}

public struct ISMPublishStatus: Codable {
    public var rtcToken: String?
    public var msg: String?
    public var isModerator: Bool?
    public var error: String?
    public var errorCode: String?
}
