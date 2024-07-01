//
//  StreamAnalytic.swift
//  Yelo
//
//  Created by Nikunj M1 on 12/09/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//


public struct StreamAnalyticModel: Codable {
    public let totalViewersCount, duration, productCount, soldCount, newViewersCount, earnings, hearts, followers: Int?
    public let totalSales: Double?
    public let totalSold: Int?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalViewersCount = try? container.decodeIfPresent(Int.self, forKey: .totalViewersCount)
        duration = try? container.decodeIfPresent(Int.self, forKey: .duration)
        productCount = try? container.decodeIfPresent(Int.self, forKey: .productCount)
        soldCount = try? container.decodeIfPresent(Int.self, forKey: .soldCount)
        newViewersCount = try? container.decodeIfPresent(Int.self, forKey: .newViewersCount)
        earnings = try? container.decodeIfPresent(Int.self, forKey: .earnings)
        hearts = try? container.decodeIfPresent(Int.self, forKey: .hearts)
        followers = try? container.decodeIfPresent(Int.self, forKey: .followers)
        totalSales = try? container.decodeIfPresent(Double.self, forKey: .totalSales)
        totalSold = try? container.decodeIfPresent(Int.self, forKey: .totalSold)
    }
}
