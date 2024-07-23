//
//  Stream.swift
//  ISOMetrikSDK
//
//  Created by Rahul Sharma on 18/06/21.
//  Copyright © 2021 Appscrip. All rights reserved.
//

import UIKit

public enum LiveStreamStatus: String {
    case ended = "ENDED"
    case started = "STARTED"
    case scheduled = "SCHEDULED"
}

public struct ISMStreamsData:Codable {
    public private(set) var streams:[ISMStream]?
    public private(set) var pageToken:String?
    public private(set) var message:String?
    public private (set)var totalCount : Int?
    public var errorCode: Int?
    public var error: String?
    
    
    /// Codable keys to confirm Codable protocol
    enum CodingKeys: String, CodingKey {
        case streams = "streams"
        case pageToken = "pageToken"
        case message = "msg"
        case totalCount = "totalCount"
        
    }
    
    /// Public initlizer decoder.
    ///
    /// - Parameter decoder: decoder
    /// - Throws: throw error while decoding
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pageToken = try? values.decodeIfPresent(String.self, forKey: .pageToken)
        message = try? values.decodeIfPresent(String.self, forKey: .message)
        streams = try? values.decodeIfPresent([ISMStream].self, forKey: .streams)
        totalCount = try? values.decodeIfPresent(Int.self, forKey: .totalCount)
    }
    
    /// Encode user model.
    ///
    /// - Parameter encoder: encoder
    /// - Throws: throws error & exception while converting model
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pageToken, forKey: .pageToken)
        try container.encode(message, forKey: .message)
        try container.encode(totalCount, forKey: .totalCount)
    }
}

public struct ISMSingleStream: Codable {
    public private(set) var streams:ISMStream?
    public private (set)var totalCount : Int?
    public var errorCode: Int?
    public var error: String?
    public private(set) var message:String?
    
    
    /// Codable keys to confirm Codable protocol
    enum CodingKeys: String, CodingKey {
        case streams = "streams"
        case message = "msg"
        case totalCount = "totalCount"
        
    }
    
    /// Public initlizer decoder.
    ///
    /// - Parameter decoder: decoder
    /// - Throws: throw error while decoding
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decodeIfPresent(String.self, forKey: .message)
        streams = try? values.decodeIfPresent(ISMStream.self, forKey: .streams)
        totalCount = try? values.decodeIfPresent(Int.self, forKey: .totalCount)
    }
}

public struct ISMStream: Codable {
    
    public var audioOnly : Bool?
    public var hdBroadcast: Bool?
    public var streamId: String?
    public var viewersCount: Int64?
    public var streamImage: String?
    public var streamPreviewUrl: String?
    public var initiatorimage: String?
    public var streamDescription: String?
    public var startTime: Int64?
    public var endDateTime: Int64?
    public var joinTimeStamp: Int?
    public var isPublicStream: Bool?
    public var isGroupStream: Bool?
    public var lowLatencyMode: Bool?
    public var enableRecording: Bool?
    public var streamLength: Int?
    public var membersPublishingCount: Int64?
    public var membersCount: Int64?
    public var memberIds: [String]?
    public var initiatorName: String?
    public var createdBy: String?
    public var initiatorId: String?
    public var initiatorIdentifier: String?
    public var members: [ISMMember]?
    public var viewers: [ISMViewer]?
    public var rtcToken: String?
    public var multiLive: Bool?
    public var streamKey: String?
    public var ingestEndpoint: String?
    public var playbackUrl: String?
    public var childParentIds : [[String : String]]?
    public var restreamChannelCount: Int?
    public var restreamEndpoints: [String]?
    public var restream: Bool?
    public var productsLinked: Bool?
    public var productsCount: Int?
    public var isPkChallenge: Bool?
    public var pkId: String?
    public var isModerator: Bool?
    public var pkInviteId: String?
    public var selfHosted: Bool?
    public var canPublish: Bool?
    
    public var isRecorded: Bool?
    public var rtmpIngest: Bool?
    public var persistRtmpIngestEndpoint: Bool?
    public var taggedProductIds: [String]?
    
    
    // NOTE: - This is Temperory fix (change later)
    
