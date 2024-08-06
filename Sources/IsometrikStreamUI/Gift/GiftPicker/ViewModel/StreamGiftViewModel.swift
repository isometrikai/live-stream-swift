//  Copyright © 2024 Rahul Sharma. All rights reserved.


import Foundation
import IsometrikStream
import UIKit
import AVFoundation

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

class StreamGiftViewModel {
    
    var isometrik: IsometrikSDK
    var streamInfo: ISMStream
    var recieverGiftData: ISMCustomGiftRecieverData
    private var dataPersistenceService: DataPersistenceService?
    
    var giftModelData: ISMStreamGiftModelData?
    var giftGroup: [ISMStreamGiftModel] = []
    var giftsInGroup: [GiftsForGroupData] = []
    var walletBalance: Float64 = 0
    
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
    
    init(isometrik: IsometrikSDK, streamInfo: ISMStream, recieverGiftData: ISMCustomGiftRecieverData) {
        self.isometrik = isometrik
        self.streamInfo = streamInfo
        self.recieverGiftData = recieverGiftData
        createDataPersistenceServiceContainer()
    }
    
    // MARK: - DataPersistence service
    
    func createDataPersistenceServiceContainer() {
        
//        let dataPersistenceService = DataPersistenceService.getInstance()
//        dataPersistenceService.createContainer(persistentModel: PersistenceGiftModel.self)
//        dataPersistenceService.createContainer(persistentModel: PersistenceGiftCategoryModel.self)
//        self.dataPersistenceService = dataPersistenceService
        
    }
    
    // MARK: - Service funtions
    
    func getGiftGroups(_ completion: @escaping(_ success: Bool, _ errorString: String?) -> Void){
        
        isometrik.getIsometrik().getGiftCategories(skip: skipForGroup, limit: limit) { result in
            
            guard let giftGroup = result.data
            else {
                DispatchQueue.main.async {
                    completion(false, "Unknown")
                }
                return
            }
            
            if self.giftGroup.isEmpty {
                self.giftGroup = giftGroup
            } else {
                self.giftGroup.append(contentsOf: giftGroup)
            }
            
            if self.giftGroup.count.isMultiple(of: self.limit) {
                self.skipForGroup += self.limit
            }
            
            self.updateGiftItemGroup()
            
            DispatchQueue.main.async {
                completion(true, nil)
            }
            
        } failure: { error in
            DispatchQueue.main.async {
                completion(false, error.localizedDescription ?? "")
            }
        }
        
    }
    
    func getGiftForGroups(giftGroupId: String, _ completion: @escaping(_ success: Bool, _ errorString: String?) -> Void){
        
        let skipValue = getSkipValueForGroup(groupId: giftGroupId)
        
        isometrik.getIsometrik().getGiftForACategory(giftGroupId: giftGroupId, skip: skipValue, limit: limit) { result in
            
            guard let giftsInGroup = result.data,
                  let totalCount = result.totalCount
            else {
                DispatchQueue.main.async {
                    completion(false, "Unknown")
                }
                return
            }
            
            self.updateGiftGroupItems(giftData: giftsInGroup, totalCount: totalCount, groupId: giftGroupId)
            
            DispatchQueue.main.async {
                completion(true, nil)
            }
            
        } failure: { error in
            
            let error = "error while encoding = \(error.localizedDescription)"
            DispatchQueue.main.async {
                completion(false, error)
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
        isometrik.getIsometrik().getWalletBalance(currencyType: WalletCurrencyType.coin.getValue){ response in
            self.walletBalance = response.data?.balance ?? 0
            UserDefaultsProvider.shared.setWalletBalance(data: self.walletBalance, currencyType: WalletCurrencyType.coin.getValue)
            DispatchQueue.main.async {
                completion(true, nil)
            }
        } failure: { error in
            DispatchQueue.main.async {
                completion(false, error.localizedDescription)
            }
        }
    }
    
    //:
    
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
    
    func sendGift(giftData: ISMStreamGiftModel){
        
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
                    message: giftData.giftAnimationImage.unwrap,
                    giftName: giftData.giftTitle.unwrap,
                    giftCategoryName: self.selectedGroupTitle,
                    coinsValue: Int(giftData.virtualCurrency ?? 0),
                    giftThumbnailUrl: giftData.giftImage.unwrap,
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
    
}
