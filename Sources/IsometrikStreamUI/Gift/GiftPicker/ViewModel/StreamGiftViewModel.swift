//  Copyright © 2024 Rahul Sharma. All rights reserved.


import Foundation
import IsometrikStream
import UIKit
import AVFoundation
import SwiftData
import Combine

struct GiftsForGroupData {
    
    let groupId: String
    var giftData: [ISMStreamGiftModel]
    var totalCount: Int
    
    init(groupId: String, giftData: [ISMStreamGiftModel], totalCount: Int) {
        self.groupId = groupId
        self.giftData = giftData
        self.totalCount = totalCount
    }
    
}

@MainActor
class StreamGiftViewModel: ObservableObject {
    
    var isometrik: IsometrikSDK
    var streamInfo: ISMStream
    var recieverGiftData: ISMCustomGiftRecieverData
    
    private let persistence: GiftDataPersistence
    private var isLoadingGifts = false
    private var currentGroupId: String?
    
    var giftModelData: ISMStreamGiftModelData?
    var giftGroup: [ISMStreamGiftModel] = []
    var giftsInGroup: [GiftsForGroupData] = []
    var walletBalance: Float64 = 0
    
    @Published var categories: [CachedGiftCategoryModel] = []
    @Published var gifts: [CachedGiftModel] = []
    
    var skipForGroup = 0
    var skipForGroupItems = 0
    var limit = 10
    let contentViewHeight: CGFloat = UIScreen.main.bounds.height * 0.6
    
    // selected gift group data
    var selectedGiftGroupData: ISMStreamGiftModel?
    var selectedGroupTitle: String = ""
    
    // callbacks
    var sendGift: ((_ giftData: StreamMessageGiftModel) -> Void)?
    var buyCoins: (() -> Void)?
    
    var audioPlayer: AVAudioPlayer?
    
    // Cache duration in seconds (24 hours)
    private let cacheDuration: TimeInterval = 24 * 60 * 60
    private let lastCacheClearKey = "lastCacheClearTimestamp"
    private let userDefaults = UserDefaults.standard
    
    init(isometrik: IsometrikSDK, streamInfo: ISMStream, recieverGiftData: ISMCustomGiftRecieverData) {
        self.isometrik = isometrik
        self.streamInfo = streamInfo
        self.recieverGiftData = recieverGiftData
        
        do {
            self.persistence = try GiftDataPersistence()
            checkAndClearExpiredCache()
        } catch {
            fatalError("Failed to initialize GiftDataPersistence: \(error)")
        }
    }
    
    // MARK: - Service funtions
    
    func getGiftGroups(_ completion: @escaping(_ response: [ISMStreamGiftModel]?, _ errorString: String?) -> Void){
        
        isometrik.getIsometrik().getGiftCategories(skip: skipForGroup, limit: limit) { result in
            
            guard let giftGroup = result.data
            else {
                DispatchQueue.main.async {
                    completion(nil, "Unknown")
                }
                return
            }
            
//            if self.giftGroup.isEmpty {
//                self.giftGroup = giftGroup
//            } else {
//                self.giftGroup.append(contentsOf: giftGroup)
//            }
//            
//            if self.giftGroup.count.isMultiple(of: self.limit) {
//                self.skipForGroup += self.limit
//            }
            
//            self.updateGiftItemGroup()
            
            DispatchQueue.main.async {
                completion(giftGroup, nil)
            }
            
        } failure: { error in
            DispatchQueue.main.async {
                completion(nil, error.localizedDescription)
            }
        }
        
    }
    
    func getGiftForGroups(giftGroupId: String, skip: Int, _ completion: @escaping(_ response: [ISMStreamGiftModel]?, _ errorString: String?) -> Void){
        
        isometrik.getIsometrik().getGiftForACategory(giftGroupId: giftGroupId, skip: skip, limit: limit) { result in
            
            guard let giftsInGroup = result.data,
                  let totalCount = result.totalCount
            else {
                DispatchQueue.main.async {
                    completion(nil, "Unknown")
                }
                return
            }
            
            //self.updateGiftGroupItems(giftData: giftsInGroup, totalCount: totalCount, groupId: giftGroupId)
            
            DispatchQueue.main.async {
                completion(giftsInGroup, nil)
            }
            
        } failure: { error in
            
            let error = "error while encoding = \(error.localizedDescription)"
            DispatchQueue.main.async {
                completion(nil, error)
            }
            
        }
        
    }
    