    public var streamInfo : StreamInfo?
    public var userDetails : StreamUserDetails?
    public let duration : Int?
    public let alreadyPaid : Bool?
    public let coinsCount : Int?
    public let country : String?
    public var isPaid : Bool?
    public var isBuy: Bool?
    public let scheduleStartTime: Double?
    public let isScheduledStream : Bool?
    public var amount : Double?
    public let paymentCurrencyCode : String?
    public let paymentType : Int?
    public let streamTags : [String]?
    public let streamTypes : [Int]?
    public let type : String?
    public let userType : Int?
    public let appUserId : String?
    public var firstUserDetails: ISM_PK_User?
    public var secondUserDetails: ISM_PK_User?
    public var isometrikUserID: String?
    public var id: String?
    public var isRsvp: Bool?
    
    //:
    
    /// Changables
    public var streamTitle : String?
    public var saleType: Int?
    public var pinProductDetails: ISMPinProductDetails?
    public var recordedUrl: [String]?
    public let isStreamActive: Bool?
    public var status: String = "STARTED"
    public let storeId: String?
    public let products: [ISMProductToBeTagged]?
    public let otherProducts: [ISMOthersProductToBeTagged]?
    public var _id: String?
    public var recordViewCount: Int?
    public var metaData: StreamMetaData?

    /// Codable keys to confirm Codable protocol
    enum CodingKeys: String, CodingKey {
        case audio_only = "audio_only"
        case restreamEndpoints = "restreamEndpoints"
        case streamId
        case streamKey
        case ingestEndpoint = "ingestEndpoint"
        case viewers = "viewers"
        case stream_image = "stream_image"
        case streamPreviewUrl
        case stream_description = "stream_description"
        case start_time = "start_time"
        case joinTimeStamp = "join_time_stamp"
        case streamLength = "stream_length" //M
        case membersPublishingCount = "membersPublishing"
        case membersCount
        case memberIds = "members" //M
        case initiatorName = "initiatorName" //M
        case createdBy = "createdBy"
        case initiatorimage = "initiatorImage"
        case initiatorId = "initiator_id" //M
        case startTime = "startTime" //M
        case endDateTime
        case streamTitle
        case rtcToken = "rtcToken"
        case multiLive = "multiLive"
        case childParentIds = "productIds"
        case playbackUrl = "playbackUrl"
        case initiatorIdentifier
        case restreamChannelCount = "restream_channels_count"
        case restream
        case productsLinked = "products_linked"
        case productsCount
        case isPkChallenge
        case pkId
        case isModerator
        case pkInviteId
        case hdBroadcast
        case recordedUrl
        case isRecorded
        

        case canPublish
        case selfHosted
        case audioOnly
        case userId
        case isGroupStream
        case isPublicStream
        case startDateTime
        case streamDescription
        case streamImage
        case viewersCount
        case streamInfo
        case userDetails
        
        // NOTE: - This is Temperory fix (change later)
        
        case duration
        case alreadyPaid
        case isBuy
        case coinsCount
        case country
        case isPaid
        case isScheduledStream
        case scheduleStartTime
        case amount
        case paymentCurrencyCode
        case paymentType
        case streamTags
        case streamTypes
        case type
        case userType
        case firstUserDetails
        case secondUserDetails
        case isometrikUserID
        case pinProductDetails
        case saleType
        case id
        case appUserId
        
        case rtmpIngest
        case persistRtmpIngestEndpoint
        case isStreamActive
        case status
        case lowLatencyMode
        case enableRecording
        case taggedProductIds
        case storeId
        case products
        case otherProducts
        case _id
        case isRsvp
        case recordViewCount
        case metaData
        
