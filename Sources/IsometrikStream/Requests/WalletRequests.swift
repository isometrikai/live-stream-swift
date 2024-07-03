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
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<CoinPlansResponseModel, ISMLiveAPIError> ) in
            
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
    
    public func purchaseToken(body: WalletBody, completionHandler: @escaping (PurchasedPlanResponseModel)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: WalletRouter.purchaseToken, requestBody: nil)
        
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
    
}
