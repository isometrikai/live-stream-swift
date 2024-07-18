
public struct StreamAnalyticsResponseModel: Codable {
    public let totalViewersCount, duration, productCount, soldCount, newViewersCount, earnings, hearts, followers: Int64?
    public let totalEarning: Float64?
    public let coinsCount: Float64?
    public let giftsCount: Int64?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalViewersCount = try? container.decodeIfPresent(Int64.self, forKey: .totalViewersCount)
        duration = try? container.decodeIfPresent(Int64.self, forKey: .duration)
        productCount = try? container.decodeIfPresent(Int64.self, forKey: .productCount)
        soldCount = try? container.decodeIfPresent(Int64.self, forKey: .soldCount)
        newViewersCount = try? container.decodeIfPresent(Int64.self, forKey: .newViewersCount)
        earnings = try? container.decodeIfPresent(Int64.self, forKey: .earnings)
        hearts = try? container.decodeIfPresent(Int64.self, forKey: .hearts)
        followers = try? container.decodeIfPresent(Int64.self, forKey: .followers)
        totalEarning = try? container.decodeIfPresent(Double.self, forKey: .totalEarning)
        coinsCount = try? container.decodeIfPresent(Float64.self, forKey: .coinsCount)
        giftsCount = try? container.decodeIfPresent(Int64.self, forKey: .giftsCount)
    }
}