        //:

    }
    
    
    /// `Initialization` for stream info
    /// - Parameters:
    ///   - streamId: Current stream id, Type should be *String*.
    ///   - viewersCount: Count of stream viewers, Type can be *Int64* or nil.
    ///   - streamImage: Image of stream, Type can be *String* or nil.
    ///   - streamDescription: Description of stream, Type can be *String* or nil.
    ///   - startTime: Stream start time, Type can be *String* or nil.
    ///   - membersPublishingCount: Stream member count, Type can be *String* or nil.
    ///   - membersCount: Stream member count, Type can be *String* or nil.
    ///   - memberIds: Stream member ids, Type can be *[String]* or nil.
    ///   - initiatorName: Name of Initiator, Type can be *String* or nil.
    ///   - createdBy: Create by id, Type can be *String* or nil.
    public init(streamId: String,
                viewersCount: Int64? = nil,
                streamImage: String? = nil,
                streamPreviewUrl: String? = nil,
                streamDescription: String? = nil,
                startTime: Int64? = nil,
                membersPublishingCount: Int64? = nil,
                membersCount: Int64? = nil,
                memberIds: [String]? = nil,
                initiatorName: String? = nil,
                createdBy: String? = nil,
                members: [ISMMember] = [],
                viewers: [ISMViewer] = [],
                initiatorimage: String? = nil,
                initiatorId: String? = nil,
                streamKey: String? = nil,
                ingestEndpoint: String? = nil,
                playbackUrl: String? = nil,
                multiLive: Bool? = false,
                rtcToken: String? = nil,
                restreamChannelCount: Int? = nil,
                restream: Bool? = false,
                productsLinked: Bool? = false,
                productsCount: Int? = nil,
                initiatorIdentifier: String? = nil,
                audioOnly: Bool? = nil,
                userDetails: StreamUserDetails? = nil,
                
                duration: Int? = nil,
                alreadyPaid: Bool? = nil,
                isBuy: Bool? = nil,
                coinsCount: Int? = nil,
                country: String? = nil,
                isPaid: Bool? = nil,
                isScheduledStream: Bool? = nil,
                scheduleStartTime: Double? = nil,
                amount : Double? = nil,
                paymentCurrencyCode : String? = nil,
                paymentType : Int? = nil,
                streamTags : [String]? = nil,
                streamTypes : [Int]? = nil,
                type : String? = nil,
                userType : Int? = nil,
                isPkChallenge: Bool? = nil,
                firstUserDetails: ISM_PK_User? = nil,
                secondUserDetails: ISM_PK_User? = nil,
                isModerator: Bool = false,
                pkInviteId: String = "",
                restreamEndpoints: [String] = [],
                hdBroadcast: Bool = false,
                isometrikUserID: String = "",
                appUserId: String = "",
                saleType: Int = 1,
                rtmpIngest: Bool = false,
                persistRtmpIngestEndpoint: Bool = false,
                isRecorded: Bool = false,
                isStreamActive: Bool = false,
                status: String = "",
                lowLatencyMode: Bool = false,
                enableRecording: Bool = false,
                taggedProductIds: [String] = [],
                storeId: String = "",
                products: [ISMProductToBeTagged]? = nil,
                otherProducts: [ISMOthersProductToBeTagged]? = nil,
                _id: String = "",
                isRsvp: Bool = false,
                recordViewCount: Int = 0
                
    ) {
        self.initiatorId = initiatorId
        self.streamId = streamId
        self.viewersCount = viewersCount
        self.streamImage = streamImage
        self.streamPreviewUrl = streamPreviewUrl
        self.streamDescription = streamDescription
        self.startTime = startTime
        self.membersPublishingCount = membersPublishingCount
        self.membersCount = membersCount
        self.memberIds = memberIds
        self.initiatorName = initiatorName
        self.createdBy = createdBy
        self.members = members
        self.viewers = viewers
        self.initiatorimage = initiatorimage
        self.ingestEndpoint = ingestEndpoint
        self.streamKey = streamKey
        self.playbackUrl = playbackUrl
        self.multiLive = multiLive
        self.rtcToken = rtcToken
        self.restreamChannelCount = restreamChannelCount
        self.restreamEndpoints = restreamEndpoints
        self.restream = restream
        self.productsLinked = productsLinked
        self.productsCount = productsCount
        self.initiatorIdentifier = initiatorIdentifier
        self.audioOnly = audioOnly
        self.userDetails = userDetails
        self.isPkChallenge = isPkChallenge
        
        self.duration = duration
        self.alreadyPaid = alreadyPaid
        self.isBuy = isBuy
        self.coinsCount = coinsCount
        self.country = country
        self.isPaid = isPaid
        self.isScheduledStream = isScheduledStream
        self.scheduleStartTime = scheduleStartTime
        self.amount = amount
        self.paymentCurrencyCode = paymentCurrencyCode
        self.paymentType = paymentType
        self.streamTags  = streamTags
        self.streamTypes = streamTypes
        self.type        = type
        self.userType    = userType
        
        self.firstUserDetails = firstUserDetails
        self.secondUserDetails = secondUserDetails
        self.isModerator = isModerator
        self.pkInviteId = pkInviteId
        self.hdBroadcast = hdBroadcast
        self.isometrikUserID = isometrikUserID
        self.saleType = saleType
        self.appUserId = appUserId
        self.rtmpIngest = rtmpIngest
        self.persistRtmpIngestEndpoint = persistRtmpIngestEndpoint
        self.isRecorded = isRecorded
        self.isStreamActive = isStreamActive
        
        self.status = status
        self.lowLatencyMode = lowLatencyMode
        self.enableRecording = enableRecording
        self.taggedProductIds = taggedProductIds
        self.storeId = storeId
        self.products = products
        self.otherProducts = otherProducts
        self._id = _id
        self.isRsvp = isRsvp
        self.recordViewCount = recordViewCount
    }
    
