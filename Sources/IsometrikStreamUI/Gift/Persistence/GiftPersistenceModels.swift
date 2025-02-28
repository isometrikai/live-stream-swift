//
//  File.swift
//  IsometrikStream
//
//  Created by Appscrip 3Embed on 19/02/25.
//

import SwiftData

@Model
final class CachedGiftCategoryModel {
    @Attribute(.unique) var id: String
    var giftTitle: String
    var giftImage: String
    var giftCount: Int
    
    init(id: String, giftTitle: String, giftImage: String, giftCount: Int) {
        self.id = id
        self.giftTitle = giftTitle
        self.giftImage = giftImage
        self.giftCount = giftCount
    }
}

@Model
final class CachedGiftModel {
    @Attribute(.unique) var id: String
    var giftTitle: String
    var giftAnimationImage: String
    var giftImage: String
    var giftTag: String
    var virtualCurrency: Int
    var giftGroupId: String
    
    init(id: String, giftTitle: String, giftAnimationImage: String, giftImage: String, giftTag: String, virtualCurrency: Int, giftGroupId: String) {
        self.id = id
        self.giftTitle = giftTitle
        self.giftAnimationImage = giftAnimationImage
        self.giftImage = giftImage
        self.giftTag = giftTag
        self.virtualCurrency = virtualCurrency
        self.giftGroupId = giftGroupId
    }
}


