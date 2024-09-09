
import IsometrikStream
import UIKit

enum TransactionType: Int {
    case all = 1
    case credit
    case debit
}

class WalletTransactionViewModel {
    
    let isometrik: IsometrikSDK
    var totalTransactions: Int64 = 0
    var transactions: [WalletTransactionData] = []
    var selectedTransactionType: TransactionType = .all
    var walletCurrencyType: WalletCurrencyType
    
    let refreshControl = UIRefreshControl()
    
    var skip = 0
    var limit = 20
    
    init(isometrik: IsometrikSDK, walletCurrencyType: WalletCurrencyType) {
        self.isometrik = isometrik
        self.walletCurrencyType = walletCurrencyType
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
        
        isometrik.getIsometrik().getWalletTransactions(transactionType: transactionType, currencyType: self.walletCurrencyType , skip: skip, limit: limit) { response in
            
            self.totalTransactions = response.totalCount ?? 0
            
            let transactions = response.data ?? []
            if self.transactions.isEmpty {
                self.transactions = transactions
            } else {
                self.transactions.append(contentsOf: transactions)
            }
            
            
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
    
    func canBePaginate() -> Bool {
        if totalTransactions > transactions.count {
            return true
        }
        return false
    }
    
}
