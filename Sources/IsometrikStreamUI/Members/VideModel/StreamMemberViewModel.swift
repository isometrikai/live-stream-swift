//
//  StreamMemberViewModel.swift
//  LiveStream
//
//  Created by Dheeraj Kumar Sharma on 29/06/23.
//

import Foundation
import IsometrikStream

enum StreamMemberResult {
    case success
    case failure(msg: String)
}

class StreamMemberViewModel {
    
    var isometrik: IsometrikSDK
    var streamData: ISMStream
    var memberList: [ISMMember] = []
    var skip: Int = 0
    var limit: Int = 20
    
    init(isometrik: IsometrikSDK, streamData: ISMStream) {
        self.isometrik = isometrik
        self.streamData = streamData
    }
    
    func getStreamMembers(completion: @escaping(StreamMemberResult) -> Void){
        
        let streamId = streamData.streamId.unwrap
        
        isometrik.getIsometrik().fetchMembers(streamId: streamId, skip: skip, limit: limit) { result in
                self.memberList = result
                completion(.success)
        }failure: { error in
            switch error{
            case .noResultsFound(_):
                // handle noresults found here
                break
            case .invalidResponse:
                DispatchQueue.main.async {
                    completion(.failure(msg: "fetch Memeber Error : Invalid Response"))
                }
            case .httpError(let errorCode, let errorMessage):
                DispatchQueue.main.async{
                    completion(.failure(msg: "fetch Memeber Error : \(errorCode) \(errorMessage?.error ?? "")"))
                }
            default :
                break
            }
        }
        
    }
}

