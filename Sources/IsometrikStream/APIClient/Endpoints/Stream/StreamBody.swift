//
//  StreamBody.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 12/11/22.
//

import Foundation

public struct StreamBody: Codable, Hashable {
    
    private let streamId: String?
    private let streamImage: String?
    private let streamPreviewUrl: String?
    private let streamDescription: String?
    private let members: [String]?
    private let createdBy: String?
    
    private let isPublic : Bool?
    private let audioOnly : Bool?
    private let multiLive: Bool?
    private let lowLatencyMode: Bool?
    private let restream: Bool?
    private let enableRecording: Bool?
    private let hdBroadcast: Bool?
    private let isSelfHosted: Bool?
    
    private let productsLinked: Bool?
    //private let products: [String]?
    
    /// Extra properties added for LiveJet
    private let isScheduledStream : Bool?
    private let amount: Int?
    private let paymentCurrencyCode: String?
    private let paymentType: Int?
    private let streamTags: [String]?
    private let country: String?
    private let isPaid: Bool?
    private let isPublicStream : Bool?
    private let isRecorded : Bool?
    private let streamTitle: String?
    private let userId: String?
    private let userName: String?
    private let userType: Int?
    
    private let streamUserId: String?
    private let inviteId: String?
    
    private let rtmpIngest: Bool?
    private let persistRtmpIngestEndpoint: Bool?
    
    
    // Extra parameters for playcee
    private var saleType: Int?
    private let isHighLighted: Bool?
    private let scheduleStartTime: Int64?
    private let isometrikUserId: String?
    private let taggedProductIds: [String]?
    private let address: UserAddress?
    private let isGroupStream: Bool?
    
    private let storeId: String?
    private let storeCategoryId: String?
    private let products: [ISMProductToBeTagged]?
    private let otherProducts: [ISMOthersProductToBeTagged]?
    private let eventId:String?
    private let currency: String?
    
    public init(
        streamId: String? = nil,
        streamImage: String? = nil,
        streamPreviewUrl: String? = nil,
        streamDescription: String? = nil,
        members: [String]? = nil,
        createdBy: String? = nil,
        isPublic: Bool? = nil,
        audioOnly: Bool? = nil,
        multiLive: Bool? = nil,
        lowLatencyMode: Bool? = nil,
        restream: Bool? = nil,
        enableRecording: Bool? = nil,
        hdBroadcast: Bool? = nil,
        isSelfHosted: Bool? = nil,
        productsLinked: Bool? = nil,
        //products: [String]? = nil,
        
        country: String = "",
        isPaid: Bool = false,
        isPublicStream: Bool = false,
        isRecorded: Bool = false,
        isScheduledStream:Bool = false,
        amount: Int = 0,
        paymentType: Int = 0,
        streamTags: [String]? = nil,
        streamTitle: String? = nil,
        paymentCurrencyCode: String? = nil,
        userType: Int = 1,
        userName: String? = nil,
        streamUserId: String? = nil,
        
        inviteId: String = "",
        
        rtmpIngest: Bool = false,
        persistRtmpIngestEndpoint:Bool = false,
        
        saleType: Int? = nil,
        isHighLighted: Bool? = nil,
        scheduleStartTime: Int64? = nil,
        isometrikUserId: String? = nil,
        taggedProductIds: [String]? = [],
        address: UserAddress? = nil,
        isGroupStream: Bool = true,
        
        storeId: String? = nil,
        storeCategoryId: String? = nil,
        products: [ISMProductToBeTagged]? = nil,
        otherProducts: [ISMOthersProductToBeTagged]? = nil,
        eventId: String? = nil,
        currency: String? = nil
    ) {
        self.streamId = streamId
        self.streamImage = streamImage
        self.streamPreviewUrl = streamPreviewUrl
        self.streamDescription = streamDescription
        self.members = members
        self.createdBy = createdBy
        self.isPublic = isPublic
        self.audioOnly = audioOnly
        self.multiLive = multiLive
        self.lowLatencyMode = lowLatencyMode
        self.restream = restream
        self.enableRecording = enableRecording
        self.hdBroadcast = hdBroadcast
        self.isSelfHosted = isSelfHosted
        self.productsLinked = productsLinked
        //self.products = products
        
        self.country = country
        self.isPaid = isPaid
        self.isPublicStream = isPublicStream
        self.isRecorded = isRecorded
        self.isScheduledStream = isScheduledStream
        self.amount = amount
        self.paymentType = paymentType
        self.streamTags = streamTags
        self.streamTitle = streamTitle
        self.paymentCurrencyCode = paymentCurrencyCode
        self.userType = userType
        self.userId = createdBy
        self.userName = userName
        self.streamUserId = streamUserId
        self.inviteId = inviteId
        
        self.rtmpIngest = rtmpIngest
        self.persistRtmpIngestEndpoint = persistRtmpIngestEndpoint
        
        self.saleType = saleType
        self.isHighLighted = isHighLighted
        self.scheduleStartTime = scheduleStartTime
        self.isometrikUserId = isometrikUserId
        self.taggedProductIds = taggedProductIds
        self.address = address
        self.isGroupStream = isGroupStream
        
        self.storeId = storeId
        self.storeCategoryId = storeCategoryId
        self.products = products
        self.otherProducts = otherProducts
        self.eventId = eventId
        self.currency = currency
    }
    
}

