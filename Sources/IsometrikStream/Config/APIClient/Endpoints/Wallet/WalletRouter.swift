
import Foundation

enum WalletRouter: ISMLiveURLConvertible, CustomStringConvertible {
    
    case getCurrencyPlans
    case purchaseToken
    case getWalletBalance(currency: String)
    case getWalletTransaction(currency: String, transactionType: String?, transactionSpecific: Bool, skip: Int, limit: Int)
    
    var description: String {
        switch self {
        case .getCurrencyPlans:
            return "get Currency plans from admin"
        case .purchaseToken:
            return "purchange the tokens from given plans"
        case .getWalletBalance:
            return "get wallet balance"
        case .getWalletTransaction:
            return "get wallet transactions"
        }
    }
    
    var baseURL: URL{
        return URL(string:"https://service-\(ISMConfiguration.shared.primaryOrigin)")!
    }
    
    var method: ISMLiveHTTPMethod {
        switch self {
        case .getCurrencyPlans, .getWalletBalance, .getWalletTransaction:
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
        case .getWalletTransaction:
            path = "/v1/transaction/user"
        }
        return path
    }
    
    var headers: [String : String]?{
        return nil
    }
    
    var queryParams: [String : String]? {
        
        var param: [String: String] = [:]
        
        switch self {
        case let .getWalletBalance(currency):
            param += [
                "currency": "\(currency)"
            ]
            break
        case let .getWalletTransaction(currency, transactionType, transactionSpecific, skip, limit):
            
            param += [
                "currency": "\(currency)",
                "skip": "\(skip)",
                "limit": "\(limit)"
            ]
            
            if let transactionType {
                param += [
                    "txnType": "\(transactionType)",
                    "txnSpecific": "\(transactionSpecific)"
                ]
            } else {
                param += [
                    "txnSpecific": "\(transactionSpecific)"
                ]
            }
            break
        default:
            return [:]
        }
        
        return param
    }
    
}

public typealias WalletPayloadResponse = ((Result<Any?, IsometrikError>) -> Void)
