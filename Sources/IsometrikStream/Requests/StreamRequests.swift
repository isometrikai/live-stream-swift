//
//  StreamRequests.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 12/11/22.
//

import Foundation

/**
    Isometrik `Streams` Requests
 */

extension IsometrikStream {
    
    /// Stream new stream
    /// - Parameters:
    ///   - hostId: Created by user Id, Type should be **String**.
    ///   - members: Streaming members(user Id). Type should be **[String]**.
    ///   - description: Detail about the stream, Type should be **[String]**.
    ///   - imagePath: Stream image path, Type should be **[String]**.
    ///   - completionHandler: completionHandler for response data.
    public func startStream(streamBody: StreamBody, completionHandler: @escaping (ISMStream)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request =  ISMLiveAPIRequest(endPoint: StreamRouter.startStream , requestBody:streamBody)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMStream, ISMLiveAPIError> ) in
            switch result{
            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
            }
        }
    }
    
    public func updateScheduleStream(streamBody: StreamBody, completionHandler: @escaping (ISMStream)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request =  ISMLiveAPIRequest(endPoint: StreamRouter.updateScheduledStream , requestBody:streamBody)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMStream, ISMLiveAPIError> ) in
            
            switch result{
                
            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)

            }
        }
    }
    
    public func startScheduleStream(streamBody: StreamBody, completionHandler: @escaping (ISMStream)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        let request =  ISMLiveAPIRequest(endPoint: StreamRouter.startScheduledStream , requestBody:streamBody)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMStream, ISMLiveAPIError> ) in
            
            switch result{
                
            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)

            }
        }
    }
    
    /// Stop live stream
    /// - Parameters:
    ///   - streamId: Current runing stream Id, Type should be **String**.
    ///   - hostId: Created by user Id, Type should be **String**.
    ///   - completionHandler: completionHandler for response data.
    public func stopStream(streamId: String, streamUserId: String, inviteId: String = "", isRecorded: Bool = false,completionHandler: @escaping (ISMStream)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let streamParams = StreamBody(
            streamId: streamId,
            streamUserId: streamUserId,
            isometrikUserId: streamUserId
        )
        let request =  ISMLiveAPIRequest(endPoint: StreamRouter.stopStream , requestBody:streamParams)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMStream, ISMLiveAPIError> ) in
            
            switch result{
                
            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)

            }
        }
    
    }
    
    /// Delete live stream
    /// - Parameters:
    ///   - streamId: Current runing stream Id, Type should be **String**.
    ///   - hostId: Created by user Id, Type should be **String**.
    ///   - completionHandler: completionHandler for response data.
    public func deleteStream(streamId: String, completionHandler: @escaping (ISMStream)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: StreamRouter.deleteStream(streamId: streamId) , requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMStream, ISMLiveAPIError> ) in
            switch result {
            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
    }
    
    /// Live streams
    /// - Parameter completionHandler: completionHandler: completionHandler for response data.
    public func fetchStreams(limit: Int = 10 , skip: Int = 0, streamType: String = "1", streamStatus: StreamStatus = .considerAll, streamId: String? = nil, showLoader: Bool = true, completionHandler: @escaping (ISMStreamsData)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let streamQueryParam = StreamQuery(
            limit: limit,
            skip: skip,
            fetchLive: true
//            streamId: streamId,
//            streamStatus: streamStatus.rawValue
        )
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: StreamRouter.fetchStreams(streamQuery: streamQueryParam) , requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request, showLoader: showLoader) { (result :ISMLiveResult<ISMStreamsData, ISMLiveAPIError> ) in
            switch result {
            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
        
    }
    
    
    /// Live streams
    /// - Parameter completionHandler: completionHandler: completionHandler for response data.
    public func searchStreams(skip: Int = 0, searchText:String = "", completionHandler: @escaping (ISMStreamsData)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
            
        let streamQueryParam = StreamQuery(
            skip: skip,
            search: searchText
        )
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: StreamRouter.searchStreams(streamQuery: streamQueryParam) , requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMStreamsData, ISMLiveAPIError> ) in
            
            switch result{
            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)

            }
        }
        }
    
    public func checkStreamExistence(streamId: String,completionHandler: @escaping (ISMStream)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: StreamRouter.checkStreamExistence(streamId: streamId) , requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMStream, ISMLiveAPIError> ) in
            
            switch result{
            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)

            }
        }
    }
    
    
    public func getSingleStream(streamId: String, completionHandler: @escaping ([ISMStream])->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: StreamRouter.getSingleStream(streamId: streamId) , requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMStreamsData, ISMLiveAPIError> ) in
            
            switch result{
            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse.streams ?? [])
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)

            }
        }
    }
    
    public func getRecordedStream(completionHandler: @escaping (ISMRecordedStreamData)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: StreamRouter.getRecordedStream , requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMRecordedStreamData, ISMLiveAPIError> ) in
            
            switch result{
            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
            }
        }

   }
    
}
