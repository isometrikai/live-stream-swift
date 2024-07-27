
import Foundation

public enum WalletCurrencyType: Int {
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

public enum WalletTransactionType: String {
    case debit = "DEBIT"
    case credit = "CREDIT"
}

public struct WalletTransactionResponseModel: Codable {
    
    public let status: String?
    public let message: String?
    public let data: [WalletTransactionData]?
    public let totalCount: Int64?
    
}

public struct WalletTransactionData: Codable {
    
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
