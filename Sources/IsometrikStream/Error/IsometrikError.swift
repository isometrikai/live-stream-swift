//
//  IsometrikError.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 10/11/22.
//

import Foundation

public struct IsometrikError: Error {
    
    public let httpResponseCode: Int?
    public let errorMessage: String
    public let remoteErrorCode: Int?
    public let isometrikErrorCode: Int?
    public let remoteError: Bool?
    public let errorData: [String: Any]?
    
    public init(httpResponseCode: Int? = nil, remoteError: Bool? = nil, errorMessage: String, remoteErrorCode: Int? = nil, isometrikErrorCode: Int? = nil, errorData: [String: Any]? = [:]) {
        self.httpResponseCode = httpResponseCode
        self.errorMessage = errorMessage
        self.remoteError = remoteError
        self.remoteErrorCode = remoteErrorCode
        self.isometrikErrorCode = isometrikErrorCode
        self.errorData = errorData
    }
    
}
