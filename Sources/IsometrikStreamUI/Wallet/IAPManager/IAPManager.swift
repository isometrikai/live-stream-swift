import Foundation
import StoreKit
import IsometrikStream

class IAPManager: NSObject {
    
    // MARK: - Custom Types
    
    enum IAPManagerError: Error {
        case noProductIDsFound
        case noProductsFound
        case paymentWasCancelled
        case productRequestFailed
    }
    
    var applePlans = [SKProduct]()
    var products: [String: SKProduct] = [:]

    
    // MARK: - Properties
    
    static let shared = IAPManager()
    var onReceiveProductsHandler: ((Result<[SKProduct], IAPManagerError>) -> Void)?
    var onBuyProductHandler: ((Result<Bool, Error>) -> Void)?
    var totalRestoredPurchases = 0
        
    // MARK: - Init
    
    private override init() {
        super.init()
    }
    
    // MARK: - General Methods
    
    func getPriceFormatted(for product: SKProduct) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)
    }
    
    
    func startObserving() {
        SKPaymentQueue.default().add(self)
    }

    func stopObserving() {
        SKPaymentQueue.default().remove(self)
    }
    
    func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    // MARK: - Get IAP Products
    
    func getProducts(productIdsFrombacken:[String], withHandler productsReceiveHandler: @escaping (_ result: Result<[SKProduct], IAPManagerError>) -> Void) {
        // Keep the handler (closure) that will be called when requesting for
        // products on the App Store is finished.
        onReceiveProductsHandler = productsReceiveHandler

        // Initialize a product request.
        let request = SKProductsRequest(productIdentifiers: Set(productIdsFrombacken))

        // Set self as the its delegate.
        request.delegate = self

        // Make the request.
        request.start()
    }
    
    
    // MARK: - Purchase Products
    
    func buy(product: SKProduct, withHandler handler: @escaping ((_ result: Result<Bool, Error>) -> Void)) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)

        // Keep the completion handler.
        onBuyProductHandler = handler
    }
       
    
    func restorePurchases(withHandler handler: @escaping ((_ result: Result<Bool, Error>) -> Void)) {
        onBuyProductHandler = handler
        totalRestoredPurchases = 0
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}


// MARK: - SKPaymentTransactionObserver
extension IAPManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { (transaction) in
            switch transaction.transactionState {
            case .purchased:
                    guard let identifier = transactions[0].transactionIdentifier else {return}
                    guard let date = transactions[0].transactionDate else {
                        return}
                    let purchaseDetails = ["productId": transactions[0].payment.productIdentifier,
                                           "transactionId": identifier,
                                           "transationDate": date] as [String : Any]
                    IAPManager.savePurchasedPlan(data: purchaseDetails)
                    onBuyProductHandler?(.success(true))
                    SKPaymentQueue.default().finishTransaction(transaction)
                break;
            case .restored:
                totalRestoredPurchases += 1
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .failed:
                if let error = transaction.error as? SKError {
                    
                    if error.code != .paymentCancelled {
                        onBuyProductHandler?(.failure(error))
                    } else {
                        onBuyProductHandler?(.failure(IAPManagerError.paymentWasCancelled))
                    }
                }
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .deferred, .purchasing: break
            @unknown default: break
            }
        }
    }
    
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if totalRestoredPurchases != 0 {
            onBuyProductHandler?(.success(true))
        } else {
            onBuyProductHandler?(.success(false))
        }
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        if let error = error as? SKError {
            if error.code != .paymentCancelled {
                onBuyProductHandler?(.failure(error))
            } else {
                onBuyProductHandler?(.failure(IAPManagerError.paymentWasCancelled))
            }
        }
    }
}




// MARK: - SKProductsRequestDelegate
extension IAPManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        // Get the available products contained in the response.
        let products = response.products

        // Check if there are any products available.
        if products.count > 0 {
            // Call the following handler passing the received products.
            onReceiveProductsHandler?(.success(products))
        } else {
            // No products were found.
            onReceiveProductsHandler?(.failure(.noProductsFound))
        }
    }
    
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        onReceiveProductsHandler?(.failure(.productRequestFailed))
    }
    
    
    func requestDidFinish(_ request: SKRequest) {
        // Implement this method OPTIONALLY and add any custom logic
        // you want to apply when a product request is finished.
    }
}




// MARK: - IAPManagerError Localized Error Descriptions
extension IAPManager.IAPManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noProductIDsFound: return "No In-App Purchase product identifiers were found."
        case .noProductsFound: return "No In-App Purchases were found."
        case .productRequestFailed: return "Unable to fetch available In-App Purchase products at the moment."
        case .paymentWasCancelled: return "In-App Purchase process was cancelled."
        }
    }
}

// MARK: - usage
extension IAPManager{
    
    func getPlansFromApple(productIds: [String],handler: @escaping ((_ result: [SKProduct],_ success:Bool, _ errorString: String?) -> Void)){
        getProducts(productIdsFrombacken: productIds) { (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self.applePlans = products
                    handler(products, true, nil)
                    return

                case .failure(let error):
                    handler([], false, "Oops! \(error.localizedDescription)")
                    break
                }
            }
        }
    }
    
    
    func generateReceipt() -> String{
       
        let receiptPath = Bundle.main.appStoreReceiptURL?.path
        if FileManager.default.fileExists(atPath: receiptPath!){
            var receiptData:NSData?
            do{
                receiptData = try NSData(contentsOf: Bundle.main.appStoreReceiptURL!, options: NSData.ReadingOptions.alwaysMapped)
            }
            catch{
                print("ERROR: " + error.localizedDescription)
            }
            let base64encodedReceipt = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithCarriageReturn)
            
             return base64encodedReceipt ?? ""
        }
        return ""
    }
    
    //save purchase plans from appstore
      class func savePurchasedPlan(data:[String:Any]){
          UserDefaults.standard.setValue(data, forKey: "purchaseDetails")
          UserDefaults.standard.synchronize()
      }
      
      class func getPurchasedPlan()->[String:Any]{
          if let purchasedProDetails = UserDefaults.standard.object(forKey: "purchaseDetails") as? [String:Any] {
              return purchasedProDetails
          }
          return [:]
      }
    
    class func saveReceiptData(data:[[String:Any]]){
        UserDefaults.standard.setValue(data, forKey:"receiptData")
        UserDefaults.standard.synchronize()
    }
    
    class func getReceiptData() -> [[String:Any]]{
        if let data = UserDefaults.standard.value(forKey:"receiptData") as? [[String:Any]] {
            return data
        }
        return [[:]]
    }
    
    /// used to get product as per coin value
    func getProductWithCoin(coin: String) -> SKProduct?{
        for product in self.applePlans{
            if product.productIdentifier.contains(coin){
                return product
            }
        }
        return nil
    }
    
    /// used to get product as per coin value
    func getProductWithId(storeId: String) -> SKProduct?{
        for product in self.applePlans{
            if product.productIdentifier == storeId{
                return product
            }
        }
        return nil
    }
    
}