    func transferGifts(_ bodyData: GiftBody ,_ completion:@escaping (_ result: ISMGiftResponseModel?, _ error: String?) -> Void){
        
        isometrik.getIsometrik().transferGifts(bodyData) { result in
            DispatchQueue.main.async {
                completion(result, nil)
            }
        } failure: { error in
            let error = "error while encoding = \(error.localizedDescription)"
            DispatchQueue.main.async {
                completion(nil, error)
            }
        }
    }
    
    func getWalletBalance(completion: @escaping(_ success: Bool, _ error: String?)->Void){
        isometrik.getIsometrik().getWalletBalance(currencyType: ISMWalletCurrencyType.coin.getValue){ response in
            self.walletBalance = response.data?.balance ?? 0
            UserDefaultsProvider.shared.setWalletBalance(data: self.walletBalance, currencyType: ISMWalletCurrencyType.coin.getValue)
            DispatchQueue.main.async {
                completion(true, nil)
            }
        } failure: { error in
            DispatchQueue.main.async {
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func fetchGiftCategories(_ completion: @escaping () -> Void) {
        do {
            let cachedCategories = try persistence.fetchGiftCategories()
            
            if !cachedCategories.isEmpty {
                categories = cachedCategories
                DispatchQueue.main.async {
                    completion()
                }
            } else {
                self.getGiftGroups { response, errorString in
                    
                    guard let response else {
                        DispatchQueue.main.async {
                            completion()
                        }
                        return
                    }
                    var parsedCategories = [CachedGiftCategoryModel]()
                    
                    response.forEach { category in
                        let giftCategory = CachedGiftCategoryModel(
                            id: category.id ?? "",
                            giftTitle: category.giftTitle ?? "",
                            giftImage: category.giftImage ?? "",
                            giftCount: category.giftCount ?? 0
                        )
                        parsedCategories.append(giftCategory)
                    }
                    
                    if !parsedCategories.isEmpty {
                        self.categories = parsedCategories
                        do {
                            try self.persistence.saveGiftCategories(parsedCategories)
                            DispatchQueue.main.async {
                                completion()
                            }
                        } catch {
                            print(error)
                            DispatchQueue.main.async {
                                completion()
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion()
                        }
                    }
                }
            }
            
        } catch {
            print("Error fetching categories: \(error)")
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func fetchGifts(forGroupId groupId: String, resetPagination: Bool = false, _ completion: @escaping ()->Void) {
        
        // Return if already loading
        guard !isLoadingGifts else {
            DispatchQueue.main.async {
                completion()
            }
            return
        }
        
        // Reset if new category selected or explicitly requested
        if currentGroupId != groupId || resetPagination {
            gifts.removeAll()
            currentGroupId = groupId
        }
        
        // Get current category and check gift count
        guard let currentCategory = categories.first(where: { $0.id == groupId }),
              gifts.count < currentCategory.giftCount else {
            DispatchQueue.main.async {
                completion()
            }
            return
        }
        
        self.isLoadingGifts = true
        
        do {
            // First check if we have all gifts cached
            let cachedGifts = try persistence.fetchGifts(forGroupId: groupId)
            
            if cachedGifts.count >= currentCategory.giftCount {
                // We have all gifts cached, no need to hit API
                if resetPagination {
                    gifts = cachedGifts
                } else {
                    gifts.append(contentsOf: cachedGifts.dropFirst(gifts.count))
                }
                isLoadingGifts = false
                
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
            
            self.getGiftForGroups(giftGroupId: groupId, skip: gifts.count) { response, errorString in
                
                self.isLoadingGifts = false
                
                if let response {
                    
                    let parsedGifts = response.map { gift in
                        CachedGiftModel(
                            id: gift.id ?? "",
                            giftTitle: gift.giftTitle ?? "",
                            giftAnimationImage: gift.giftAnimationImage ?? "",
                            giftImage: gift.giftImage ?? "",
                            giftTag: gift.giftTag ?? "",
                            virtualCurrency: gift.virtualCurrency ?? 0,
                            giftGroupId: gift.giftGroupId ?? ""
                        )
                    }
                    
                    if !parsedGifts.isEmpty {
                        if resetPagination {
                            self.gifts = parsedGifts
                        } else {
                            self.gifts.append(contentsOf: parsedGifts)
                        }
                        
                        do {
                            try self.persistence.saveGifts(parsedGifts)
                            DispatchQueue.main.async {
                                completion()
                            }
                        } catch {
                            DispatchQueue.main.async {
                                completion()
                            }
                            print(error)
                        }
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            }
            
        } catch {
            isLoadingGifts = false
            print("Error fetching gifts: \(error)")
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    
    // MARK: - Helper functions
    
    func updateGiftItemGroup(){
        
        guard giftGroup.count > 0 else { return }
        
        giftGroup.forEach { gift in
            
            // TODO: Think for the scenario when doing this, while pagination for the groups
            
            // inserting for the first time
            let giftData = GiftsForGroupData(groupId: gift.id.unwrap, giftData: [], totalCount: 0)
            self.giftsInGroup.append(giftData)
            
        }
        
    }
    
    func updateGiftGroupItems(giftData data : [ISMStreamGiftModel], totalCount: Int, groupId id: String){
        
        guard giftsInGroup.count > 0 else { return }
        
        let updatedGiftArray = giftsInGroup.map { gift in
            if gift.groupId == id {
                var mutableGift = gift
                
                if gift.giftData.count < totalCount {
                    mutableGift.giftData.append(contentsOf: data)
                }
                mutableGift.totalCount = totalCount
                
                return mutableGift
            } else {
                return gift
            }
        }
        
        self.giftsInGroup = updatedGiftArray
        
    }
    
    func getGiftItemsForGroup(groupId id: String) -> ([ISMStreamGiftModel], Int) {
        
        guard giftsInGroup.count > 0 else { return ([],0) }
        
        var giftItemsData: [ISMStreamGiftModel] = []
        var totalCount = 0
        
        for gift in giftsInGroup {
            if gift.groupId == id {
                giftItemsData = gift.giftData
                totalCount = gift.totalCount
                break
            }
        }
        
        return (giftItemsData, totalCount)
        
    }
    
    func sendGift(giftData: CachedGiftModel){
        
        // TODO: add check for wallet balance here...
        
        let paramBody = GiftBody(
            senderId: isometrik.getUserSession().getUserId(),
            isometricToken: isometrik.getIsometrik().configuration.userToken,
            receiverCurrency: "INR",
            receiverStreamId: recieverGiftData.recieverStreamId ,
            currency: "COIN",
            receiverUserId: recieverGiftData.recieverStreamUserId,
            amount: Int(giftData.virtualCurrency ?? 0),
            reciverUserType: recieverGiftData.recieverUserType,
            pkId: isometrik.getUserSession().getPKBattleId(),
            giftId: giftData.id ?? "NA",
            giftUrl: giftData.giftAnimationImage ?? "NA",
            giftTitle: giftData.giftTitle ?? "NA",
            giftThumbnailUrl: giftData.giftImage ?? "",
            IsGiftVideo: false,
            isPk: (isometrik.getUserSession().getPKStatus() == .on),
            receiverName: recieverGiftData.recieverName,
            messageStreamId: streamInfo.streamId ?? "NA",
            deviceId: UIDevice.current.identifierForVendor?.uuidString ?? ""
        )
        
        transferGifts(paramBody) { result, error in
            if error == nil {
                let giftModel = StreamMessageGiftModel(
                    message: giftData.giftAnimationImage,
                    giftName: giftData.giftTitle,
                    giftCategoryName: self.selectedGroupTitle,
                    coinsValue: Int(giftData.virtualCurrency ?? 0),
                    giftThumbnailUrl: giftData.giftImage,
                    reciverStreamUserId: self.recieverGiftData.recieverStreamUserId
                )
                
                self.sendGift?(giftModel)
            }
        }
        
    }
    
    // MARK: - GET SKIP OPERATIONS

    func getSkipValueForGroup(groupId id: String) -> Int {
        
        guard giftsInGroup.count > 0 else { return 0 }
        
        var currentGiftCount = 0
        
        for gift in giftsInGroup {
            if gift.groupId == id {
                currentGiftCount = gift.giftData.count
                break
            }
        }
        
        return Int(currentGiftCount / self.limit) * self.limit
        
    }
    
    
    // MARK: - CACHE OPERATIONS
    
    private func checkAndClearExpiredCache() {
        let lastClearTime = userDefaults.double(forKey: lastCacheClearKey)
        let currentTime = Date().timeIntervalSince1970
        
        if lastClearTime == 0 {
            // First time app launch, set initial timestamp
            userDefaults.set(currentTime, forKey: lastCacheClearKey)
        } else if currentTime - lastClearTime >= cacheDuration {
            // Clear cache if 24 hours have passed
            clearCache()
            userDefaults.set(currentTime, forKey: lastCacheClearKey)
        }
    }
    
    func clearCache() {
        do {
            try persistence.clearAllData()
            categories.removeAll()
            gifts.removeAll()
            print("Cache cleared at: \(Date())")
        } catch {
            print("Error clearing cache: \(error)")
        }
    }
    
}
