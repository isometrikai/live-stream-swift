//
//  StreamViewController+ActionDelegate.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 08/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit
import IsometrikStream

enum StreamActionEnum {
    case productDetails
    case share
    case highlight
    case buyProduct
    case submitBid
}

extension StreamViewController: StreamCellActionDelegate {
    
    func didProfileTapped(messageInfo: ISMComment?) {
        
//        guard let isometrik = viewModel.isometrik,
//              let messageInfo
//        else { return }
//        
//        // no action if user is guest user
//        let isGuestUser = (isometrik.getUserSession().getUserType() == .guest)
//        if isGuestUser { 
//            _ = Helper.LoginPresenter()
//            return
//        }
//        
//        let streamUserType = viewModel.streamUserType
//        let userId = messageInfo.senderId.unwrap
//        
//        var popupHeight: CGFloat = 150

        
//        // MARK: - PROFILE OPTIONS
//        
//        var streamUserProfileOptions: [StreamUserProfileOptions] = []
//        
//        let kickoutOption = StreamUserProfileOptions(optionLabel: "Kick Out", optionImage: "ism_kickout", optionColor: .black, actionType: .kickout)
//        
//        let moderatorOption = StreamUserProfileOptions(optionLabel: "Make A Moderator", optionImage: "ism_user", optionColor: .black, actionType: .makeModerator)
//        
//        let blockOption = StreamUserProfileOptions(optionLabel: "Block", optionImage: "ism_block", optionColor: .black, actionType: .block)
//        
//        let reportOption = StreamUserProfileOptions(optionLabel: "Report", optionImage: "ism_report", optionColor: .black, actionType: .report)
//        
//        switch streamUserType {
//        case .viewer:
//            
//            if isometrik.getUserSession().getUserId() == userId {
//                streamUserProfileOptions = []
//            } else {
//                streamUserProfileOptions = [blockOption, reportOption]
//                popupHeight = 250
//            }
//            
//        case .member:
//            
//            streamUserProfileOptions = [ ]
//            
//        case .host:
//            
//            if isometrik.getUserSession().getUserId() == userId {
//                streamUserProfileOptions = []
//            } else {
//                streamUserProfileOptions = [ moderatorOption, blockOption, kickoutOption, reportOption ]
//                popupHeight = 320
//            }
//            
//        case .moderator:
//            streamUserProfileOptions = [ moderatorOption, blockOption, kickoutOption, reportOption ]
//            popupHeight = 320
//        }
//        
//        //:
//        
//        
//        let controller = StreamUserProfileViewController(messageData: messageInfo, streamUserProfileOptions: streamUserProfileOptions)
//        controller.delegate = self
//        
//        controller.modalPresentationStyle = .pageSheet
//        controller.modalTransitionStyle = .coverVertical
//        
//        if #available(iOS 15.0, *) {
//            if #available(iOS 16.0, *) {
//                controller.sheetPresentationController?.prefersGrabberVisible = false
//                controller.sheetPresentationController?.detents = [
//                    .custom(resolver: { context in
//                        return popupHeight
//                    })
//                ]
//            }
//        }
//        
//        self.present(controller, animated: true)
        
        /**
         
            User Profile Navigation from Live
         
         */
        
//        let storyBoard = UIStoryboard(name: "Profile", bundle: nil)
//        guard let profileVC = storyBoard.instantiateViewController(withIdentifier: AppConstants.viewControllerIds.profileViewControllerId) as? ProfileViewController else {return}
//        
//        profileVC.profileViewModel.memberId = userId
//        profileVC.profileViewModel.userNameTag = userName
//        profileVC.profileViewModel.userProfileType = .normalUser
//        if userId != Utility.getUserid(){
//            profileVC.profileViewModel.isSelf = false
//        }
//        
//        profileVC.isFromLive = true
//        
//        let navVC = UINavigationController(rootViewController: profileVC)
//        
//        navVC.modalPresentationStyle = .pageSheet
//        navVC.modalTransitionStyle = .coverVertical
//        
//        if #available(iOS 15.0, *) {
//            if #available(iOS 16.0, *) {
//                navVC.sheetPresentationController?.prefersGrabberVisible = false
//                navVC.sheetPresentationController?.detents = [
//                    .custom(resolver: { context in
//                        return UIScreen.main.bounds.height * 0.7
//                    })
//                ]
//            }
//        }
//        
//        self.present(navVC, animated: true)
        
    }
    
