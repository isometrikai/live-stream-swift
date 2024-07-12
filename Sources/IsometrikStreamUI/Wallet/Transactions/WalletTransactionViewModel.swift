
import IsometrikStream
import UIKit

enum TransactionType: Int {
    case all = 1
    case credit
    case debit
}

class WalletTransactionViewModel {
    
    let isometrik: IsometrikSDK
    var transactionData: WalletTransactionResponseModel?
    var transactions: [WalletTransactionData] = []
    var selectedTransactionType: TransactionType = .all
    
    var skip = 0
    var limit = 20
    
    init(isometrik: IsometrikSDK) {
        self.isometrik = isometrik
    }
    
    func getTransactions(_ completion: @escaping(Bool, String?) -> Void){
        
        var transactionType: WalletTransactionType? = nil
        
        switch selectedTransactionType {
        case .credit:
            transactionType = .credit
            break
        case .debit:
            transactionType = .debit
            break
        default:
            break
        }
        
        isometrik.getIsometrik().getWalletTransactions(transactionType: transactionType, skip: skip, limit: limit) { response in
            
            self.transactionData = response
            self.transactions = response.data ?? []
            
            if self.transactions.count.isMultiple(of: self.limit) {
                self.skip += self.limit
            }
            
            DispatchQueue.main.async {
                completion(true, nil)
            }
            
        } failure: { error in
            DispatchQueue.main.async {
                completion(false, error.localizedDescription)
            }
        }
        
    }
    
}
