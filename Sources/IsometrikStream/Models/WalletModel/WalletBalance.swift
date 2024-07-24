//
//  File.swift
//  
//
//  Created by Appscrip 3Embed on 10/07/24.
//

import Foundation

public struct WalletBalanceResponseModel: Codable {
    public let status: String?
    public let message: String?
    public let data: WalletBalance?
}

public struct WalletBalance: Codable {
    
    public let id: String?
    public let currency: String?
    public let currencySymbol: String?
    public let hardLimit: Float64?
    public let softLimit: Float64?
    public let balance: Float64?
    public let isHardLimitHit: Bool?
    public let isSoftLimitHit: Bool?
    public let status: String?
    public let userId: String?
    public let userType: String?
    public let timeStamp: Double?
    public let walletType: String?
    public let accountId: String?
    public let projectId: String?
    
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency)
        self.currencySymbol = try container.decodeIfPresent(String.self, forKey: .currencySymbol)
        self.hardLimit = try container.decodeIfPresent(Float64.self, forKey: .hardLimit)
        self.softLimit = try container.decodeIfPresent(Float64.self, forKey: .softLimit)
        self.balance = try container.decodeIfPresent(Float64.self, forKey: .balance)
        self.isHardLimitHit = try container.decodeIfPresent(Bool.self, forKey: .isHardLimitHit)
        self.isSoftLimitHit = try container.decodeIfPresent(Bool.self, forKey: .isSoftLimitHit)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.userId = try container.decodeIfPresent(String.self, forKey: .userId)
        self.userType = try container.decodeIfPresent(String.self, forKey: .userType)
        self.timeStamp = try container.decodeIfPresent(Double.self, forKey: .timeStamp)
        self.walletType = try container.decodeIfPresent(String.self, forKey: .walletType)
        self.accountId = try container.decodeIfPresent(String.self, forKey: .accountId)
        self.projectId = try container.decodeIfPresent(String.self, forKey: .projectId)
    }
    
}