    func didDeleteButtonTapped(messageInfo: ISMComment?) {
        // delete the message
        viewModel.deleteStreamMessage(messageInfo: messageInfo) { error in
            if error == nil {
                //
            }
        }
    }
   
    func didTapProductDetails() {
        
//        guard let productViewModel = viewModel.streamProductViewModel,
//              let pinnedProductData = productViewModel.pinnedProductData
//        else { return }
//        
//        let productId = pinnedProductData.childProductID ?? ""
//        let parentProductID = pinnedProductData.parentProductID ?? ""
//        let storeId = pinnedProductData.supplier?.id ?? ""
//        let offersData = pinnedProductData.offers ?? []
//        
//        let pdpVC = ItemDetailVC.instantiate(storyBoardName: "Cart") as ItemDetailVC
//        pdpVC.productIds = ProductsIds(productId: productId, parentProductId: parentProductID)
//        pdpVC.didTagProductCallBack = {
//            self.updateCart()
//        }
//        pdpVC.storeId = storeId
//        pdpVC.isLiveUserHost = viewModel.isometrik?.getUserSession().getUserType() == .host ? true : false
//        pdpVC.isFromLiveStream = true
//        
//        if offersData.count > 0 {
//            let offerData = try! JSONEncoder().encode(offersData.first)
//            if let offer = productViewModel.getOfferFromData(offerData: offerData) {
//                pdpVC.liveStreamoffer = offer
//            }
//        }
//        
//        pdpVC.hidesBottomBarWhenPushed = true
//        
//        let navVC = UINavigationController(rootViewController: pdpVC)
//        
//        navVC.modalPresentationStyle = .pageSheet
//        navVC.modalTransitionStyle = .coverVertical
//        navVC.isModalInPresentation = true
//        
//        if #available(iOS 15.0, *) {
//            if #available(iOS 16.0, *) {
//                navVC.sheetPresentationController?.prefersGrabberVisible = false
//                navVC.sheetPresentationController?.detents = [
//                    .custom(resolver: { context in
//                        return UIScreen.main.bounds.height * 0.7
//                    })
//                ]
//            }
//        }
//        
//        self.present(navVC, animated: true)
        
    }
    
    func didTapSellerProfileView() {
    
        debugPrint("Log:: Profile Button Tapped")
        
        var streamsData = viewModel.streamsData
        
        guard let _ = fullyVisibleCells(streamCollectionView),
              let _ = streamsData[safe: viewModel.selectedStreamIndex.row],
              streamsData.count > 0
        else { return }
        
        let isometrik = viewModel.isometrik
        
//        let index = viewModel.selectedStreamIndex.row
//        let controller = StreamSellerProfileVC()
//        controller.isometrik = isometrik
//        controller.isSelf = (viewModel.streamUserType == .host)
//        controller.userId = streamData.userDetails?.id ?? ""
//        controller.modalPresentationStyle = .pageSheet
//        controller.modalTransitionStyle = .coverVertical
//        controller.followButton_callback = { isFollowing in
//            self.viewModel.streamsData?[index].userDetails?.followStatus = isFollowing ? 1 : 0
//            visibleCell.viewModel = self.viewModel
//        }
//        
//        controller.navigateToLogin = {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                _ = Helper.LoginPresenter()
//            }
//        }
//        
//        if #available(iOS 15.0, *) {
//            if #available(iOS 16.0, *) {
//                controller.sheetPresentationController?.prefersGrabberVisible = false
//                controller.sheetPresentationController?.detents = [
//                    .custom(resolver: { context in
//                        return 350
//                    })
//                ]
//            }
//        }
//        
//        self.present(controller, animated: true)
    }
    
    func didTapFollowButton() {
        debugPrint("Log:: Follow Button Tapped")
        guard let visibleCell = fullyVisibleCells(streamCollectionView)
        else { return }
        
        let isometrik = viewModel.isometrik
        
        // no action if guest user
//        let isGuestUser = (isometrik.getUserSession().getUserType() == .guest)
//        if isGuestUser {
//            _ = Helper.LoginPresenter()
//            return
//        }
        
        viewModel.followUser {
            // refresh views
            visibleCell.viewModel = self.viewModel
        }
    }
    
