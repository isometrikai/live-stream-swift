//
//  ISMGiftResponseModel.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 19/06/24.
//

import Foundation

public struct ISMGiftResponseModel: Codable {
    
    let message, txnID: String?
    let transferedCoins, createdAt, remainingBalance: Int?
    let giftTitle: String?

    enum CodingKeys: String, CodingKey {
        case message
        case txnID = "txnId"
        case transferedCoins, createdAt, remainingBalance, giftTitle
    }
    
}
