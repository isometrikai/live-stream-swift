//
//  StreamRouter.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 12/11/22.
//

import UIKit

enum StreamRouter: ISMLiveURLConvertible, CustomStringConvertible {
    
    case startStream
    case startScheduledStream
    case stopStream
    case deleteStream(streamId: String)
    case fetchStreams(streamQuery: StreamQuery?)
    case searchStreams(streamQuery: StreamQuery?)
    case checkStreamExistence(streamId: String)
    case getSingleStream(streamId: String)
    case getRecordedStream
    case updateScheduledStream
    
    var description: String {
        switch self {
        case .startStream: return "start new stream"
        case .startScheduledStream: return "Start scheduled stream"
        case .stopStream: return "stop stream"
        case .deleteStream: return "delete stream"
        case .fetchStreams: return "fetch live stream"
        case .searchStreams: return "search live stream"
        case .checkStreamExistence: return "It checks whether stream already exists or not"
        case .getSingleStream: return "get particular stream"
        case .getRecordedStream: return "get recorded stream"
        case .updateScheduledStream: return "update scheduled stream"
        }
    }
    
    var baseURL: URL{
        switch self {
        case .startStream, .fetchStreams, .stopStream:
            return URL(string:"https://service-\(ISMConfiguration.shared.primaryOrigin)")!
        case .getRecordedStream:
            return URL(string:"https://\(ISMConfiguration.shared.primaryOrigin)")!
        default:
            return URL(string:"https://\(ISMConfiguration.shared.secondaryOrigin)")!
        }
    }
    
    var method: ISMLiveHTTPMethod {
        switch self {
        case .startStream, .startScheduledStream :
            return .post
        case .updateScheduledStream, .stopStream:
            return .patch
        case .deleteStream :
            return .delete
        default:
            return .get
        }
    }
    
    var path: String {
        let path: String
        switch self {
        case .startStream, .stopStream :
            path = "/live/v2/stream"
        case .fetchStreams:
            path = "/live/v2/streams"
        case .startScheduledStream:
            path = "/v1/stream/schedule/golive"
        case  .deleteStream :
            path = "/v1/stream"
        case .searchStreams :
            path = "/v1/streams"
        case .checkStreamExistence:
            path = "/v1/stream/check"
        case .getSingleStream:
            path = "/v1/streams/detail"
        case .getRecordedStream:
            path = "/streaming/v2/stream/recordings"
        case .updateScheduledStream:
            path = "/v1/updatestream"
        }
        return path
    }
    
    // We are sending default headers for api, add additonal headers here
    var headers: [String : String]?{
        return nil
    }
    
    var queryParams: [String : String]? {
        var param: [String: String] = [:]
        
        switch self {
        case let .deleteStream(streamId):
            param = ["streamId":"\(streamId)"]
            break
        case let .fetchStreams(streamQuery) :
            if let streamQuery = streamQuery {
                
                if let streamId = streamQuery.streamId {
                    param += ["streamId":"\(streamId)"]
                }
                
                if let limit = streamQuery.limit {
                    param += ["limit":"\(limit)"]
                }
                
                if let skip = streamQuery.skip {
                    param += ["skip":"\(skip)"]
                }
                
                if let status = streamQuery.streamStatus {
                    param += ["status":"\(status)"]
                }
                
                if let streamType = streamQuery.type {
                    param += ["type":"\(streamType)"]
                }
                
                if let fetchLive = streamQuery.fetchLive {
                    param += ["fetchLive":"\(fetchLive)"]
                }
                
                if let sortOrder = streamQuery.sortOrder {
                    param += ["sortOrder":"\(sortOrder)"]
                }

                if let isRecorded = streamQuery.isRecorded {
                    param += ["isRecorded":"\(isRecorded)"]
                }
            }
            break
        case let .checkStreamExistence(streamId):
            param = ["streamId":"\(streamId)"]
            break
        case let .getSingleStream(streamId):
            param = ["streamId":"\(streamId)"]
            break
        default:
            break
            
        }
        
        return param
    }
    
}

public typealias StreamPayloadResponse = ((Result<Any?, IsometrikError>) -> Void)