    /// Public initlizer decoder.
    ///
    /// - Parameter decoder: decoder
    /// - Throws: throw error while decoding
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        streamId = try? values.decodeIfPresent(String.self, forKey: .streamId)
        if streamId == nil{streamId = try? values.decodeIfPresent(String.self, forKey: .streamId)}
        
        viewersCount =  try? values.decodeIfPresent(Int64.self, forKey: .viewers)
        if viewersCount == nil{
            viewersCount = try? values.decodeIfPresent(Int64.self, forKey: .viewersCount)
        }
        
        audioOnly = try? values.decodeIfPresent(Bool.self, forKey: .audio_only)
        if audioOnly == nil {
            audioOnly = try? values.decodeIfPresent(Bool.self, forKey: .audioOnly)
        }
        
        streamImage = try? values.decodeIfPresent(String.self, forKey: .stream_image)
        if streamImage == nil {
            streamImage = try? values.decodeIfPresent(String.self, forKey: .streamImage)
        }
        
        streamPreviewUrl = try? values.decodeIfPresent(String.self, forKey: .streamPreviewUrl)
        
        streamDescription = try? values.decodeIfPresent(String.self, forKey: .stream_description)
        if streamDescription == nil {
            streamDescription = try? values.decodeIfPresent(String.self, forKey: .streamDescription)
        }
        
        startTime = try? values.decodeIfPresent(Int64.self, forKey: .start_time)
        if startTime == nil {
            startTime = try? values.decodeIfPresent(Int64.self, forKey: .startDateTime)
        }
        
        multiLive = try? values.decodeIfPresent(Bool.self, forKey: .multiLive)
        if multiLive == nil {
            multiLive = try? values.decodeIfPresent(Bool.self, forKey: .isGroupStream)
        }
        
        initiatorId = try? values.decodeIfPresent(String.self, forKey: .initiatorId)
        if initiatorId == nil {
            initiatorId = try? values.decodeIfPresent(String.self, forKey: .userId)
        }
        
        /*
            memberIds = try? values.decodeIfPresent([String].self, forKey: .memberIds)
            if memberIds == nil {
                memberIds = try? values.decodeIfPresent(String.self, forKey: .members)
            }
         */
        
        initiatorimage = try? values.decodeIfPresent(String.self, forKey: .initiatorimage)
        
        membersPublishingCount = try? values.decodeIfPresent(Int64.self, forKey: .membersPublishingCount)
        membersCount = try? values.decodeIfPresent(Int64.self, forKey: .membersCount)
        memberIds = try? values.decodeIfPresent([String].self, forKey: .memberIds)
        initiatorName = try? values.decodeIfPresent(String.self, forKey: .initiatorName)
        createdBy = try? values.decodeIfPresent(String.self, forKey: .createdBy)
        rtcToken = try? values.decodeIfPresent(String.self, forKey: .rtcToken)
        ingestEndpoint = try? values.decodeIfPresent(String.self, forKey: .ingestEndpoint)
        streamKey = try? values.decodeIfPresent(String.self, forKey: .streamKey)
        playbackUrl = try? values.decodeIfPresent(String.self, forKey: .playbackUrl)
        restreamChannelCount = try? values.decodeIfPresent(Int.self, forKey: .restreamChannelCount)
        restream = try? values.decodeIfPresent(Bool.self, forKey: .restream)
        productsLinked = try? values.decodeIfPresent(Bool.self, forKey: .productsLinked)
        productsCount = try? values.decodeIfPresent(Int.self, forKey: .productsCount)
        initiatorIdentifier = try? values.decodeIfPresent(String.self, forKey: .initiatorIdentifier)
        