    func didTapStreamClose(withIndex index: Int) {
        
        let isometrik = viewModel.isometrik
        let streamsData = viewModel.streamsData
        
        guard streamsData.count > 0,
              let streamData = streamsData[safe: index]
        else { return }
        
        let streamStatus = LiveStreamStatus(rawValue: streamData.status)
        
        let isGuestUser = isometrik.getUserSession().getUserType() == .guest
        let streamId = streamData.streamId.unwrap
        let userId = isometrik.getUserSession().getUserId()
        let userType = viewModel.streamUserType
        
        if isGuestUser {
            self.leaveStreamByViewer(userId: userId, streamId: streamId)
            return 
        }
        
        if streamStatus == .started {
            let popupController = StreamPopupViewController()
            
            let titleLabel = popupController.titleLabel
            let cancelButton = popupController.cancelButton
            let yesButton = popupController.yesButton
            
            titleLabel.text = "Are you sure that you want to end your live video ?"
            
            switch userType {
            case .member:
                let isPKMember = isometrik.getUserSession().getMemberForPKStatus()
                if isPKMember {
                    cancelButton.setTitle("Cancel", for: .normal)
                    yesButton.setTitle("Stop Publishing", for: .normal)
                } else {
                    cancelButton.setTitle("Leave Broadcasting", for: .normal)
                    yesButton.setTitle("Stop Publishing", for: .normal)
                }
                break
            case .host:
                cancelButton.setTitle("Cancel", for: .normal)
                yesButton.setTitle("End Broadcasting", for: .normal)
                break
            case .viewer, .moderator:
                self.leaveStreamByViewer(userId: userId, streamId: streamId)
                return
            }
            
            
            popupController.modalPresentationStyle = .overCurrentContext
            popupController.modalTransitionStyle = .crossDissolve
            popupController.actionCallback = { [weak self] streamAction in
                self?.didTapOnClosingAction(withOption: streamAction, index: index)
            }
            
            self.present(popupController, animated: true)
        } else {
            
//            let controller = StreamSellerProfileVC()
//            controller.userId = streamData.userDetails?.id ?? ""
//            controller.isSelf = (viewModel.streamUserType == .host)
//            controller.isCloseEvent = true
//            controller.modalPresentationStyle = .pageSheet
//            controller.modalTransitionStyle = .coverVertical
//            
//            controller.leave_callback = {
//                
//                self.view.endEditing(true)
//                
//                switch streamStatus {
//                case .started:
//                    
//                    switch self.viewModel.streamUserType {
//                    case .host, .member:
//                        
//                        break
//                    case .viewer, .moderator:
//                        self.leaveStreamByViewer(userId: userId, streamId: streamId)
//                        self.endTimer()
//                        
//                        break
//                    }
//                    
//                case .scheduled:
//                    // dismiss
//                    self.dismissViewController()
//                    
//                default:
//                    print("")
//                }
//                
//            }
//            
//            if #available(iOS 15.0, *) {
//                if #available(iOS 16.0, *) {
//                    controller.sheetPresentationController?.prefersGrabberVisible = false
//                    controller.sheetPresentationController?.detents = [
//                        .custom(resolver: { context in
//                            return 360
//                        })
//                    ]
//                }
//            }
//            
//            self.present(controller, animated: true)
        }
        
        
        
    }
    
    func didTapViewerCountView() {
        
        let isometrik = viewModel.isometrik
        let streamsData = viewModel.streamsData
        
        guard let streamData = streamsData[safe: viewModel.selectedStreamIndex.row],
              let visibleCell = fullyVisibleCells(streamCollectionView)
        else { return }
        
        let userType = viewModel.streamUserType
//        let streamStatus = LiveStreamStatus(rawValue: streamData.status ?? "SCHEDULED")
//        
//        if streamStatus == .scheduled {
//            return
//        }
        
        let controller = StreamViewerChildViewController()
        
        controller.isometrik = isometrik
        controller.streamData = streamData
        controller.userType = userType
        controller.modalPresentationStyle = .pageSheet
        
        controller.updateViewerCount_callback = { [weak self] (viewersCount) in
            guard let self else { return }
            visibleCell.streamContainer.streamHeaderView.animateViewersCount(withText: viewersCount)
        }
        
        if let sheet = controller.sheetPresentationController {
            if #available(iOS 16.0, *) {
                // Configure the custom detent
                let customDetent = UISheetPresentationController.Detent.custom { context in
                    return context.maximumDetentValue * 0.6  // 60% of the screen height
                }
                sheet.detents = [customDetent]
                sheet.selectedDetentIdentifier = customDetent.identifier
                sheet.preferredCornerRadius = 0
            } else {
                // Fallback on earlier versions
                sheet.preferredCornerRadius = 0
                sheet.detents = [.medium()]
            }
        }
        
