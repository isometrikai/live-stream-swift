
import Foundation

public struct ISMCoinPlansResponseModel: Codable {
    public let status: String?
    public let messsage: String?
    public let data: [ISMCoinPlan]?
}

public struct ISMCoinPlan: Codable {
    public let id: String?
    public let currencyPlanImage: String?
    public let baseCurrencyValue: Double?
    public let numberOfUnits: Int32?
    public let appStoreProductIdentifier: String?
    public let planId: String?
    public let baseCurrencySymbol: String?
    public let status: String?
    public let applicationId: String?
    public let clientName: String?
}
