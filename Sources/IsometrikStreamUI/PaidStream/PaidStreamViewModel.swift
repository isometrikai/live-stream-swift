//
//  File.swift
//  
//
//  Created by Appscrip 3Embed on 19/07/24.
//

import IsometrikStream

public enum PaidResponse {
    case success
    case failed(errorString: String)
}

final public class PaidStreamViewModel {
    
    var streamData: ISMStream
    var isometrik: IsometrikSDK
    var amountToPay: Int
    public var response: ((PaidResponse) -> ())?
    
    public init(amountToPay: Int, isometrik: IsometrikSDK, streamData: ISMStream) {
        self.amountToPay = amountToPay
        self.isometrik = isometrik
        self.streamData = streamData
    }
    
    func buyStream(completion: @escaping(Bool, String?)->Void) {
        let streamId = streamData.streamId.unwrap
        isometrik.getIsometrik().buyPaidStream(streamId: streamId) { result in
            completion(true, nil)
        } failure: { error in
            completion(false, "\(error.localizedDescription)")
        }
    }
    
}
