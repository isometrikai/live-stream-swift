//
//  File.swift
//  
//
//  Created by Appscrip 3Embed on 03/07/24.
//

import Foundation

/**
    Isometrik `Wallet` Requests
 */

extension IsometrikStream {
    
    public func getCurrencyPlans(completionHandler: @escaping (CoinPlansResponseModel)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: WalletRouter.getCurrencyPlans, requestBody: nil)
        
        ISMLiveAPIManager.sendRequest(request: request, showLoader: false) { (result :ISMLiveResult<CoinPlansResponseModel, ISMLiveAPIError> ) in
            
            switch result {

            case .success(let planResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(planResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
        
    }
    
    public func getWalletBalance(currencyType: String, completionHandler: @escaping (WalletBalanceResponseModel)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: WalletRouter.getWalletBalance(currency: currencyType), requestBody: nil)
        ISMLiveAPIManager.sendRequest(request: request, showLoader: false) { (result :ISMLiveResult<WalletBalanceResponseModel, ISMLiveAPIError> ) in
            
            switch result {

            case .success(let walletResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(walletResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
        
    }
    
    public func purchaseToken(body: WalletBody, completionHandler: @escaping (PurchasedPlanResponseModel)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: WalletRouter.purchaseToken, requestBody: body)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<PurchasedPlanResponseModel, ISMLiveAPIError> ) in
            
            switch result {

            case .success(let planResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(planResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
        
    }
    
    public func getWalletTransactions(transactionType: WalletTransactionType?, skip: Int = 0, limit: Int = 10, completionHandler: @escaping (WalletTransactionResponseModel)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let transactionSpecific = !(transactionType == nil)
        let txnType = transactionType?.rawValue ?? nil
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: WalletRouter.getWalletTransaction(currency: "COIN", transactionType: txnType, transactionSpecific: transactionSpecific, skip: skip, limit: limit), requestBody: nil)
        
        ISMLiveAPIManager.sendRequest(request: request, showLoader: false) { (result :ISMLiveResult<WalletTransactionResponseModel, ISMLiveAPIError> ) in
            switch result {
            case .success(let planResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(planResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
        
    }
    
}