        streamInfo = try? values.decodeIfPresent(StreamInfo.self, forKey: .streamInfo)
        userDetails = try? values.decodeIfPresent(StreamUserDetails.self, forKey: .userDetails)
        isPkChallenge = try? values.decodeIfPresent(Bool.self, forKey: .isPkChallenge)
        pkId = try? values.decodeIfPresent(String.self, forKey: .pkId)
        pkInviteId = try? values.decodeIfPresent(String.self, forKey: .pkInviteId)
        isModerator = try? values.decodeIfPresent(Bool.self, forKey: .isModerator)
        canPublish = try? values.decodeIfPresent(Bool.self, forKey: .canPublish)
        
        // NOTE: - This is Temperory fix (change later)
        
        duration = try? values.decodeIfPresent(Int.self, forKey: .duration)
        alreadyPaid = try? values.decodeIfPresent(Bool.self, forKey: .alreadyPaid)
        isBuy = try? values.decodeIfPresent(Bool.self, forKey: .isBuy)
        coinsCount = try? values.decodeIfPresent(Int.self, forKey: .coinsCount)
        country = try? values.decodeIfPresent(String.self, forKey: .country)
        isPaid = try? values.decodeIfPresent(Bool.self, forKey: .isPaid)
        isScheduledStream = try? values.decodeIfPresent(Bool.self, forKey: .isScheduledStream)
        scheduleStartTime = try? values.decodeIfPresent(Double.self, forKey: .scheduleStartTime)
        amount = try? values.decodeIfPresent(Double.self, forKey: .amount)
        paymentCurrencyCode = try? values.decodeIfPresent(String.self, forKey: .paymentCurrencyCode)
        paymentType = try? values.decodeIfPresent(Int.self, forKey: .paymentType)
        streamTags = try? values.decodeIfPresent([String].self, forKey: .streamTags)
        streamTypes = try? values.decodeIfPresent([Int].self, forKey: .streamTypes)
        type = try? values.decodeIfPresent(String.self, forKey: .type)
        userType = try? values.decodeIfPresent(Int.self, forKey: .userType)
        firstUserDetails = try? values.decodeIfPresent(ISM_PK_User.self, forKey: .firstUserDetails)
        secondUserDetails = try? values.decodeIfPresent(ISM_PK_User.self, forKey: .secondUserDetails)
        selfHosted = try? values.decodeIfPresent(Bool.self, forKey: .selfHosted)
        streamTitle = try? values.decodeIfPresent(String.self, forKey: .streamTitle)
        isometrikUserID = try? values.decodeIfPresent(String.self, forKey: .isometrikUserID)
        pinProductDetails = try? values.decodeIfPresent(ISMPinProductDetails.self, forKey: .pinProductDetails)
        saleType = try? values.decodeIfPresent(Int.self, forKey: .saleType)
        id = try? values.decodeIfPresent(String.self, forKey: .id)
        appUserId = try? values.decodeIfPresent(String.self, forKey: .appUserId)
        
        rtmpIngest = try? values.decodeIfPresent(Bool.self, forKey: .rtmpIngest)
        persistRtmpIngestEndpoint = try? values.decodeIfPresent(Bool.self, forKey: .persistRtmpIngestEndpoint)
        recordedUrl = try? values.decodeIfPresent([String].self, forKey: .recordedUrl) ?? []
        endDateTime = try? values.decodeIfPresent(Int64.self, forKey: .endDateTime)
        
