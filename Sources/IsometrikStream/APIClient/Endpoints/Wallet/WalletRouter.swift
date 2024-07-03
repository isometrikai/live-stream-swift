
import Foundation

enum WalletRouter: ISMLiveURLConvertible, CustomStringConvertible {
    
    case getCurrencyPlans
    case purchaseToken
    
    var description: String {
        switch self {
        case .getCurrencyPlans:
            return "get Currency plans from admin"
        case .purchaseToken:
            return "purchange the tokens from given plans"
        }
    }
    
    var baseURL: URL{
        return URL(string:"https://admin-\(ISMConfiguration.shared.primaryOrigin)")!
    }
    
    var method: ISMLiveHTTPMethod {
        switch self {
        case .getCurrencyPlans:
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
        }
        return path
    }
    
    var headers: [String : String]?{
        return nil
    }
    
    var queryParams: [String : String]? {
        return nil
    }
    
}

public typealias WalletPayloadResponse = ((Result<Any?, IsometrikError>) -> Void)