public struct UserAddress: Codable, Hashable {
    private let cityId: String?
    private let cityName: String?
    private let countryId: Int?
    private let countryName: String?
    
    public init(cityId: String? = nil, cityName: String? = nil, countryId: Int? = nil, countryName: String? = nil) {
        self.cityId = cityId
        self.cityName = cityName
        self.countryId = countryId
        self.countryName = countryName
    }
    
}

public struct ISMProductToBeTagged: Codable, Hashable {
    
    private let id: String?
    private let discount: Double?
    private let parentCategoryId: String?
    private let brandId: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case discount
        case parentCategoryId
        case brandId
    }
    
    public init(id: String?, discount: Double?, parentCategoryId: String?, brandId: String?) {
        self.id = id
        self.discount = discount
        self.parentCategoryId = parentCategoryId
        self.brandId = brandId
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decodeIfPresent(String.self, forKey: .id)
        discount = try? values.decodeIfPresent(Double.self, forKey: .discount)
        parentCategoryId = try? values.decodeIfPresent(String.self, forKey: .parentCategoryId)
        brandId = try? values.decodeIfPresent(String.self, forKey: .brandId)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(id, forKey: .id)
        try? container.encode(discount, forKey: .discount)
        try? container.encode(parentCategoryId, forKey: .parentCategoryId)
        try? container.encode(brandId, forKey: .brandId)
    }
    
}

public struct ISMOthersProductToBeTagged: Codable, Hashable {
    
    public var storeId: String?
    private let products: [ISMProductToBeTagged]?
    
    enum CodingKeys: String, CodingKey {
        case storeId
        case products
    }
    
    public init(storeId: String?, products: [ISMProductToBeTagged]?) {
        self.storeId = storeId
        self.products = products
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        storeId = try? values.decodeIfPresent(String.self, forKey: .storeId)
        products = try? values.decodeIfPresent([ISMProductToBeTagged].self, forKey: .products)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(storeId, forKey: .storeId)
        try? container.encode(products, forKey: .products)
    }
    
}


// MARK: - MetaData
public struct MetaData: Codable {
    
    private let openStream: Bool?

    enum CodingKeys: String, CodingKey {
        case openStream = "open stream"
    }
    
    public init(openStream: Bool?) {
        self.openStream = openStream
    }
    
}

public struct StopStreamBody: Codable {
    
    private let streamId: String
    
    public init(streamId: String) {
        self.streamId = streamId
    }
    
}

public struct StartStreamBody: Codable {
    
    // Internal SDK fields
    private let streamImage: String
    private let streamDescription: String
    private let selfHosted: Bool
    private let restream: Bool
    private let productsLinked: Bool
    private let products: [String]
    private let multiLive: Bool
    private let members: [String]
    private let lowLatencyMode: Bool
    private let isPublic: Bool
    private let hdBroadcast: Bool
    private let enableRecording: Bool
    private let audioOnly: Bool
    private let rtmpIngest: Bool
    private let persistRtmpIngestEndpoint: Bool
    
    public init(streamImage: String, streamDescription: String, selfHosted: Bool, restream: Bool, productsLinked: Bool, products: [String], multiLive: Bool, members: [String], lowLatencyMode: Bool, isPublic: Bool, hdBroadcast: Bool, enableRecording: Bool, audioOnly: Bool, rtmpIngest: Bool, persistRtmpIngestEndpoint: Bool) {
        self.streamImage = streamImage
        self.streamDescription = streamDescription
        self.selfHosted = selfHosted
        self.restream = restream
        self.productsLinked = productsLinked
        self.products = products
        self.multiLive = multiLive
        self.members = members
        self.lowLatencyMode = lowLatencyMode
        self.isPublic = isPublic
        self.hdBroadcast = hdBroadcast
        self.enableRecording = enableRecording
        self.audioOnly = audioOnly
        self.rtmpIngest = rtmpIngest
        self.persistRtmpIngestEndpoint = persistRtmpIngestEndpoint
    }
    
}

public struct PaidStreamBody: Encodable {
    let streamId: String
    init(streamId: String) {
        self.streamId = streamId
    }
}