        present(controller, animated: true, completion: nil)
    }
    
    func didTapStreamMembersView() {
        
        guard let streamData = viewModel.streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let isometrik = viewModel.isometrik
        
        let streamMemberViewModel = StreamMemberViewModel(isometrik: isometrik, streamData: streamData)
//        streamMemberViewModel.updateMemebrsCallBack = { [weak self] members in
//            
//        }
        
        let controller = StreamMembersViewController(viewModel: streamMemberViewModel)
        
        if let sheet = controller.sheetPresentationController {
            if #available(iOS 16.0, *) {
                // Configure the custom detent
                let customDetent = UISheetPresentationController.Detent.custom { context in
                    return context.maximumDetentValue * 0.6  // 60% of the screen height
                }
                sheet.detents = [customDetent]
                sheet.selectedDetentIdentifier = customDetent.identifier
                sheet.preferredCornerRadius = 0
            } else {
                // Fallback on earlier versions
                sheet.preferredCornerRadius = 0
                sheet.detents = [.medium()]
            }
        }
        
        present(controller, animated: true, completion: nil)
        
    }
    
    func didTapLiveStatusView() {
        debugPrint("Log:: Live Status View Tapped")
    }
    
    func didTapSendMessageButton(message: String) {
        debugPrint("Log:: Send Message Button Tapped")
        
        sendMessage(messageText: message)
    }
    
    func placeOrder() {
//        let cartVC = CartVC.instantiate(storyBoardName: "Cart") as CartVC
//        cartVC.cartVCupdated = {
//            self.updateCart()
//        }
//        cartVC.cartType = .checkOut
//        cartVC.isBuyNowFlow = true
//        cartVC.updatedAddress = true
//        cartVC.dismissPreviousController = false
//        cartVC.hidesBottomBarWhenPushed = true
//        
//        let navVC = UINavigationController(rootViewController: cartVC)
//        self.navigationController?.present(navVC, animated: true)
    }
    
    func didTapAlternateActionButton(withIndex index: Int) {
        debugPrint("Log:: Alternate Action Button Tapped")
        
        let isometrik = viewModel.isometrik
        let streamsData = viewModel.streamsData
        
        guard let streamData = streamsData[safe: viewModel.selectedStreamIndex.row],
              let visibleCell = fullyVisibleCells(streamCollectionView)
        else { return }
        
        // no action if guest user
        let isGuestUser = (isometrik.getUserSession().getUserType() == .guest)
//        if isGuestUser {
//            _ = Helper.LoginPresenter()
//            return
//        }
        
        let streamUserType = viewModel.streamUserType
        let streamFooterView = visibleCell.streamContainer.streamFooterView
        let dynamicActionButton = streamFooterView.actionButton
        let streamStatus = LiveStreamStatus(rawValue: streamData.status ?? "SCHEDULED")

        switch streamUserType {
        case .viewer:
            
            if streamStatus == .scheduled {
                
                // MARK: - RSVP action
                
                return
            }
            
//            guard let productViewModel = viewModel.streamProductViewModel
//            else { return }
            
            dynamicActionButton.setTitle("", for: .normal)
            dynamicActionButton.setImage(UIImage(), for: .normal)
            
            break
        case .member:
            
            if streamStatus == .scheduled {
                return
            }
            
            break
        case .host:
            
            
            guard let navigationController = self.navigationController else { return }
            viewModel.externalActionDelegate?.didStreamStoreOptionTapped(forUserType: viewModel.streamUserType, root: navigationController)
            
//            if streamStatus == .scheduled {
//                
//                // MARK: - SCHEDULE ACTION
//                self.scheduleAction()
//                return
//            }
//            
//            if let productViewModel = viewModel.streamProductViewModel,
//               let _ = productViewModel.pinnedProductData {
//                
//                // to next pinned item
//                dynamicActionButton.setTitle("", for: .normal)
//                dynamicActionButton.setImage(UIImage(), for: .normal)
//                 
//                streamFooterView.startLoader()
//                
//                // pin next product from viewModel
//                productViewModel.pinNextProductInTaggedList { success, error in
//                    streamFooterView.stopLoader()
//                    visibleCell.setStreamFooterView()
//                    if success {
//                        self.setPinnedItemData()
//                    } else {
//                        print(error)
//                    }
//                }
//                
//            } else {
//                
//                // to tagged product list
//                openStreamTagProducts()
//            }
            
            break
        case .moderator:
            break
        }
        
    }
    
    func scheduleAction(){
        
        let streamsData = viewModel.streamsData
        
        guard let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let scheduleStartTime = streamData.scheduleStartTime ?? 0
        let scheduleStartDate = Date(timeIntervalSince1970: Double(scheduleStartTime))
        
        // Enable the goLive 5 minutes before starting time
        let difference = Date().minuteDifferenceBetween(scheduleStartDate)
        
        if difference < 5 {
            self.startScheduledStream()
        }
        
    }
    
    func didTapMessageEmojiButton() {
        debugPrint("Log:: Emoji Action Button Tapped")
    }
    
    func didTapStreamOptions(with option: StreamOption.RawValue) {
        
        let options = StreamOption(rawValue: option)
        
        guard let visibleIndex = fullyVisibleIndex(streamCollectionView)
        else { return }
        
        let isometrik = viewModel.isometrik
        let streamsData = viewModel.streamsData
        let streamData = streamsData[visibleIndex.row]
        let streamId = streamData.streamId ?? ""
        let stream_Id = streamData._id ?? ""
        let isGuestUser = (viewModel.isometrik.getUserSession().getUserType() == .guest)
        let userType = viewModel.streamUserType
        
        switch options {
        case .share:
            debugPrint("Log:: Share tapped")
            
            // External helper
            let streamImage = streamData.streamImage ?? ""
            let streamTitle = streamData.streamTitle ?? ""
            
            //Helper.shareStreamLink(coverImageUrl: streamImage, streamId: stream_Id, streamTitle: streamTitle)
            //:
            
            break
        case .bidder:
            break
        case .store: 
            guard let navigationController = self.navigationController else { return }
            viewModel.externalActionDelegate?.didStreamStoreOptionTapped(forUserType: userType, root: navigationController)
//            openStreamTagProducts()
            break
        case .camera: isometrik.getIsometrik().switchCamera()
            break
        case .microphone: toggleMicrophone()
            break
        case .loved:
            if !isGuestUser {
                self.sendHeart()
                self.playLikeAnimation(imageToUse: "ic_reaction")
            } else {
//                _ = Helper.LoginPresenter()
            }
            break
        case .speaker:
            break
        case .more: openStreamSettingController()
            break
        case .wallet:
            debugPrint("Log:: Wallet tapped")
            break
        case .analytics: openStreamAnalytics(streamId: streamId)
            break
        case .settings:
            if !isGuestUser {
                self.openStreamSettingController()
            } else {
//                _ = Helper.LoginPresenter()
            }
            break
        case .request: sendRequest() 
            break
        case .requestList: requestList()
            break
        case .gift: giftTapped()
            break
        case .pkInvite: pkInviteTapped()
            break
        case .endPKInvite: endPKInviteTapped()
            break
        case .stopPKBattle: stopPKBattleTapped()
            break
        case .groupInvite: openGoLiveWith()
            break
        case .startPublishing: didStartPublishingVideo()
            break
        case .rtmpIngest: openRtmpIngestDetail()
            break
        default:
            break
        }
        
    }
    
    func didMessageScrolled(withStatus: ScrollStatus) {
        
        guard let visibleCell = fullyVisibleCells(streamCollectionView) else { return }
        
        switch withStatus {
        case .started:
            self.view.endEditing(true)
            visibleCell.setStreamFooterView()
            break
        case .ended:
            break
        case .notReachedBottom:
            break
        case .reachedBottom:
            break
        }
    }
    
    func didKeyboardDismissed() {
        self.view.endEditing(true)
        guard let visibleCell = fullyVisibleCells(streamCollectionView) else { return }
        visibleCell.setStreamFooterView()
    }
    
    func didModeratorTapped() {
        self.handleModalActions()
    }
    
    func didCartButtonTapped() {
        
//        guard let isometrik = viewModel.isometrik else { return }
//        
//        let cartVC = CartVC.instantiate(storyBoardName: "Cart") as CartVC
//        cartVC.cartVCupdated = {
//            self.updateCart()
//        }
//        cartVC.isFromLiveStream = true
//        let navVC = UINavigationController(rootViewController: cartVC)
//        navVC.modalPresentationStyle = .pageSheet
//        navVC.modalTransitionStyle = .coverVertical
//        
//        if #available(iOS 15.0, *) {
//            if #available(iOS 16.0, *) {
//                navVC.sheetPresentationController?.prefersGrabberVisible = false
//                navVC.sheetPresentationController?.detents = [
//                    .custom(resolver: { context in
//                        return UIScreen.main.bounds.height * 0.7
//                    })
//                ]
//            }
//        }
        
//        self.present(navVC, animated: true)
//        
//        guard let visibleCell = fullyVisibleCells(streamCollectionView) else { return }
//        visibleCell.setHeaderCartBadgeUpdates()
        
    }
    
    func didStartScheduledStream() {
        self.startScheduledStream()
    }
    
    func startScheduledStream(){
        
        guard let visibleCell = fullyVisibleCells(streamCollectionView)
        else { return }
        
        let streamsData = viewModel.streamsData
        let isometrik = viewModel.isometrik
        var streamData = streamsData[viewModel.selectedStreamIndex.row]
        let streamLoader = visibleCell.streamLoader
        
        let streamBody = StreamBody(
            streamImage: streamData.streamImage.unwrap,
            streamDescription: streamData.streamDescription.unwrap,
            members: [],
            audioOnly: false,
            multiLive: true,
            lowLatencyMode: streamData.lowLatencyMode.unwrap,
            restream: streamData.restream.unwrap,
            enableRecording: streamData.enableRecording.unwrap,
            hdBroadcast: streamData.hdBroadcast.unwrap,
            isSelfHosted: true,
            productsLinked: streamData.productsLinked.unwrap,
            isPublicStream: true,
            isRecorded: streamData.isRecorded.unwrap,
            amount: 0,
            streamTitle: streamData.streamTitle.unwrap,
            userName: streamData.userDetails?.userName ?? "",
            rtmpIngest: streamData.rtmpIngest.unwrap,
            persistRtmpIngestEndpoint: streamData.persistRtmpIngestEndpoint.unwrap,
            isometrikUserId: streamData.userDetails?.isomatricChatUserId ?? "",
            eventId: streamData._id.unwrap
        )
        
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(streamBody)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
        } catch {
            print("error")
        }
        
        // Show loader
        streamLoader.isHidden = false
        
        isometrik.getIsometrik().startScheduleStream(streamBody: streamBody) { streamInfo in
            
            DispatchQueue.main.async { [weak self] in
                
                guard let self else { return }
                
                // stream data changes
                streamData.streamId = streamInfo.streamId.unwrap
                streamData.status = LiveStreamStatus.started.rawValue
                streamData.rtcToken = streamInfo.rtcToken.unwrap
                streamData.startTime = streamInfo.startTime
                streamData._id = streamData._id.unwrap
                
                // view Model changes
                self.viewModel.streamUserType = .host
                self.viewModel.streamsData = [streamData]
                self.viewModel.isometrik = isometrik
                self.viewModel.selectedStreamIndex = IndexPath(row: 0, section: 0)
                self.viewModel = viewModel
                self.setupDefaults()
                
            }
            
        } failure: { error in
            
            switch error{
            case .noResultsFound(_):
                // handle noresults found here
                break
            case .invalidResponse:
                DispatchQueue.main.async {
                    self.view.showToast( message: "GoLive Error : Invalid Response")
                }
            case.networkError(let error):
                DispatchQueue.main.async {
                    self.view.showToast( message: "Network Error \(error.localizedDescription)")
                }
            case .httpError(let errorCode, let errorMessage):
                DispatchQueue.main.async {
                    self.view.showToast( message: "\(errorCode) \(errorMessage?.error ?? "error")")
                }
                
            default :
                DispatchQueue.main.async {
                    self.view.showToast( message: "Stream Error: Failed to start a new stream")
                }
                break
            }
            
        }
        
    }
    
    func hostNotOnline(streamId : String?) {
//        if self.streamInfo?.streamId == streamId {
//            endTimer()
//            isometrik?.getIsometrik().leaveChannel()
//            streamingVideoAlerttMessage(alertMessage: "The host is not online now. You can watch other live videos.", streamId: streamId ?? "")
//        }
    }
    
    func StopPKBattleAsTimerFinishes() {
        DispatchQueue.main.async { [self] in
            
            let streamsData = viewModel.streamsData
            
            guard let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
            else {
                return
            }
            
            let pkId = streamData.pkId ?? ""
            let userType = viewModel.streamUserType
            
            switch userType {
            case .viewer:
                stopPKBattleForViewer(withPKId: pkId)
                break
            case .member, .host:
                stopPKBattleForBroadcaster(withPkId: pkId)
                break
            case .moderator:
                break
            }
            
        }
    }
    
}

