
import Foundation
import IsometrikStream
import StoreKit

final public class BuyCoinsViewModel {
    
    var coinPlansData: CoinPlansResponseModel?
    var walletBalance: WalletBalance?
    var coinPlans: [CoinPlan] = []
    var skProducts: [SKProduct] = []
    
    private var isometrik: IsometrikSDK
    
    public init(isometrik: IsometrikSDK) {
        self.isometrik = isometrik
    }
    
    func getWalletBalance(completion: @escaping(_ success: Bool, _ error: String?)->Void){
        isometrik.getIsometrik().getWalletBalance { response in
            self.walletBalance = response.data
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
        
        isometrik.getIsometrik().getCurrencyPlans { response in
            
            self.coinPlansData = response
            
            let productIdsString = response.data?.map {
                $0.appStoreProductIdentifier ?? ""
            }
            
            IAPManager.shared.getPlansFromApple(productIds: productIdsString ?? [String]()) { result, success, errorString in
                if success {
                    DispatchQueue.main.async {
                        self.skProducts = result
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
            DispatchQueue.main.async {
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func purchasePlan(completion: @escaping(_ success: Bool, _ error: String?) -> Void){
        
        var planId = ""
        
        let data = IAPManager.getPurchasedPlan()
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
        
        products.forEach { product in
            if let coinPlan = self.coinPlansData?.data?.filter({ $0.appStoreProductIdentifier == product.productIdentifier}) {
                self.coinPlans.append(contentsOf: coinPlan)
                self.skProducts.append(product)
            }
        }
    }
    
}