        isStreamActive = try? values.decodeIfPresent(Bool.self, forKey: .isStreamActive)
        isRecorded = try? values.decodeIfPresent(Bool.self, forKey: .isRecorded)
        hdBroadcast = try? values.decodeIfPresent(Bool.self, forKey: .hdBroadcast)
        //status = try? values.decodeIfPresent(String.self, forKey: .status)
        isPublicStream = try? values.decodeIfPresent(Bool.self, forKey: .isPublicStream)
        isGroupStream = try? values.decodeIfPresent(Bool.self, forKey: .isGroupStream)
        lowLatencyMode = try? values.decodeIfPresent(Bool.self, forKey: .lowLatencyMode)
        enableRecording = try? values.decodeIfPresent(Bool.self, forKey: .enableRecording)
        taggedProductIds = try? values.decodeIfPresent([String].self, forKey: .taggedProductIds)
        storeId = try? values.decodeIfPresent(String.self, forKey: .storeId)
        products = try? values.decodeIfPresent([ISMProductToBeTagged].self, forKey: .products)
        otherProducts = try? values.decodeIfPresent([ISMOthersProductToBeTagged].self, forKey: .otherProducts)
        
        _id = try? values.decodeIfPresent(String.self, forKey: ._id)
        if _id == nil {
            _id = try? values.decodeIfPresent(String.self, forKey: .id)
        }
        
        isRsvp = try? values.decodeIfPresent(Bool.self, forKey: .isRsvp)
        recordViewCount = try? values.decodeIfPresent(Int.self, forKey: .recordViewCount)
        metaData = try? values.decodeIfPresent(StreamMetaData.self, forKey: .metaData)
        //:
    }
    
    /// Encode Stream model.
    /// - Parameter encoder: encoder
    /// - Throws: throws error & exception while converting model
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(streamId, forKey: .streamId)
        try? container.encode(viewersCount, forKey: .viewersCount)
        try? container.encode(streamImage, forKey: .streamImage)
        try? container.encode(streamDescription, forKey: .streamDescription)
        try? container.encode(startTime, forKey: .startDateTime)
        try? container.encode(membersPublishingCount, forKey: .membersPublishingCount)
        try? container.encode(membersCount, forKey: .membersCount)
        try? container.encode(memberIds, forKey: .memberIds)
        try? container.encode(initiatorName, forKey: .initiatorName)
        try? container.encode(createdBy, forKey: .createdBy)
        try? container.encode(initiatorId, forKey: .initiatorId)
        try? container.encode(rtcToken, forKey: .rtcToken)
        try? container.encode(multiLive, forKey: .multiLive)
        try? container.encode(ingestEndpoint, forKey: .ingestEndpoint)
        try? container.encode(streamKey, forKey: .streamKey)
        try? container.encode(playbackUrl, forKey: .playbackUrl)
        
        try? container.encode(restreamChannelCount, forKey: .restreamChannelCount)
        try? container.encode(restream, forKey: .restream)
        try? container.encode(productsLinked, forKey: .productsLinked)
        try? container.encode(productsCount, forKey: .productsCount)
        try? container.encode(initiatorIdentifier, forKey: .initiatorIdentifier)
        try? container.encode(selfHosted, forKey: .selfHosted)
        try? container.encode(canPublish, forKey: .canPublish)
        try? container.encode(recordedUrl, forKey: .recordedUrl)
        try? container.encode(endDateTime, forKey: .endDateTime)
        try? container.encode(isStreamActive, forKey: .isStreamActive)
        
        try? container.encode(status, forKey: .status)
        try? container.encode(lowLatencyMode, forKey: .lowLatencyMode)
        try? container.encode(enableRecording, forKey: .enableRecording)
        try? container.encode(taggedProductIds, forKey: .taggedProductIds)
        try? container.encode(storeId, forKey: .storeId)
        try? container.encode(products, forKey: .products)
        try? container.encode(products, forKey: .otherProducts)
        try? container.encode(isRsvp, forKey: .isRsvp)
        try? container.encode(recordViewCount, forKey: .recordViewCount)
        try? container.encode(streamPreviewUrl, forKey: .streamPreviewUrl)
    }

}

public struct ISMPinProductDetails: Codable, Hashable {
    
    public let pinProductId: String?
    public let duration: RelaxedString?
    public let timeStamp: RelaxedString?
    public let expireTime: RelaxedString?
    public let discountPercentage: RelaxedString?
    public let startBidPrice: RelaxedString?
    
