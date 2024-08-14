//
//  EcommerceRouter.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 12/11/22.
//

import Foundation
import UIKit

enum EcommerceRouter: ISMLiveURLConvertible, CustomStringConvertible {
    
    case addProductToCart(streamId: String, quantity: Int, productId: String)
    case fetchProductsInCart(streamId: String, bodyData: EcommerceBody?)
    case removeProductFromCart(streamId: String, productId: String)
    case updateProductQuantityInCart(streamId: String, productId: String, quantity: Int)
    case checkoutCart(streamId: String)
    case fetchProductDetails(productId: String)
    case fetchProducts
    case updateProductInventory(count: Int, productId: String)
    case fetchLinkedProduct(streamId: String)
    
    case fetchCartProductDetails(streamId: String, productId: String)
    case fetchFeaturingProduct(streamId: String)
    case updateFeaturingProductStatus(streamId: String, startFeaturing: Bool, productId: String)
    
    var description: String {
      switch self {
      case .addProductToCart:
          return "Add product to cart call."
      case .fetchProductsInCart:
          return "Fetch Product in cart call."
      case .removeProductFromCart:
          return "Remove product from cart call."
      case .updateProductQuantityInCart:
          return "Update product quantity in cart call."
      case .checkoutCart:
          return "Checkout cart call."
      case .fetchProductDetails:
          return "Fetch product details call."
      case .fetchProducts:
          return "Fetch products call."
      case .updateProductInventory:
          return "Update product inventory call"
      case .fetchLinkedProduct:
          return "Fetch linked product call"
      case .fetchCartProductDetails:
          return "Fetch cart product details call."
      case .fetchFeaturingProduct:
          return "Fetch featuring product call."
      case .updateFeaturingProductStatus:
          return "Update featuring product status call."
      }
    }
    
    var baseURL: URL{
        return URL(string:"\(ISMConfiguration.shared.primaryOrigin)")!
    }
    
    var method: ISMLiveHTTPMethod {
        switch self {
        case .updateFeaturingProductStatus:
          return .put
        case .addProductToCart, .checkoutCart:
          return .post
        case .removeProductFromCart:
          return .delete
      case .updateProductInventory, .updateProductQuantityInCart:
          return .patch
        default:
          return .get
        }
    }
    
    var path: String {
        let path: String
        switch self {
        case .fetchProducts :
            path = "/streaming/v2/ecommerce/products"
        case .fetchLinkedProduct:
            path = "/streaming/v2/ecommerce/session/products"
        case .updateFeaturingProductStatus:
            path = "/streaming/v2/ecommerce/featuring/product"
        case .fetchFeaturingProduct:
            path = "/streaming/v2/ecommerce/featuring/product"
        case .addProductToCart:
            path = "/streaming/v2/ecommerce/cart/product"
        case .fetchProductDetails:
            path = "/streaming/v2/ecommerce/product/details"
        case .fetchProductsInCart:
            path = "/streaming/v2/ecommerce/cart/products"
        case .removeProductFromCart:
            path = "/streaming/v2/ecommerce/cart/product"
        case .fetchCartProductDetails:
            path = "/streaming/v2/ecommerce/session/product/details"

        case .checkoutCart:
            path = "/streaming/v2/ecommerce/checkout"
        case .updateProductInventory:
            path = "/streaming/v2/ecommerce/product/inventory"
        case .updateProductQuantityInCart:
            path = "/streaming/v2/ecommerce/cart/product/quantity"
        }
        return path
    }
    
    // We are sending default headers for api, add additonal headers here
    var headers: [String : String]?{
        return nil
    }
    
    var queryParams: [String : String]? {
        var param: [String: String] = [:]
        
        switch self {
        case let .fetchProductsInCart(streamId, bodyData):
            
            param = ["streamId": "\(streamId)"]
            if let bodyData {
                if let skip = bodyData.skip {
                    param += ["skip": "\(skip)"]
                }
            }
            break
            
        case let .removeProductFromCart(streamId, productId):
            param = [
                "streamId": "\(streamId)",
                "productId": "\(productId)"
            ]
            break
        case .updateProductInventory(_,_):
            break
        case let .fetchLinkedProduct(streamId):
            param = ["streamId": "\(streamId)"]
            break
        case let .fetchCartProductDetails(streamId, productId):
            param = [
                "streamId": "\(streamId)",
                "productId": "\(productId)"
            ]
            break
        case let .fetchFeaturingProduct(streamId):
            param = [
                "streamId": "\(streamId)"
            ]
            break
        default:
            break
        }
        
        return param
    }
    
}

public typealias EcommercePayloadResponse = ((Result<Any?, IsometrikError>) -> Void)

