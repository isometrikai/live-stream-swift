
import Foundation

public enum ISMWalletCurrencyType: Int {
    case coin = 0
    case money
    
    public var getValue: String {
        switch self {
        case .coin:
            return "COIN"
        case .money:
            return "USD"
        }
    }
}

public enum ISMWalletTransactionType: String {
    case debit = "DEBIT"
    case credit = "CREDIT"
}

public struct ISMWalletTransactionResponseModel: Codable {
    
    public let status: String?
    public let message: String?
    public let data: [ISMWalletTransactionData]?
    public let totalCount: Int64?
    
}

public struct ISMWalletTransactionData: Codable {
    
    public let amount: Float64?
    public let openingBalance: Float64?
    public let closingBalance: Float64?
    public let currency: String?
    public let description: String?
    public let initiatedBy: String?
    public let notes: String?
    public let txnTimeStamp: Int64?
    public let txnType: String?
    public let paymentTypeMode: String?
    public let walletId: String?
    public let transactionId: String?
    public let accountId: String?
    public let projectId: String?
    
}
