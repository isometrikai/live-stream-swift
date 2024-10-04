//
//  StreamRouter.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 12/11/22.
//

import UIKit

enum StreamRouter: ISMLiveURLConvertible, CustomStringConvertible {
    
    case startStream
    case stopStream
    case deleteStream
    case fetchStreams(streamQuery: StreamQuery?)
    case searchStreams(streamQuery: StreamQuery?)
    case checkStreamExistence(streamId: String)
    case getSingleStream(streamId: String)
    case getRecordedStream
    case getPresignedUrl(streamTitle: String, mediaExtension: String)
    case getStreamAnalytics(streamId: String)
    case buyPaidStream
    
    case startScheduledStream
    case updateScheduledStream
    case getScheduledStream(streamQuery: StreamQuery?)
    case deleteScheduleStream
    
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
        case .getPresignedUrl: return "For uploading stream image cover"
        case .getStreamAnalytics: return "Get stream analytics"
        case .buyPaidStream: return "Buy paid stream"
        case .getScheduledStream: return "Get Scheduled streams."
        case .deleteScheduleStream: return "Delete scheduled stream."
        }
    }
    
    var baseURL: URL{
        return URL(string:"\(ISMConfiguration.shared.primaryOrigin)")!
    }
    
    var method: ISMLiveHTTPMethod {
        switch self {
        case .startStream, .startScheduledStream, .buyPaidStream :
            return .post
        case .updateScheduledStream, .stopStream:
            return .patch
        case .deleteStream, .deleteScheduleStream :
            return .delete
        default:
            return .get
        }
    }
    
    var path: String {
        let path: String
        switch self {
        case .startStream, .stopStream :
            path = "/live/v1/stream"
        case .fetchStreams:
            path = "/live/v1/streams"
        case  .deleteStream :
            path = "/live/v1/stream"
        case .searchStreams :
            path = "/live/v1/streams"
        case .checkStreamExistence:
            path = "/live/v1/stream/check"
        case .getSingleStream:
            path = "/live/v1/streams/detail"
        case .getRecordedStream:
            path = "/streaming/v2/stream/recordings"
        case .getPresignedUrl:
            path = "/streaming/v2/stream/presignedurl"
        case .getStreamAnalytics:
            path = "/live/v1/stream/analytics"
        case .buyPaidStream:
            path = "/live/v1/buy/stream"
        case .startScheduledStream:
            path = "/live/v1/stream/schedule/golive"
        case .getScheduledStream, .deleteScheduleStream, .updateScheduledStream:
            path = "/live/v1/streams/scheduled"
        
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
        case let .fetchStreams(streamQuery):
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
                
                if let sortOrder = streamQuery.sortOrder {
                    param += ["sortOrder":"\(sortOrder)"]
                }
                
                // filters
                
                if let isLive = streamQuery.isLive {
                    param += ["fetchLive":"\(isLive)"]
                }

                if let isRecorded = streamQuery.isRecorded {
                    param += ["isRecorded":"\(isRecorded)"]
                }
                
                if let isPK = streamQuery.isPK {
                    param += ["pk":"\(isPK)"]
                }
                
                if let isPrivate = streamQuery.isPrivate {
                    param += ["private":"\(isPrivate)"]
                }
                
                if let audioOnly = streamQuery.audioOnly {
                    param += ["audioOnly":"\(audioOnly)"]
                }
                
                if let isRestream = streamQuery.isRestream {
                    param += ["restream":"\(isRestream)"]
                }
                
                if let isHDbroadcast = streamQuery.isHDbroadcast {
                    param += ["hdbroadcast":"\(isHDbroadcast)"]
                }
                
                if let isPaid = streamQuery.isPaid {
                    param += ["isPaid":"\(isPaid)"]
                }
                
                if let isScheduledStream = streamQuery.isScheduledStream {
                    param += ["isScheduledStream":"\(isScheduledStream)"]
                }
                
                //:
            }
            break
        case let .checkStreamExistence(streamId):
            param = ["streamId":"\(streamId)"]
            break
        case let .getSingleStream(streamId):
            param = ["streamId":"\(streamId)"]
            break
        case let .getPresignedUrl(streamTitle, mediaExtension):
            param = [
                "streamTitle": "\(streamTitle)",
                "mediaExtension": "\(mediaExtension)"
            ]
        case let .getStreamAnalytics(streamId):
            param = [
                "streamId": "\(streamId)"
            ]
        case let .getScheduledStream(streamQuery):
            
            guard let streamQuery else { return [:] }
            
            if let limit = streamQuery.limit {
                param += ["limit":"\(limit)"]
            }
            
            if let skip = streamQuery.skip {
                param += ["skip":"\(skip)"]
            }
            
            if let sortOrder = streamQuery.sortOrder {
                param += ["sortOrder":"\(sortOrder)"]
            }
            
            if let eventId = streamQuery.eventId {
                param += ["eventId":"\(eventId)"]
            }
            
        default:
            break
            
        }
        
        return param
    }
    
}

public typealias StreamPayloadResponse = ((Result<Any?, IsometrikError>) -> Void)
