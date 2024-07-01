//
//  GiftRequests.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 19/06/24.
//

import Foundation

extension IsometrikStream {
    
    public func transferGifts(_ giftBody: GiftBody, completionHandler: @escaping (ISMGiftResponseModel)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request =  ISMLiveAPIRequest(endPoint: GiftRouter.sendGiftToStreamer , requestBody: giftBody)
        
        ISMLiveAPIManager.sendRequest(request: request, showLoader: false) { (result :ISMLiveResult<ISMGiftResponseModel, ISMLiveAPIError> ) in
            
            switch result {
            case .success(let giftResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(giftResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
        
    }
    
    public func getGiftCategories(skip: Int, limit: Int, completionHandler: @escaping (ISMStreamGiftModelData)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request = ISMLiveAPIRequest<Any>(endPoint: GiftRouter.getGiftCategories(skip: skip, limit: limit) , requestBody: nil)
        
        ISMLiveAPIManager.sendRequest(request: request, showLoader: false) { (result :ISMLiveResult<ISMStreamGiftModelData, ISMLiveAPIError> ) in
            
            switch result {
            case .success(let giftResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(giftResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
        
    }
    
    public func getGiftForACategory(giftGroupId: String, skip: Int, limit: Int, completionHandler: @escaping (ISMStreamGiftModelData)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request = ISMLiveAPIRequest<Any>(endPoint: GiftRouter.getGiftForACategory(giftGroupId: giftGroupId, skip: skip, limit: limit) , requestBody: nil)
        
        ISMLiveAPIManager.sendRequest(request: request, showLoader: false) { (result :ISMLiveResult<ISMStreamGiftModelData, ISMLiveAPIError> ) in
            
            switch result {
            case .success(let giftResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(giftResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
        
    }
    
}
