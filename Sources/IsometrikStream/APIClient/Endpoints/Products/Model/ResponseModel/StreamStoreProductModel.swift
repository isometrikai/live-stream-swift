//
//  StreamStoreProductModel.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 20/05/24.
//

import Foundation

public struct StreamStoreProductModelData: Codable {
    public let message: String?
    public let data: StreamStoreProductModel?
}

public struct StreamStoreProductModel: Codable{
    public let footer: StreamStoreFooterData?
    public let totalCount: Int?
    public let products: [StreamProductModel]?
    
    enum CodingKeys: String, CodingKey {
        case footer
        case totalCount = "penCount"
        case products
    }
}

public struct StreamStoreFooterData: Codable {
    public let description: String?
    public let title: String?
    public let image: String?
}
