//
//  EcommerceRequests.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 12/11/22.
//

import Foundation

/**
    Isometrik `Ecommerce` Requests
 */

extension IsometrikStream {
    
    public func fetchProducts(skip: Int = 0 , completionHandler: @escaping (ISMEcommerceProducts)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let requestBody = EcommerceBody(skip: skip)
        let request =  ISMLiveAPIRequest<Any>(endPoint: EcommerceRouter.fetchProducts, requestBody: requestBody)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMEcommerceProducts, ISMLiveAPIError> ) in
            
            switch result{
                
            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)

            }
        }
        
    }
    
    public func fetchLinkedProduct(streamId: String, skip: Int = 0, completionHandler: @escaping (ISMEcommerceProducts)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let requestBody = EcommerceBody(skip: skip)
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: EcommerceRouter.fetchLinkedProduct(streamId: streamId), requestBody: requestBody)

        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMEcommerceProducts, ISMLiveAPIError> ) in
            
            switch result{
                
            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)

            }
        }
        
        
    }
     
    public func updateFeaturingProductStatus(streamId: String, startFeaturing: Bool, productId: String, completionHandler: @escaping (ISMEcommerceProducts)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request = ISMLiveAPIRequest<Any>(endPoint: EcommerceRouter.updateFeaturingProductStatus(streamId: streamId, startFeaturing: startFeaturing, productId: productId), requestBody: nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMEcommerceProducts, ISMLiveAPIError> ) in
            
            switch result {
            case .success(let streamResponse, _):
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
            }
        }
        
    }
    
    public func fetchFeaturingProduct(streamId: String, completionHandler: @escaping (ISMEcommerceProducts)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request = ISMLiveAPIRequest<Any>(endPoint: EcommerceRouter.fetchFeaturingProduct(streamId: streamId), requestBody: nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMEcommerceProducts, ISMLiveAPIError> ) in
            switch result {
            case .success(let streamResponse, _):
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
            }
        }
        
    }
    
    public func addProductToCart(streamId: String, quantity: Int, productId: String, completionHandler: @escaping (ISMEcommerceProducts)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
       
        let request = ISMLiveAPIRequest<Any>(endPoint: EcommerceRouter.addProductToCart(streamId: streamId, quantity: quantity, productId: productId), requestBody: nil)
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMEcommerceProducts, ISMLiveAPIError> ) in
            switch result {
            case .success(let streamResponse, _):
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
            }
        }
    }
    
    public func fetchProductDetails(productId: String, completionHandler: @escaping (ISMEcommerceProducts)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request = ISMLiveAPIRequest<Any>(endPoint: EcommerceRouter.fetchProductDetails(productId: productId), requestBody: nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMEcommerceProducts, ISMLiveAPIError> ) in
            switch result {
            case .success(let streamResponse, _):
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
            }
        }
    }
    
    public func fetchCartProductDetails(streamId: String, productId: String, completionHandler: @escaping (ISMEcommerceProducts)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request = ISMLiveAPIRequest<Any>(endPoint: EcommerceRouter.fetchCartProductDetails(streamId: streamId, productId: productId), requestBody: nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMEcommerceProducts, ISMLiveAPIError> ) in
            switch result {
            case .success(let streamResponse, _):
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
            }
        }
    }
    
    public func fetchProductsInCart(streamId: String, skip: Int = 0, completionHandler: @escaping (ISMEcommerceProducts)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request = ISMLiveAPIRequest<Any>(endPoint: EcommerceRouter.fetchProductsInCart(streamId: streamId, bodyData: EcommerceBody(skip: skip)), requestBody: nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMEcommerceProducts, ISMLiveAPIError> ) in
            switch result {
            case .success(let streamResponse, _):
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
            }
        }
        
    }
    
    public func removeProductFromCart(streamId: String, productId: String, completionHandler: @escaping (ISMEcommerceProducts)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request = ISMLiveAPIRequest<Any>(endPoint: EcommerceRouter.removeProductFromCart(streamId: streamId, productId: productId), requestBody: nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMEcommerceProducts, ISMLiveAPIError> ) in
            switch result {
            case .success(let streamResponse, _):
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
            }
        }
    }
    
    public func checkoutCart(streamId: String, completionHandler: @escaping (ISMEcommerceProducts)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request = ISMLiveAPIRequest<Any>(endPoint: EcommerceRouter.checkoutCart(streamId: streamId), requestBody: nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMEcommerceProducts, ISMLiveAPIError> ) in
            switch result {
            case .success(let streamResponse, _):
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
            }
        }
    }
    
    public func updateProductInventory(productId: String, count: Int, completionHandler: @escaping (ISMEcommerceProducts)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request = ISMLiveAPIRequest<Any>(endPoint: EcommerceRouter.updateProductInventory(count: count, productId: productId), requestBody: nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMEcommerceProducts, ISMLiveAPIError> ) in
            switch result {
            case .success(let streamResponse, _):
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
            }
        }
    }
    
    public func updateProductQuantityInCart(productId: String, streamId: String, quantity: Int, completionHandler: @escaping (ISMEcommerceProducts)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request = ISMLiveAPIRequest<Any>(endPoint: EcommerceRouter.updateProductQuantityInCart(streamId: streamId, productId: productId, quantity: quantity), requestBody: nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMEcommerceProducts, ISMLiveAPIError> ) in
            switch result {
            case .success(let streamResponse, _):
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
            }
        }
    }
    
}