    enum CodingKeys: String, CodingKey {
        case pinProductId
        case duration
        case timeStamp
        case expireTime
        case discountPercentage
        case startBidPrice
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pinProductId = try? values.decodeIfPresent(String.self, forKey: .pinProductId)
        duration = try? values.decodeIfPresent(RelaxedString.self, forKey: .duration)
        timeStamp = try? values.decodeIfPresent(RelaxedString.self, forKey: .timeStamp)
        expireTime = try? values.decodeIfPresent(RelaxedString.self, forKey: .expireTime)
        discountPercentage = try? values.decodeIfPresent(RelaxedString.self, forKey: .discountPercentage)
        startBidPrice = try? values.decodeIfPresent(RelaxedString.self, forKey: .startBidPrice)
    }
    
}

public struct StreamMetaData: Codable {
    public let conversationId: String?
}


public struct StreamInfo : Codable{
    public let duration : Int?
    public let alreadyPaid : Bool?
    public let coinsCount : Int?
    public let country : String?
    public let isPaid : Bool?
    public let isScheduledStream : Bool?
    public let paymentAmount : Double?
    public let paymentCurrencyCode : String?
    public let paymentType : Int?
    public let streamTags : [String]?
    public let streamTypes : [Int]?
    public let type : String? //????
    public let userType : Int?
    public let userDetails : StreamUserDetails?
}

public struct StreamUserDetails: Codable, Hashable {
    
    public let firstName: String?
    public let isFollow: Int?
    public let isStar: Bool?
    public let lastName: String?
    public let userName: String?
    public let userProfile: String?
    public let profilePic: String?
    public let isomatricChatUserId: String?
    public let id: String?
    public var followStatus: Int?
    public var privacy: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case firstName
        case isFollow
        case isStar
        case lastName
        case userName
        case userProfile
        case profilePic
        case isomatricChatUserId
        case id = "id"
        case followStatus
        case privacy
    }
    
    public init(firstName: String?, isFollow: Int?, isStar: Bool?, lastName: String?, userName: String?, userProfile: String?, profilePic: String?, isomatricChatUserId: String?, id: String?, followStatus: Int? = 0, privacy: Int? = 0) {
        self.firstName = firstName
        self.isFollow = isFollow
        self.isStar = isStar
        self.lastName = lastName
        self.userName = userName
        self.userProfile = userProfile
        self.profilePic = profilePic
        self.isomatricChatUserId = isomatricChatUserId
        self.id = id
        self.followStatus = followStatus
        self.privacy = privacy
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try? values.decodeIfPresent(String.self, forKey: .firstName)
        isFollow = try? values.decodeIfPresent(Int.self, forKey: .isFollow)
        isStar = try? values.decodeIfPresent(Bool.self, forKey: .isStar)
        lastName = try? values.decodeIfPresent(String.self, forKey: .lastName)
        userName = try? values.decodeIfPresent(String.self, forKey: .userName)
        userProfile = try? values.decodeIfPresent(String.self, forKey: .userProfile)
        profilePic = try? values.decodeIfPresent(String.self, forKey: .profilePic)
        isomatricChatUserId = try? values.decodeIfPresent(String.self, forKey: .isomatricChatUserId)
        followStatus = try? values.decodeIfPresent(Int.self, forKey: .followStatus)
        privacy = try? values.decodeIfPresent(Int.self, forKey: .privacy)
        id = try? values.decodeIfPresent(String.self, forKey: .id)
    }
}

public struct ISMRecordedStreamData: Codable {
    
    let recordings: [ISMStream]?
    
}


public struct RelaxedString: Codable, Hashable {
    
    public let value: String
    
    public init(_ value: String) {
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        // attempt to decode from all JSON primitives
        if let str = try? container.decode(String.self) {
            value = str
        } else if let int = try? container.decode(Int.self) {
            value = int.description
        } else if let double = try? container.decode(Double.self) {
            value = double.description
        } else if let bool = try? container.decode(Bool.self) {
            value = bool.description
        } else {
            throw DecodingError.typeMismatch(String.self, .init(codingPath: decoder.codingPath, debugDescription: ""))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

public struct ISMPaidStreamResponseModel: Codable {
    let message: String?
}
