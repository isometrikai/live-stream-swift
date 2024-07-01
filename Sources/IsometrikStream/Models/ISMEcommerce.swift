//
//  ISMEcommerce.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 08/10/22.
//

import Foundation

// MARK: - FetchProductBody
public struct ISMEcommerceProducts: Codable {
    let products: [ISMExistingProduct]?
    let productDetails: ISMExistingProduct?
    let totalProductsCount: Int?
    let msg: String?
    let errorCode: Int?
    let error: String?
}

// MARK: - Product
public struct ISMExistingProduct: Codable {
    let timeStamp: Int64?
    var quantity: Int?
    var quantitySelected: Int = 1
    let productName, productID: String?
    let productAlreadyInCart: Bool?
    let metadata: ProductMetadata?
    let externalProductID: String?
    let count: Int?
    var featuring: Bool? = false
    var linked: Bool = false

    enum CodingKeys: String, CodingKey {
        case productName
        case timeStamp
        case quantity
        case productAlreadyInCart
        case productID = "productId"
        case metadata
        case featuring
        case externalProductID = "externalProductId"
        case count
    }
}

// MARK: - Metadata
public struct ProductMetadata: Codable {
    let productImageUrl: String?
    let price: Int?
    let originalPrice: Int?
    let metadataDescription, currencySymbol: String?
    let attributes: [ProductAttributes]?

    enum CodingKeys: String, CodingKey {
        case price
        case attributes
        case originalPrice
        case productImageUrl
        case metadataDescription = "description"
        case currencySymbol
    }
}

public struct ProductAttributes: Codable {
    let color: [String]?
    let strapColor: [String]?
    let colorUnits: [String]?
    let size: [String]?
    enum CodingKeys: String, CodingKey {
        case color = "Color"
        case strapColor = "Strap color"
        case colorUnits = "Color units"
        case size = "Size"
    }
}

public struct ISMCheckoutModelData: Codable {
    let msg: String?
    let checkoutSecret: String?
    let checkoutDetails: ISMCheckoutDetails?
}

public struct ISMCheckoutDetails: Codable {
    let externalCheckoutLink: String?
    let checkoutLinkBearerToken: String?
    let checkoutLinkBasicUsername: String?
    let checkoutLinkBasicPassword: String?
    let checkoutLinkAuthType: Int?
    let checkoutLinkApiValue: String?
    let checkoutLinkApiKey: String?
    let checkoutLinkApiAddTo: Int?
}

public struct ISMConfirmResponse: Codable {
    let msg: String?
    let error: String?
    let errorCode: Int?
}
