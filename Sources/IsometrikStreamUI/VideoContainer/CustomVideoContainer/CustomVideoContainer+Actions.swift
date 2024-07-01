//
//  CustomVideoContainer+Actions.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 24/06/24.
//

import UIKit
import IsometrikStream

extension CustomVideoContainer {
    
    func refreshLayout(streamInfo: ISMStream?){
        //reorderSessions()
        guard let streamInfo else { return }
        
        if streamInfo.rtmpIngest.unwrap {
            self.videoContainerCollectionView.contentInset = UIEdgeInsets(top: ism_windowConstant.getTopPadding + 90, left: 0, bottom: 0, right: 0)
        } else {
            self.videoContainerCollectionView.contentInset = UIEdgeInsets(top: videoSessions.count > 1 ? ism_windowConstant.getTopPadding + 90 : 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func reorderSessions(){
        guard let isometrik else { return }
        
        var sessions = self.videoSessions
        let currUserId = isometrik.getUserSession().getUserId().ism_userIdUInt()
        var currUserSession: VideoSession?

        let group = DispatchGroup()
        group.enter()
        
        // Remove required session from array first
        for i in 0..<sessions.count {
            
            /// otherwise host session to top `For viewers`
            if sessions[i].userData?.isAdmin ?? false {
                currUserSession = sessions[i]
                sessions.remove(at: i)
                group.leave()
                break
            }
        }

        group.notify(queue: .main) {
            // Append required session to top
            if let currUserSession = currUserSession {
                sessions.insert(currUserSession, at: 0)
                self.videoSessions = sessions
                self.videoContainerCollectionView.reloadData()
            }
        }
    }
    
    func refreshPKView(){
        
        guard let isometrik = isometrik,
              let streamInfo = streamInfo
        else { return }
        
        if streamInfo.isPkChallenge.unwrap {
            if !isometrik.isPKBattlesEnabled() {
                pkOverlayView.isHidden = true
            } else {
                if videoSessions.count > 1 {
                    pkOverlayView.isHidden = false
                    if isometrik.getUserSession().getUserType() == .host {
                        /// Perform versus animation
                        pkOverlayView.vsAnimatedView.isHidden = true
                        if isometrik.getUserSession().getPKStatus() == .off {
                            pkOverlayView.animateVSAndStartView()
                        }
                        pkOverlayView.hostToggleButton.isHidden = true
                    } else if isometrik.getUserSession().getUserType() == .member {
                        pkOverlayView.startPKBattleButton.isHidden = true
                        pkOverlayView.animateVSView()
                        pkOverlayView.hostToggleButton.isHidden = true
                    } else {
                        if isometrik.getUserSession().getPKStatus() == .on {
                            pkOverlayView.hostToggleButton.isHidden = false
                        } else {
                            pkOverlayView.hostToggleButton.isHidden = true
                        }
                    }
                } else {
                    pkOverlayView.isHidden = true
                }
            }
        } else {
            pkOverlayView.isHidden = true
        }
        
    }
    
    func refreshBattleProgress(){
        
        let battleProgressView = self.pkOverlayView.battleProgressView
        guard let isometrik = isometrik else { return }
        
        if battleOn ?? false {
            if isometrik.getUserSession().getUserType() == .host || isometrik.getUserSession().getUserType() == .member {
                pkOverlayView.hostToggleButton.isHidden = true
            } else {
                pkOverlayView.hostToggleButton.isHidden = false
            }
            battleProgressView.isHidden = false
        } else {
            battleProgressView.isHidden = true
            pkOverlayView.hostToggleButton.isHidden = true
        }
        
        guard let giftData = giftData else {
            battleProgressView.startAnimationLayer(from: currentPoint, to: 0.5)
            currentPoint = 0.5
            DispatchQueue.main.async {
                self.animateProgressLabelsWithCoins(streamer1Coin: 0, streamer2Coin: 0)
            }
            return
        }
        
        // calculation of coins and percentage to show here
        
        let streamer1Coin = Double(giftData.streamer1?.coins ?? 0)
        let streamer2Coin = Double(giftData.streamer2?.coins ?? 0)
        
        DispatchQueue.main.async {
            self.animateProgressLabelsWithCoins(streamer1Coin: streamer1Coin, streamer2Coin: streamer2Coin)
        }
        
        // append the coin count
        battleProgressView.label1.text = "\(Int(streamer1Coin))"
        battleProgressView.label2.text = "\(Int(streamer2Coin))"
        
        print("COINS FOR STREAMER 1 \(giftData.streamer1?.firstName ?? "")")
        print("COINS FOR STREAMER 2 \(giftData.streamer1?.firstName ?? "")")
        
        let percStreamer1 = (streamer1Coin / (streamer1Coin + streamer2Coin))
        
        // setuplayer
        /// set pink color for the host
        
        battleProgressView.startAnimationLayer(from: currentPoint, to: percStreamer1)
        
        currentPoint = CGFloat(percStreamer1)
        
    }
    
    func refreshBanners(){
        
        let congratsBanner = pkOverlayView.congratulationBannerView
        
        guard let winnerData = winnerData, videoSessions.count > 0 else {
            
            // for draw condition
            congratsBanner.isHidden = false
            congratsBanner.titleLabel.text = "It's a Draw!".ism_localized
            congratsBanner.backgroundColor = Appearance.default.colors.appDeepBlue
            
            // show draw status image
            pkOverlayView.drawStatusImage.isHidden = false
            pkOverlayView.playDrawStatusAnimation()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                congratsBanner.isHidden = true
                self.pkOverlayView.drawStatusImage.isHidden = true
            }
            
            return
        }
        
        
        let group = DispatchGroup()
        group.enter()
        
        // get user data
        var userData: ISMMember?
        for i in 0..<self.videoSessions.count {
            let userId = self.videoSessions[i].userData?.userID
            if userId == winnerData.data?.winnerId {
                userData = self.videoSessions[i].userData
                group.leave()
                break
            }
        }
        
        group.notify(queue: .main) {
            congratsBanner.isHidden = false
            congratsBanner.backgroundColor = Appearance.default.colors.appPink
            congratsBanner.titleLabel.text = "Congratulation to " + "@\(userData?.userName ?? "")"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                congratsBanner.isHidden = true
            }
        }
        
        
    }
    
    func animateProgressLabelsWithCoins(streamer1Coin: Double, streamer2Coin: Double){
        
        let battleProgressView = self.pkOverlayView.battleProgressView
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            if self.currentStreamer1Coin != Int(streamer1Coin) {
                self.currentStreamer1Coin = Int(streamer1Coin)
                battleProgressView.label1.transform = .init(scaleX: 1.5, y: 1.5)
            }
            if self.currentStreamer2Coin != Int(streamer2Coin) {
                self.currentStreamer2Coin = Int(streamer2Coin)
                battleProgressView.label2.transform = .init(scaleX: 1.5, y: 1.5)
            }
            
        }) { (finished: Bool) -> Void in
            battleProgressView.label1.text = "\(Int(streamer1Coin))"
            battleProgressView.label2.text = "\(Int(streamer2Coin))"
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                battleProgressView.label1.transform = .identity
                battleProgressView.label2.transform = .identity
            })
        }
        
    }
    
    func containerCellUISetup(cell: UICollectionViewCell?){
        
        guard let cell = cell as? VideoContainerCell,
              let streamInfo = streamInfo
        else { return }
        
        
//        if streamInfo.rtmpIngest ?? false {
//            cell.rtmpDefaultView.isHidden = false
//            return
//        }
        
        if streamInfo.isPkChallenge ?? false {
            
            if videoSessions.count == 1 {
                cell.pkSessionGuestProfile.isHidden = true
                cell.pkSessionHostProfile.isHidden = true
            }
            
            if let battleOn = battleOn {
                
                // if battleOn true then start animation otherwise not
                if battleOn {
                    if !animatedOnce {
                        DispatchQueue.main.async {
                            self.pkOverlayView.animateVSView()
                            cell.playBattleStartAnimation()
                            self.animatedOnce = true
                        }
                    }
                }
                
                cell.pkSessionHostProfile.toggleToPKProfileView(toggle: battleOn)
                cell.pkSessionGuestProfile.toggleToPKProfileView(toggle: battleOn)
            }
            
        } else {
            cell.pkSessionGuestProfile.isHidden = true
            cell.pkSessionHostProfile.isHidden = true
        }
    }
    
}
