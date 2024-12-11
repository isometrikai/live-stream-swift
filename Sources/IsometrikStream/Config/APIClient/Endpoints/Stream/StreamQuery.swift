//
//  StreamQuery.swift
//  LiveStream
//
//  Created by Dheeraj Kumar Sharma on 08/06/23.
//

import Foundation

public enum SortOrder: String {
    case ascending = "asc"
    case descending = "desc"
}

public enum StreamStatus: Int {
    case started = 0
    case ended = 1
    case scheduled = 2
    case considerAll = 4
}

public struct StreamQuery: Codable {
    let limit: Int?
    let skip: Int?
    let status: Int?
    let search: String?
    let type: String?
    let streamId: String?
    let sortOrder: String?
    let streamStatus: Int?
    let eventId: String?
    
    // for filters
    let isLive: Bool?
    let isPK: Bool?
    let isRecorded: Bool?
    let audioOnly: Bool?
    let isPrivate: Bool?
    let isRestream: Bool?
    let isHDbroadcast: Bool?
    let isPaid: Bool?
    let isScheduledStream: Bool?
    let startDateTime: String?
    let endDateTime: String?
    //:
    
    public init(
        limit: Int = 10,
        skip: Int? = nil,
        status: Int? = nil,
        type: String? = nil,
        search: String? = nil,
        streamId: String? = nil,
        sortOrder: String? = SortOrder.ascending.rawValue,
        streamStatus: Int? = StreamStatus.considerAll.rawValue,
        eventId: String? = nil,
        
        isLive: Bool? = nil,
        isPK: Bool? = nil,
        isRecorded: Bool? = nil,
        audioOnly: Bool? = nil,
        isPrivate: Bool? = nil,
        isRestream: Bool? = nil,
        isHDbroadcast: Bool? = nil,
        isPaid: Bool? = nil,
        isScheduledStream: Bool? = nil,
        startDateTime: String? = nil,
        endDateTime: String? = nil
    ){
        self.limit = limit
        self.skip = skip
        self.status = status
        self.type = type
        self.search = search
        self.streamId = streamId
        
        self.sortOrder = sortOrder
        self.streamStatus = streamStatus
        self.eventId = eventId
        
        self.isLive = isLive
        self.isPK = isPK
        self.isRecorded = isRecorded
        self.audioOnly = audioOnly
        self.isPrivate = isPrivate
        self.isRestream = isRestream
        self.isHDbroadcast = isHDbroadcast
        self.isPaid = isPaid
        self.isScheduledStream = isScheduledStream
        
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
    }
    
    enum CodingKeys: String, CodingKey {
        case limit
        case skip
        case status
        case search
        case type
        case streamId
        case sortOrder
        case streamStatus
        case eventId
        
        case isLive = "fetchLive"
        case isPK = "pk"
        case isRecorded
        case audioOnly
        case isPrivate = "private"
        case isRestream = "restream"
        case isHDbroadcast = "hdbroadcast"
        case isPaid
        case isScheduledStream
        case startDateTime
        case endDateTime
    }
    
    // Implementing the `+` operator to merge two StreamQuery instances
    static public func +(lhs: StreamQuery, rhs: StreamQuery) -> StreamQuery {
        return StreamQuery(
            limit: rhs.limit ?? lhs.limit ?? 10,
            skip: rhs.skip ?? lhs.skip,
            status: rhs.status ?? lhs.status,
            type: rhs.type ?? lhs.type,
            search: rhs.search ?? lhs.search,
            streamId: rhs.streamId ?? lhs.streamId,
            sortOrder: rhs.sortOrder ?? lhs.sortOrder,
            streamStatus: rhs.streamStatus ?? lhs.streamStatus,
            eventId: rhs.eventId ?? lhs.eventId,
            isLive: rhs.isLive ?? lhs.isLive,
            isPK: rhs.isPK ?? lhs.isPK,
            isRecorded: rhs.isRecorded ?? lhs.isRecorded,
            audioOnly: rhs.audioOnly ?? lhs.audioOnly,
            isPrivate: rhs.isPrivate ?? lhs.isPrivate,
            isRestream: rhs.isRestream ?? lhs.isRestream,
            isHDbroadcast: rhs.isHDbroadcast ?? lhs.isHDbroadcast,
            isPaid: rhs.isPaid ?? lhs.isPaid,
            isScheduledStream: rhs.isScheduledStream ?? lhs.isScheduledStream,
            startDateTime: rhs.startDateTime ?? lhs.startDateTime,
            endDateTime: rhs.endDateTime ?? lhs.endDateTime
        )
    }
    
    // Defining the `+=` operator to use the `+` operator for merging
    static public func +=(lhs: inout StreamQuery, rhs: StreamQuery) {
        lhs = lhs + rhs
    }
    
}
