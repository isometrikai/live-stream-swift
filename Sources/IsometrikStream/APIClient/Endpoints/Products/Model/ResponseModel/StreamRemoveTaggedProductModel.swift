//
//  StreamRemoveTaggedProductModel.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 20/05/24.
//

import Foundation

public struct RemoveTaggedProductModel: Codable {
    
    public let message: String?
    public let statusCode: Int?
    public let status: String?
    
    enum CodingKeys: String, CodingKey {
        case message
        case statusCode = "status_code"
        case status
    }
    
}
