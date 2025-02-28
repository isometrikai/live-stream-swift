
import Foundation
import AVFoundation
import IsometrikStream
import UIKit

extension StreamGiftPickerViewController: GiftGroupActionProtocol, StreamGiftItemActionProtocol {
    
    func didGiftItemSelected(giftData: CachedGiftModel) {
        
        // change the coin and reflect the UI
        let coinValue = Int64(giftData.virtualCurrency ?? 0)
        let balance = Int64(viewModel.walletBalance)
        let diffInValue = balance - coinValue
        
        if balance < coinValue {
            ism_showAlert("Insufficient Balance!", message: "Sorry! insufficient balance to make this transfer.")
            return
        }

        viewModel.walletBalance = Float64(diffInValue)
        contentView.headerView.coinAmount.text = "\(diffInValue) coins"
        
        // transfer gift api here
        viewModel.sendGift(giftData: giftData)
        
        // animate coins
        self.showCoinAnimation(coins: String(giftData.virtualCurrency ?? 0))
    }
    
    func giftGroupTapped(groupId: String, giftGroupTitle: String) {
        viewModel.selectedGroupTitle = giftGroupTitle
        loadGiftItemsForGroup(groupId: groupId)
    }
    
    func loadDataInitially(){
        
        let groupCollection = contentView.giftGroupHeaderView.collectionView
        let groupContentCollection = contentView.giftContentItemView.collectionView
        
        let group = DispatchGroup()
        group.enter()
        
        groupCollection.showAnimatedSkeleton(usingColor: UIColor.colorWithHex(color: "#343434"), transition: .crossDissolve(0.25))
        
        viewModel.fetchGiftCategories {
            
            groupCollection.hideSkeleton(transition: .crossDissolve(0.25))
            self.contentView.giftGroupHeaderView.data = self.viewModel.categories
            self.contentView.giftGroupHeaderView.collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            
            group.leave()
            
        }
        
        group.notify(queue: .main) {
            
            guard let giftsForGroupData = self.viewModel.selectedGiftGroupData,
                  let giftGroupId = giftsForGroupData.id
            else {
                return
            }
            
            self.loadGiftItemsForGroup(groupId: giftGroupId)
        }
        
    }
    
    func loadGiftItemsForGroup(groupId id: String) {
        
        let groupContentCollection = contentView.giftContentItemView.collectionView
        
        self.contentView.giftContentItemView.defaultView.isHidden = true
        groupContentCollection.showAnimatedSkeleton(usingColor: UIColor.colorWithHex(color: "#343434"), transition: .crossDissolve(0.25))
        
        self.viewModel.fetchGifts(forGroupId: id) {
            groupContentCollection.hideSkeleton(transition: .crossDissolve(0.25))
            
            if self.viewModel.gifts.isEmpty {
                self.contentView.giftContentItemView.defaultView.isHidden = false
            } else {
                self.contentView.giftContentItemView.defaultView.isHidden = true
            }
            
            self.contentView.giftContentItemView.data = self.viewModel.gifts
        }
        
    }
    
}

extension StreamGiftPickerViewController {
    
    func playCoinsSound() {
        
        let coinDropPath = appearance.sounds.coinDrop
        guard let url = URL(string: coinDropPath) else { return }
        do{
            viewModel.audioPlayer = try AVAudioPlayer(contentsOf: url)
            viewModel.audioPlayer?.prepareToPlay()
            viewModel.audioPlayer?.play()
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    func showCoinAnimation(coins: String){
        self.playCoinsSound()
        for i in 1..<7 {
            self.view.ism_applyCoinsAnimation(
                indexAt:i,
                fromView: self.contentView.headerView.balanceLabel,
                coins: coins,
                image: appearance.images.coin
            )
        }
    }
    
}
