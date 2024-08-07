//
//  EcommerceBody.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 12/11/22.
//

import Foundation

public struct EcommerceBody: Codable, Hashable {
    
    public let userId: String?
    public let streamId: String?
    public let startFeaturing: Bool?
    public let productId: String?
    public let count: Int?
    public let quantity: Int?
    
    public let skip: Int?
    public let limit: Int?
    
    public init(userId: String? = nil, streamId: String? = nil, startFeaturing: Bool? = nil, productId: String? = nil, count: Int? = nil, quantity: Int? = nil, skip: Int = 0, limit: Int = 10) {
        self.userId = userId
        self.streamId = streamId
        self.startFeaturing = startFeaturing
        self.productId = productId
        self.count = count
        self.quantity = quantity
        self.skip = skip
        self.limit = limit
    }
    
}
