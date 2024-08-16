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
    
    public func deleteScheduleStream(streamBody: StreamBody, completionHandler: @escaping (ISMStream)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
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
    public func fetchStreams(streamParam: StreamQuery, completionHandler: @escaping (ISMStreamsData)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: StreamRouter.fetchStreams(streamQuery: streamParam) , requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMStreamsData, ISMLiveAPIError> ) in
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
    
    public func fetchScheduledStreams(streamParam: StreamQuery, completionHandler: @escaping (ISMStreamsData)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: StreamRouter.getScheduledStream(streamQuery: streamParam) , requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMStreamsData, ISMLiveAPIError> ) in
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
    
    public func getPresignedUrl(streamTitle: String, mediaExtension: String, completionHandler: @escaping (ISMPresignedUrlResponse)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: StreamRouter.getPresignedUrl(streamTitle: streamTitle, mediaExtension: mediaExtension) , requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMPresignedUrlResponse, ISMLiveAPIError> ) in
            
            switch result{
            case .success(let response, _) :
                DispatchQueue.main.async {
                    completionHandler(response)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
            }
        }
        
    }
    
    public func getStreamAnalytics(streamId: String, completionHandler: @escaping (StreamAnalyticsResponseModel)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: StreamRouter.getStreamAnalytics(streamId: streamId), requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<StreamAnalyticsResponseModel, ISMLiveAPIError> ) in
            
            switch result{
            case .success(let response, _) :
                DispatchQueue.main.async {
                    completionHandler(response)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    public func buyPaidStream(streamId: String, completionHandler: @escaping (ISMPaidStreamResponseModel)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let bodyData = PaidStreamBody(streamId: streamId)
        let request =  ISMLiveAPIRequest(endPoint: StreamRouter.buyPaidStream, requestBody: bodyData)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMPaidStreamResponseModel, ISMLiveAPIError> ) in
            
            switch result{
            case .success(let response, _) :
                DispatchQueue.main.async {
                    completionHandler(response)
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
