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
    let fetchLive: Bool?
    let sortOrder: String?
    let isRecorded: Bool?
    let streamStatus: Int?
    
    public init(
        limit: Int = 10,
        skip: Int? = nil,
        status: Int? = nil,
        type: String? = nil,
        search: String? = nil,
        streamId: String? = nil,
        fetchLive: Bool? = nil,
        sortOrder: String? = SortOrder.ascending.rawValue,
        streamStatus: Int? = StreamStatus.considerAll.rawValue,
        isRecorded: Bool? = nil
    ){
        self.limit = limit
        self.skip = skip
        self.status = status
        self.type = type
        self.search = search
        self.streamId = streamId
        self.fetchLive = fetchLive
        self.sortOrder = sortOrder
        self.streamStatus = streamStatus
        self.isRecorded = isRecorded
    }
    
}
