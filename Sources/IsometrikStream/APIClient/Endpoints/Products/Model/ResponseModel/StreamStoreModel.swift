//
//  StreamStoreModel.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 20/05/24.
//

import Foundation

public struct StreamStoreModelData: Codable {
    
    public var message: String?
    public var totalCount: Int?
    public var data: [StreamStoreModel]?
    
    enum CodingKeys: String, CodingKey {
        case message
        case totalCount = "penCount"
        case data
    }
    
}

public struct StreamStoreModel: Codable {
    public let id: String?
    public let storeName: String?
    public let storeLogo: StreamStoreLogo?
    public let userName: String?
}

public struct StreamStoreLogo: Codable {
    public let logoImageMobile: String?
}
