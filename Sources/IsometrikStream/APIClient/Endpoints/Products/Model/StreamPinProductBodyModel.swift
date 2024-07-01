//
//  StreamPinProductBodyModel.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 20/05/24.
//

import Foundation

public struct StreamPinProductBodyModel: Encodable {
    public let streamId: String
    public let productId: String
    
    public init(streamId: String, productId: String) {
        self.streamId = streamId
        self.productId = productId
    }
}
