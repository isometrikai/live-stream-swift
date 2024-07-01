//
//  ProductRequestModel.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 17/05/24.
//

import Foundation

public struct ProductRequestParameter {
    public let limit: Int?
    public let skip: Int?
    public let query: String?
    
    public init(limit: Int?, skip: Int?, query: String?) {
        self.limit = limit
        self.skip = skip
        self.query = query
    }
}

public struct UpdateOfferModel: Encodable {
    public let productId: String
    public let offerId: String
    public let offerPrice: Double
    
    public init(productId: String, offerId: String, offerPrice: Double) {
        self.productId = productId
        self.offerId = offerId
        self.offerPrice = offerPrice
    }
}

public struct CreateLiveStreamOffers: Encodable {
    public let streamId: String
    public let products: [ISMProductToBeTagged]
    public let otherProducts: [ISMOthersProductToBeTagged]
    public let storeId: String
    
    public init(streamId: String, products: [ISMProductToBeTagged], otherProducts: [ISMOthersProductToBeTagged], storeId: String) {
        self.streamId = streamId
        self.products = products
        self.otherProducts = otherProducts
        self.storeId = storeId
    }
}

public struct RemoveTaggedProducts: Encodable {
    public let streamId: String
    public let productId: [String]
    
    public init(streamId: String, productId: [String]) {
        self.streamId = streamId
        self.productId = productId
    }
}
