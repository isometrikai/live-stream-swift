//
//  ProductRouter.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 17/05/24.
//

import Foundation

enum ProductRouter: ISMLiveURLConvertible, CustomStringConvertible {
    
    case getTaggedProductsInStream(streamId: String, requestParameter: ProductRequestParameter?)
    case pinProductInStream
    case getPinnedProductInStream(streamId: String)
    case updateProductOffer
    case createProductOffer
    case removeTaggedProductFromStream
    
    case getAllStores(currentStoreId: String, isBusiness: Int)
    case getStoreProducts(storeId: String, page: Int)
    case getProductDetails(productId: String)
    
    var description: String {
        switch self {
        case .getTaggedProductsInStream:
            return "get tagged product in a stream."
        case .pinProductInStream:
            return "pin a product in stream."
        case .getPinnedProductInStream:
            return "get pinned product in stream."
        case .updateProductOffer:
            return "edit/update an offer for a product."
        case .createProductOffer:
            return "create an offer for a product."
        case .removeTaggedProductFromStream:
            return "remove tagged product from stream."
        case .getAllStores:
            return "Get list of stores"
        case .getStoreProducts:
            return "Get store products"
        case .getProductDetails:
            return "Get product details"
        }
    }
    
    var baseURL: URL{
        return URL(string:"https://api.soldlive.eu")!
    }
    
    var method: ISMLiveHTTPMethod {
        switch self {
        case .getTaggedProductsInStream, .getPinnedProductInStream, .getAllStores, .getStoreProducts, .getProductDetails:
            return .get
        case .updateProductOffer, .createProductOffer, .removeTaggedProductFromStream, .pinProductInStream:
            return .post
        }
    }
    
    var path: String {
        let path: String
        switch self {
        case .getTaggedProductsInStream:
            path = "/get/livestream/products"
        case .pinProductInStream:
            path = "/pin/livestream/product"
        case .getPinnedProductInStream:
            path = "/user/pinProduct/details"
        case .updateProductOffer:
            path = "/user/offer/edit"
        case .createProductOffer:
            path = "/create/livestream/offers"
        case .removeTaggedProductFromStream:
            path = "/remove/tagged/product"
        case .getAllStores:
            path = "/python/all/store/search"
        case .getStoreProducts:
            path = "/v1/get/productCatalogue"
        case .getProductDetails:
            path = "/python/product/details"
        }
        return path
    }
    
    var headers: [String : String]?{
        return [
            "storeCategoryId": ISMConfiguration.shared.storeCategoryId,
            "lang": ISMConfiguration.shared.lang,
            "language": ISMConfiguration.shared.language,
            "currencycode": ISMConfiguration.shared.currencyCode,
            "currencysymbol": ISMConfiguration.shared.currencySymbol
        ]
    }
    
    var queryParams: [String : String]? {
        var param: [String: String] = [:]
        
        switch self {
        case let .getTaggedProductsInStream(streamId, requestParameter):
            
            param = ["streamId": "\(streamId)"]
            
            if let requestParameter {
                
                if let skip = requestParameter.skip {
                    param += ["skip": "\(skip)"]
                }
                
                if let limit = requestParameter.limit {
                    param += ["limit": "\(limit)"]
                }
                
                if let query = requestParameter.query {
                    param += ["q": "\(query)"]
                }
                
            }
            
            break
        case let .getPinnedProductInStream(streamId):
            param = ["streamId": "\(streamId)"]
            break
        case let .getAllStores(currentStoreId, isBusiness):
            param = [
                "curretnStoreId": "\(currentStoreId)",
                "isBusiness": "\(isBusiness)"
            ]
            break
        case let .getStoreProducts(storeId, page):
            param = [
                "sId": "\(storeId)",
                "page": "\(page)"
            ]
        case let .getProductDetails(productId):
            param = [
                "productId": "\(productId)"
            ]
        default:
            break
        }
        
        return param
    }
    
}

public typealias ProductPayloadResponse = ((Result<Any?, IsometrikError>) -> Void)
