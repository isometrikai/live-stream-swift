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
    
    public func getCurrencyPlans(completionHandler: @escaping (ISMCoinPlansResponseModel)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: WalletRouter.getCurrencyPlans, requestBody: nil)
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMCoinPlansResponseModel, ISMLiveAPIError> ) in
            
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
    
    public func getWalletBalance(currencyType: String, completionHandler: @escaping (ISMWalletBalanceResponseModel)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: WalletRouter.getWalletBalance(currency: currencyType), requestBody: nil)
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMWalletBalanceResponseModel, ISMLiveAPIError> ) in
            
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
    
    public func getWalletTransactions(transactionType: ISMWalletTransactionType?, currencyType: ISMWalletCurrencyType, skip: Int = 0, limit: Int = 10, completionHandler: @escaping (ISMWalletTransactionResponseModel)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let transactionSpecific = !(transactionType == nil)
        let txnType = transactionType?.rawValue ?? nil
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: WalletRouter.getWalletTransaction(currency: currencyType.getValue, transactionType: txnType, transactionSpecific: transactionSpecific, skip: skip, limit: limit), requestBody: nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMWalletTransactionResponseModel, ISMLiveAPIError> ) in
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
