
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
    
    func didCopublisherRequestResponseTapped(response: CopublishRequestResponseType, messageInfo: ISMComment?, index: Int) {
        
        let isometrik = viewModel.isometrik
        let streamsData = viewModel.streamsData
        guard let streamData = streamsData[safe: viewModel.selectedStreamIndex.row],
              let streamId = streamData.streamId,
              let visibleCell = fullyVisibleCells(streamCollectionView)
        else { return }
        
        
        let requestByUserId = messageInfo?.senderId ?? ""
        let messageType = messageInfo?.messageType ?? 0
        
        switch response {
            case .accepted:
                
                isometrik.getIsometrik().acceptCopublishRequest(streamId: streamId, requestByUserId: requestByUserId) { (result) in
                    //
                }failure: { error in
                    self.handleError(error: error)
                }
            
                break
            case .rejected:
            
                isometrik.getIsometrik().denyCopublishRequest(streamId: streamId, requestByUserId: requestByUserId) { result in
                    //
                }failure: { error in
                    self.handleError(error: error)
                }
            
                break
        }
        
        // removing the request message from list
        viewModel.streamMessageViewModel?.messages.removeAll(where: { message in
            message.senderId == messageInfo?.senderId && message.messageType ?? 0 == ISMStreamMessageType.request.rawValue
        })
        
        let messagetableView = visibleCell.streamContainer.streamMessageView.messageTableView
        messagetableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        
        self.setHeightForMessages()
    }
    
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
        viewModel.deleteStreamMessage(messageInfo: messageInfo) { _ in }
    }
   
    func didTapProductDetails() {
        
        ISMLogManager.shared.logGeneral("Profile view tapped", type: .info)
        
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
    
    func didTapStreamerProfileView() {
        
        var streamsData = viewModel.streamsData
        guard let streamData = streamsData[safe: viewModel.selectedStreamIndex.row],
              streamsData.count > 0
        else { return }
        
        let streamStatus = LiveStreamStatus(rawValue: streamData.status.unwrap)
        let controller = StreamerDefaultProfileViewController()
        var memberData: ISMMember?
        
        if streamStatus == .scheduled {
            let userId = streamData.userDetails?.id ?? ""
            let userName = streamData.userDetails?.userName ?? ""
            memberData = ISMMember(userID: userId, userName: userName)
            
        } else {
            memberData = viewModel.streamMembers.first
        }
        
        controller.configureData(userData: memberData)
        
        if #available(iOS 15.0, *) {
            if #available(iOS 16.0, *) {
                controller.sheetPresentationController?.prefersGrabberVisible = false
                controller.sheetPresentationController?.detents = [
                    .custom(resolver: { context in
                        return 250
                    })
                ]
            }
        } else {
            controller.sheetPresentationController?.detents = [.medium()]
        }
        
        controller.sheetPresentationController?.preferredCornerRadius = 0
        
        self.present(controller, animated: true)
        
        
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
    
    func didTapStreamClose() {
        
        let isometrik = viewModel.isometrik
        let streamsData = viewModel.streamsData
        
        guard streamsData.count > 0,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let streamStatus = LiveStreamStatus(rawValue: streamData.status.unwrap)
        
        let isGuestUser = isometrik.getUserSession().getUserType() == .guest
        let streamId = streamData.streamId.unwrap
        let userId = isometrik.getUserSession().getUserId()
        let userType = viewModel.streamUserType
        
        if streamStatus == .started {
            let popupController = StreamPopupViewController()
            
            let titleLabel = popupController.titleLabel
            let cancelButton = popupController.cancelButton
            let yesButton = popupController.actionButton
            
            titleLabel.text = "Are you sure that you want to end your live video ?"
            
            switch userType {
            case .member:
                let isPKMember = isometrik.getUserSession().getMemberForPKStatus()
                if isPKMember {
                    cancelButton.setTitle("Cancel", for: .normal)
                    yesButton.setTitle("End broadcasting", for: .normal)
                } else {
                    cancelButton.setTitle("Leave broadcasting", for: .normal)
                    yesButton.setTitle("Stop publishing", for: .normal)
                }
                break
            case .host:
                cancelButton.setTitle("Cancel", for: .normal)
                yesButton.setTitle("End broadcasting", for: .normal)
                break
            case .viewer:
                
                guard let navigationController = self.navigationController else { return }
                
                let getHostMemberData = viewModel.streamMembers.filter { $0.isAdmin == true }
                
                viewModel.externalActionDelegate?.didCloseStreamTapped(
                    memberData: getHostMemberData.first,
                    callback: { success in
                        if success {
                            self.leaveStreamByViewer(userId: userId, streamId: streamId)
                        }
                    },
                    root: navigationController
                )
                return
            }
            
            
            popupController.modalPresentationStyle = .overCurrentContext
            popupController.modalTransitionStyle = .crossDissolve
            popupController.actionCallback = { [weak self] streamAction in
                self?.didTapOnClosingAction(withOption: streamAction)
            }
            
            self.present(popupController, animated: true)
        } else if streamStatus == .scheduled {
            self.dismissViewController()
        } else  {
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
        
        let controller = StreamViewerChildViewController(
            isometrik: isometrik,
            streamData: streamData,
            userType: userType
        )
        
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
            
            var streamId = ""
            
            if streamData.isScheduledStream ?? false && streamData.status == LiveStreamStatus.scheduled.rawValue {
                streamId = streamData.eventId ?? ""
            } else {
                streamId = streamData.streamId.unwrap
            }
            
            let streamData = SharedStreamData(
                streamTitle: streamData.streamDescription.unwrap,
                streamImage: streamData.streamImage.unwrap,
                streamId: streamId
            )
            
            guard let navigationController = self.navigationController else { return }
            viewModel.externalActionDelegate?.didShareStreamTapped(streamData: streamData, root: navigationController)
            
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
        case .analytics: 
            
            if userType == .member {
                // analytics for cohost, while in PK
                if let ghostStreamData = UserDefaultsProvider.shared.getStreamData() {
                    let ghostStreamId = ghostStreamData.streamId.unwrap
                    openStreamAnalytics(streamId: ghostStreamId)
                }
            } else {
                openStreamAnalytics(streamId: streamId)
            }
            
            break
        case .settings:
            openStreamSettingController()
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
            streamCollectionView.isScrollEnabled = false
            self.addAutoScrollTimer()
            break
        case .ended:
            if viewModel.streamMembers.count > 1 {
                self.streamCollectionView.isScrollEnabled = false
            } else {
                self.streamCollectionView.isScrollEnabled = true
            }
            break
        case .notReachedBottom:
            break
        case .reachedBottom:
            print("REACHED TO BOTTOM ::::::>>")
            break
        }
    }
    
    func loadMoreMessages() {
        
        guard let visibleCell = fullyVisibleCells(streamCollectionView),
              let messageViewModel = viewModel.streamMessageViewModel else { return }
        
        let streamMessageView = visibleCell.streamContainer.streamMessageView
        
        messageViewModel.fetchMessages { error in
            if error == nil {
                streamMessageView.viewModel = self.viewModel.streamMessageViewModel
                let streamMessageCount = streamMessageView.viewModel?.messages.count ?? 0
                
                if streamMessageCount > 10 {
                    self.reloadDataWithoutChangingScrollPosition()
                } else {
                    self.setHeightForMessages()
                }
            }
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
    
    func hostNotOnline() {
        
        guard let visibleCell = fullyVisibleCells(streamCollectionView) else { return }
        
        endTimer()
        viewModel.isometrik.getIsometrik().leaveChannel()
        streamCollectionView.isScrollEnabled = false
        
        // show the popup saying stream off
        visibleCell.streamEndView.isHidden = false
        visibleCell.streamEndView.streamEndMessageLabel.text = "The host is not online now. You can watch other live videos".localized + "."
        visibleCell.streamEndView.continueButton.addTarget(self, action: #selector(scrollToNextAvailableStream), for: .touchUpInside)
        
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
            }
            
        }
    }
    
    func handleError(error: ISMLiveAPIError){
        switch error{
        case .noResultsFound(_):
            // handle noresults found here
            break
        case .invalidResponse:
            DispatchQueue.main.async {
                self.view.showToast( message: "Error : Invalid Response")
            }
        case.networkError(let error):
            self.view.showToast( message: "Network Error \(error.localizedDescription)")
            
        case .httpError(let errorCode, let errorMessage):
            DispatchQueue.main.async{
                self.view.showToast( message: "\(errorCode) \(errorMessage?.error ?? "")")
            }
        default :
            break
        }
    }
    
}

extension StreamViewController: StreamRequestsActionDelegate {
    
    func didLeaveStream() {
        didTapStreamClose()
    }
    
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
        viewModel.delegate = self
        
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
