//
//  File.swift
//  
//
//  Created by Appscrip 3Embed on 03/07/24.
//

import Foundation

public struct WalletBody: Codable, Hashable {
    
    private let planId: String?
    private let transactionId: String?
    private let deviceType: String?
    private let packageName: String?
    private let productId: String?
    private let purchaseToken: String?
    
    public init(
        planId: String? = nil,
        transactionId: String? = nil,
        deviceType: String? = nil,
        packageName: String? = nil,
        productId: String? = nil,
        purchaseToken: String? = nil
    ) {
        self.planId = planId
        self.transactionId = transactionId
        self.deviceType = deviceType
        self.packageName = packageName
        self.productId = productId
        self.purchaseToken = purchaseToken
    }
    
}
