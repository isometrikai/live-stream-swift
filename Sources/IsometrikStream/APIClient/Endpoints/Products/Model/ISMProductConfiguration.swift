//
//  ISMProductConfiguration.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 21/05/24.
//

import Foundation

public struct ISMProductConfiguration {
    
    public var storeCategoryId: String
    public var lang: String
    public var language: String
    public var currencyCode: String
    public var currencySymbol: String
    
    public init(storeCategoryId: String, lang: String, language: String, currencyCode: String, currencySymbol: String) {
        self.storeCategoryId = storeCategoryId
        self.lang = lang
        self.language = language
        self.currencyCode = currencyCode
        self.currencySymbol = currencySymbol
    }
    
}
