//
//  RecordedStreamPlayerViewController+ActionDelegate.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 25/12/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import AVFoundation

extension RecordedStreamPlayerViewController: RecordedStreamPlayerCellActionDelegate {
    
    func didProfileButtonTapped(index: Int) {
        
//        guard let streamData = viewModel.streamsData[safe: index],
//              let userDetails = streamData.userDetails,
//              let visibleCell = fullyVisibleCells(recordingPlayerCollectionView)
//        else { return }
//        
//        let isometrik = viewModel.isometrik
//        let isometrikUser = isometrik.getUserSession()
//        let userId = userDetails.id.unwrap
//        let isSelf = (isometrikUser.getUserId() == userId)
//        
//        let controller = StreamSellerProfileVC(isometrik: isometrik)
//        controller.userId = userId
//        controller.isSelf = isSelf
//        controller.isCloseEvent = false
//        controller.modalPresentationStyle = .pageSheet
//        controller.modalTransitionStyle = .coverVertical
//        
//        controller.followButton_callback = { isFollowing in
//            self.viewModel.streamsData[index].userDetails?.followStatus = isFollowing ? 1 : 0
//            visibleCell.streamData = self.viewModel.streamsData[index]
//            
//        }
//        
//        if #available(iOS 15.0, *) {
//            if #available(iOS 16.0, *) {
//                controller.sheetPresentationController?.prefersGrabberVisible = false
//                controller.sheetPresentationController?.detents = [
//                    .custom(resolver: { context in
//                        return 360
//                    })
//                ]
//            }
//        }
//        
//        self.present(controller, animated: true)
        
    }
    
    func didFollowButtonTapped(index: Int) {
        
    }
    
    func didPlayButtonTapped(index: Int) {
        
        guard let visibleCell = fullyVisibleCells(recordingPlayerCollectionView) else { return }
        
        if viewModel.playerState == .pause {
            viewModel.player?.play()
            visibleCell.playButton.isHidden = true
            viewModel.playerState = .play
        } else if viewModel.playerState == .play {
            viewModel.player?.pause()
            visibleCell.playButton.isHidden = false
            viewModel.playerState = .pause
        } else {
            // set play icon and hide playbutton
            viewModel.player?.seek(to: CMTime.zero)
            viewModel.player?.play()
            
            visibleCell.playButton.setBackgroundImage(UIImage(named: "ism_play"), for: .normal)
            visibleCell.playButton.isHidden = true
            viewModel.playerState = .play
        }
        
    }
    
    func didOpenCartButtonTapped(index: Int) {
        
    }
    
    func didCloseButtonTapped(index: Int) {
        self.dismissController()
    }
    
    func didAddToCartButtonTapped(index: Int) {
        
    }
    
    func didProductTapped(index: Int) {
        
    }
    
    func didRecordedStreamOptionTapped(option: RecordedStreamOptions?, index: Int) {
        
        guard let option,
              let streamData = viewModel.streamsData[safe: index] else { return }
        
        let isometrik = viewModel.isometrik
        
        switch option {
        case .product:
            print("LOG:: Products tapped")
            
//            let controller = RecordedStreamsTaggedProductViewController()
//            controller.modalPresentationStyle = .pageSheet
//
//            let productViewModel = ProductViewModel(isometrik: isometrik)
//            productViewModel.streamInfo = streamData
//            productViewModel.cartUpdates_callback = {[weak self] in
//                self?.updateCart()
//            }
//            controller.productViewModel = productViewModel
//            
//            let navVC = UINavigationController(rootViewController: controller)
//
//            navVC.modalPresentationStyle = .pageSheet
//            navVC.modalTransitionStyle = .coverVertical
//            
//            if #available(iOS 15.0, *) {
//                if #available(iOS 16.0, *) {
//                    navVC.sheetPresentationController?.prefersGrabberVisible = false
//                    navVC.sheetPresentationController?.detents = [
//                        .custom(resolver: { context in
//                            return UIScreen.main.bounds.height * 0.7
//                        })
//                    ]
//                }
//            }
//            
//            self.present(navVC, animated: true)
            
            break
        case .share:
            print("LOG:: Share tapped")
            
            // Extenal helper
            
            let streamImage = streamData.streamImage ?? ""
            let stream_id = streamData._id ?? ""
            let streamTitle = streamData.streamTitle ?? ""
            
            //
            
            break
        case .more:
            print("LOG:: More tapped")
            
            let settingController = StreamSettingViewController()
            
            let currentUserId = isometrik.getUserSession().getUserId()
            
            var settingsData:[StreamSettingData] = []
            
            if streamData.id != currentUserId {
                let reportAction = StreamSettingData(settingLabel: "Report".localized, settingImage: UIImage(named:"ism_report") ?? UIImage(), streamSettingType: .report)
                settingsData.append(reportAction)
            }
            
            // if my recorded stream than add option otherwise not
            
            if streamData.id == currentUserId {
                let deleteAction = StreamSettingData(settingLabel: "Delete", settingImage: UIImage(named: "trash")?.withRenderingMode(.alwaysTemplate) ?? UIImage(), streamSettingType: .delete)
                settingsData.append(deleteAction)
            }
            
            settingController.settingData = settingsData
            settingController.delegate = self
            
            if #available(iOS 16.0, *) {
                let customDetent = UISheetPresentationController.Detent.custom(identifier: .init("myCustomDetent")) { [weak self] context in
                    guard let self else { return 0.0 }
                    return 150 + ism_windowConstant.getBottomPadding
                }
                
                if let sheet = settingController.sheetPresentationController {
                    sheet.detents = [ customDetent ]
                }
            } else {
                // Fallback on earlier versions
                settingController.sheetPresentationController?.detents = [.medium()]
            }
            
            present(settingController, animated: true)
            
            break
        }
        
    }
    
}

extension RecordedStreamPlayerViewController: StreamSettingDelegate {
    
    public func didTapSettingOptionFor(actionType: StreamSettingType) {
        switch actionType {
        case .report:
            
//            guard let visibleIndex = self.fullyVisibleIndex(self.recordingPlayerCollectionView), let streamData = viewModel.streamsData[safe: visibleIndex.row] else { return }
//            
//            let appUserId = streamData.userDetails?.id ?? ""
//            
//            let controller = StreamReportViewController()
//            controller.userViewModel.userId = appUserId
//            controller.modalPresentationStyle = .pageSheet
//            
//            if #available(iOS 15.0, *) {
//                if #available(iOS 16.0, *) {
//                    controller.sheetPresentationController?.prefersGrabberVisible = false
//                    controller.sheetPresentationController?.detents = [
//                        .custom(resolver: { context in
//                            return 250 + windowConstant.getBottomPadding
//                        })
//                    ]
//                }
//            }
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                self.present(controller, animated: true)
//            }
            break
        case .delete:
            
//            guard let visibleIndex = self.fullyVisibleIndex(self.recordingPlayerCollectionView), let streamData = self.viewModel.streamsData[safe: visibleIndex.row] else { return }
//            let streamId = streamData.streamId ?? ""
//            
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                
//                self.viewModel.deleteStream(streamId: streamId) { success, errorString in
//                    if success {
//                        // remove from array and reload
//                        self.viewModel.streamsData.remove(at: visibleIndex.row)
//                        //self.recordingPlayerCollectionView.reloadData()
//                        self.dismissController()
//                    }
//                }
//                
//            }
            
            break
            
        default:
            return
        }
    }
    
}

