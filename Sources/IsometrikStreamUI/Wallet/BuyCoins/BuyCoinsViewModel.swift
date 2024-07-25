
import Foundation
import IsometrikStream
import StoreKit

public enum WalletCurrencyType: String {
    case coin = "COIN"
    case money = "USD"
}

final public class BuyCoinsViewModel {
    
    var coinPlansData: CoinPlansResponseModel?
    var walletBalance: WalletBalance?
    var coinPlans: [CoinPlan] = []
    var skProducts: [SKProduct] = []
    
    public var isometrik: IsometrikSDK
    
    public init(isometrik: IsometrikSDK) {
        self.isometrik = isometrik
    }
    
    func getWalletBalance(currencyType: WalletCurrencyType, completion: @escaping(_ success: Bool, _ error: String?)->Void){
        isometrik.getIsometrik().getWalletBalance(currencyType: currencyType.rawValue) { response in
            self.walletBalance = response.data
            let balance = response.data?.balance ?? 0
            UserDefaultsProvider.shared.setWalletBalance(data: balance, currencyType: currencyType.rawValue)
            DispatchQueue.main.async {
                completion(true, nil)
            }
        } failure: { error in
            DispatchQueue.main.async {
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func getCoinPlans(completion: @escaping(_ success: Bool, _ error: String?) -> Void){
        DispatchQueue.main.async {
            CustomLoader.shared.startLoading()
        }
        isometrik.getIsometrik().getCurrencyPlans { response in
            
            self.coinPlansData = response
            
            let productIdsString = response.data?.map {
                $0.appStoreProductIdentifier ?? ""
            }
            
            IAPManager.shared.getPlansFromApple(productIds: productIdsString ?? [String]()) { result, success, errorString in
                CustomLoader.shared.stopLoading()
                if success {
                    DispatchQueue.main.async {
                        //self.skProducts = result
                        self.setCoinPlansPerProduct(products: result)
                        completion(true, nil)
                    }
                } else {
                    guard let errorString else { return }
                    DispatchQueue.main.async {
                        completion(false, errorString)
                    }
                }
            }
            
        } failure: { error in
            CustomLoader.shared.stopLoading()
            DispatchQueue.main.async {
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func purchasePlan(completion: @escaping(_ success: Bool, _ error: String?) -> Void){
        
        var planId = ""
        
        let data = UserDefaultsProvider.shared.getPurchaseDetails()
        if let productId = data["productId"] as? String {
            let planData = self.coinPlansData?.data?.filter({$0.appStoreProductIdentifier == productId})
            planId = planData?.first?.planId ?? ""
        }
        
        let walletBody = WalletBody(
            planId: planId,
            deviceType: "APP_STORE",
            packageName: "",
            productId: data["productId"] as? String,
            purchaseToken: IAPManager.shared.generateReceipt()
        )
        
        isometrik.getIsometrik().purchaseToken(body: walletBody) { response in
            DispatchQueue.main.async {
                completion(true, nil)
            }
        } failure: { error in
            DispatchQueue.main.async {
                completion(false, error.localizedDescription)
            }
        }
        
        
    }
    
    func setCoinPlansPerProduct(products: [SKProduct]?) {
        
        guard let products else { return }
        
        // Sort products by price from lowest to highest
        var seenIdentifiers = Set<String>()
        var seenCoinPlanIdentifiers = Set<String>()
        
        let sortedUniqueProducts = products
            .filter { seenIdentifiers.insert($0.productIdentifier).inserted }
            .sorted { $0.price.compare($1.price) == .orderedAscending }
        
        sortedUniqueProducts.forEach { product in
            
            if let coinPlans = self.coinPlansData?.data?.filter({
                $0.appStoreProductIdentifier == product.productIdentifier
            }) {
                // Append unique coin plans
                coinPlans.forEach { coinPlan in
                    let coinPlanIdentifier = coinPlan.appStoreProductIdentifier ?? ""
                    if seenCoinPlanIdentifiers.insert(coinPlanIdentifier).inserted {
                        self.coinPlans.append(coinPlan)
                    }
                }
                self.skProducts.append(product)
            }
        }
        
    }
    
}