extension StreamViewController {
    
    func sendRequest(){
        
        let isometrik = viewModel.isometrik
        let streamsData = viewModel.streamsData
        
        guard let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let viewerData = isometrik.getUserSession().getUserModel()
        
        var images:[String] = []
        
        images.append("\(streamData.userDetails?.profilePic ?? "")")
        images.append("\(viewerData.imagePath ?? "")")
        
        let viewModel = PublisherViewModel(isometrik: isometrik, streamData: streamData)
        viewModel.user = viewerData
        viewModel.imagesArr = images
        viewModel.publisherStatus = self.viewModel.publisher
        //viewModel.delegate = self
        
        viewModel.success_callback = { [weak self] publisherStatus in
            guard let self else { return }
            self.viewModel.publisher = publisherStatus
        }
        
        let controller = StreamRequestsViewController(viewModel: viewModel)
        
        if let sheet = controller.sheetPresentationController {
            if #available(iOS 16.0, *) {
                // Configure the custom detent
                let customDetent = UISheetPresentationController.Detent.custom { context in
                    return context.maximumDetentValue * 0.45  // 60% of the screen height
                }
                sheet.detents = [customDetent, .medium()]
                sheet.selectedDetentIdentifier = customDetent.identifier
                sheet.preferredCornerRadius = 0
            } else {
                // Fallback on earlier versions
                sheet.preferredCornerRadius = 0
                sheet.detents = [.medium()]
            }
        }
        
