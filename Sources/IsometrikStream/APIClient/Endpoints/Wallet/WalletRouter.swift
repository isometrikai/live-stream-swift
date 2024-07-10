
import Foundation

enum WalletRouter: ISMLiveURLConvertible, CustomStringConvertible {
    
    case getCurrencyPlans
    case purchaseToken
    case getWalletBalance(currencyCode: String)
    
    var description: String {
        switch self {
        case .getCurrencyPlans:
            return "get Currency plans from admin"
        case .purchaseToken:
            return "purchange the tokens from given plans"
        case .getWalletBalance:
            return "get wallet balance"
        }
    }
    
    var baseURL: URL{
        return URL(string:"https://service-\(ISMConfiguration.shared.primaryOrigin)")!
    }
    
    var method: ISMLiveHTTPMethod {
        switch self {
        case .getCurrencyPlans, .getWalletBalance:
            return .get
        case .purchaseToken:
            return .post
        }
    }
    
    var path: String {
        let path: String
        switch self {
        case .getCurrencyPlans:
            path = "/v1/currencyPlan/isometrikAuth"
        case .purchaseToken:
            path = "/v1/appWallet/tokenPurchase"
        case .getWalletBalance:
            path = "/v1/wallet/user"
        }
        return path
    }
    
    var headers: [String : String]?{
        return nil
    }
    
    var queryParams: [String : String]? {
        switch self {
        case let .getWalletBalance(currencyCode):
            return [
                "currency": "\(currencyCode)"
            ]
        default:
            return nil
        }
    }
    
}

public typealias WalletPayloadResponse = ((Result<Any?, IsometrikError>) -> Void)
