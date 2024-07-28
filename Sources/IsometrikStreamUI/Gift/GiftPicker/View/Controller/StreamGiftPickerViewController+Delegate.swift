
import Foundation
import AVFoundation
import IsometrikStream

extension StreamGiftPickerViewController: GiftGroupActionProtocol, StreamGiftItemActionProtocol {
    
    func didGiftItemSelected(giftData: ISMStreamGiftModel) {
        
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
    
    func callForNextPage(groupId: String) {
        
        // get from server
        self.viewModel.getGiftForGroups(giftGroupId: groupId) { success, error in
            if success {
                let data = self.viewModel.getGiftItemsForGroup(groupId: groupId)
                if data.0.isEmpty {
                    self.contentView.giftContentItemView.defaultView.isHidden = false
                }
                self.contentView.giftContentItemView.totalCount = data.1
                self.contentView.giftContentItemView.data = data.0
            } else {
                // show error
            }
        }
    }
    
    func giftGroupTapped(groupId: String, giftGroupTitle: String) {
        viewModel.selectedGroupTitle = giftGroupTitle
        loadGiftItemsForGroup(groupId: groupId)
    }
    
    func loadDataInitially(){
        
        let group = DispatchGroup()
        group.enter()
        
        contentView.startAnimating()
        
        viewModel.getGiftGroups { success, error in
            
            if success {
                if self.viewModel.giftGroup.count > 0 {
                    
                    // update the collections
                    self.contentView.giftGroupHeaderView.data = self.viewModel.giftGroup
                    self.contentView.giftGroupHeaderView.collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
                    
                    group.leave()
                } else {
                    self.contentView.stopAnimating()
                }
            } else {
                self.contentView.stopAnimating()
                // show error
            }
            
        }
        
        group.notify(queue: .main) {
            
            guard let giftsForGroupData = self.viewModel.selectedGiftGroupData,
                  let giftGroupId = giftsForGroupData.id
            else {
                self.contentView.stopAnimating()
                return
            }
            
            self.loadGiftItemsForGroup(groupId: giftGroupId)
        }
        
    }
    
    func loadGiftItemsForGroup(groupId id: String) {
        
        let giftData = self.viewModel.getGiftItemsForGroup(groupId: id)
        
        self.contentView.giftContentItemView.totalCount = giftData.1
        self.contentView.giftContentItemView.data = giftData.0
        self.contentView.giftContentItemView.defaultView.isHidden = true
        
        if giftData.0.isEmpty {
            
            self.contentView.startAnimating()
            
            // get from server
            self.viewModel.getGiftForGroups(giftGroupId: id) { success, error in
                self.contentView.stopAnimating()
                if success {
                    let data = self.viewModel.getGiftItemsForGroup(groupId: id)
                    if data.0.isEmpty {
                        self.contentView.giftContentItemView.defaultView.isHidden = false
                    }
                    self.contentView.giftContentItemView.totalCount = data.1
                    self.contentView.giftContentItemView.data = data.0
                } else {
                    // show error
                }
            }
            
        } else {
            
            // show saved items
            self.contentView.stopAnimating()
            self.contentView.giftContentItemView.totalCount = giftData.1
            self.contentView.giftContentItemView.data = giftData.0
            
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