        self.present(controller, animated: true)
        
    }
    
    func requestList(){
        
        let isometrik = viewModel.isometrik
        let streamsData = viewModel.streamsData
        
        guard let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let viewModel = PublisherViewModel(isometrik: isometrik, streamData: streamData)
        let controller = RequestListViewController(viewModel: viewModel)
        
        if let sheet = controller.sheetPresentationController {
            if #available(iOS 16.0, *) {
                // Configure the custom detent
                let customDetent = UISheetPresentationController.Detent.custom { context in
                    return context.maximumDetentValue * 0.6  // 60% of the screen height
                }
                sheet.detents = [customDetent, .medium()]
                sheet.selectedDetentIdentifier = customDetent.identifier
                sheet.preferredCornerRadius = 0
            } else {
                // Fallback on earlier versions
                sheet.preferredCornerRadius = 0
                sheet.detents = [.medium()]
            }
        }
        
        self.present(controller, animated: true)
    }
    
    func openGoLiveWith(){
        
        let isometrik = viewModel.isometrik
        let streamsData = viewModel.streamsData
        
        guard let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let viewModel = GoLiveWithViewModel(isometrik: isometrik, streamData: streamData)
        let controller = GoLiveWithViewController(viewModel: viewModel)
        
        if let sheet = controller.sheetPresentationController {
            if #available(iOS 16.0, *) {
                // Configure the custom detent
                let customDetent = UISheetPresentationController.Detent.custom { context in
                    return context.maximumDetentValue * 0.6  // 60% of the screen height
                }
                sheet.detents = [customDetent]
                sheet.selectedDetentIdentifier = customDetent.identifier
                sheet.preferredCornerRadius = 0
            } else {
                // Fallback on earlier versions
                sheet.preferredCornerRadius = 0
                sheet.detents = [.medium()]
            }
        }
        
        controller.modalPresentationStyle = .pageSheet
        self.present(controller, animated: true)
        
    }
    
    func openRtmpIngestDetail(){
        
        let streamsData = viewModel.streamsData
        
        guard let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let controller = RTMPIngestViewController()
        controller.configureData(streamData: streamData)
        controller.modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *) {
            if #available(iOS 16.0, *) {
                controller.sheetPresentationController?.prefersGrabberVisible = true
                controller.sheetPresentationController?.detents = [
                    .custom(resolver: { context in
                        return 290 + ism_windowConstant.getBottomPadding
                    })
                ]
            }
        }
        self.present(controller, animated: true)
    }
    
    func didStartPublishingVideo(){
        switchProfile()
    }
    
}
