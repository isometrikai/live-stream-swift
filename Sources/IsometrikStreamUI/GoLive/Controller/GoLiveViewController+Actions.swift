//
//  GoLiveViewController+Actions.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 07/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import IsometrikStream

// MARK: - HEADER ACTIONS

extension GoLiveViewController: GoLiveHeaderActionDelegate, ISMAppearanceProvider {
    
    func didClearImageButtonTapped() {
        let profileView = contentView.goLiveContentContainerView.profileView
        profileView.clearImageButton.isHidden = true
        profileView.profileCoverImageView.image = nil
        viewModel.videoPreviewUrl = nil
    }
    
    func didCloseButtonTapped() {
        self.dismiss(animated: true)
    }
    
    func didActionButtonTapped(with actionType: GoLivePremiumActionType) {
        
        switch actionType {
        case .paid:
            openCoinDialog()
            break
        case .free:
            viewModel.selectedCoins = 0
            break
        }
        
    }
    
    func didSelectProfileTapped() {
        configureImagePickerViewController()
    }
    
}

// MARK: - FOOTER ACTIONS

extension GoLiveViewController: GoLiveFooterActionDelegate {
    
    func didGoLiveButtonTapped() {
        
        self.view.endEditing(true)
        
        let isometrik = viewModel.isometrik
        let profileView = contentView.goLiveContentContainerView.profileView
        
        let streamTextView = profileView.streamTextView.text
        let profileImageView = profileView.profileCoverImageView
        let userData = isometrik.getUserSession().getUserModel()
        
        if streamTextView == "My stream description..." {
            self.ism_showAlert("Error", message: "Stream Title Required!")
            return
        }
        
        // show user error if mqtt connection not connected
        if !(isometrik.getMqttSession().isConnected) {
            self.view.showToast(message: "connection is broken!")
            return
        }
        
//        if viewModel.selectedProducts.count == 0 {
//            self.ism_showAlert("Error", message: "Add products to proceed".localized + "!")
//            return
//        }
        
        if viewModel.isScheduleStream {
            if viewModel.scheduleFor == nil {
                self.ism_showAlert("Error", message: "Date and Time cannot be empty for scheduling a stream")
                return
            }
        }
        
        if let image = profileImageView.image {
            
            DispatchQueue.main.async {
                CustomLoader.shared.startLoading()
            }
            
            let description = streamTextView.unwrap
            let userData = isometrik.getUserSession().getUserModel()
            
            if viewModel.isEditing && !viewModel.newImagePicked {
                self.updateScheduleStream(userData: userData, description: description, imagePath: viewModel.streamData?.streamImage ?? "", videoPath: "")
                return
            }
            
            viewModel.getPresignedUrl(streamTitle: description) { success, error in
                if success {
                    self.viewModel.uploadStreamCover(image: image) { status in
                        
                        switch status {
                        case .progress(let progress):
                            print("Upload progress: \(progress * 100)%")
                            break
                        case .success:
                            
                            if self.viewModel.isEditing {
                                self.updateScheduleStream(userData: userData, description: description, imagePath: self.viewModel.mediaUrlString ?? "", videoPath: "")
                            } else {
                                self.startNewStream(userData: userData, description: description, imagePath: self.viewModel.mediaUrlString ?? "", videoPath: "")
                            }
                            
                            break
                        case .failure(let error):
                            if let error = error {
                                print("Upload error: \(error.localizedDescription)")
                            } else {
                                print("Upload failed with unknown error")
                            }
                        }
                        
                    }
                } else {
                    DispatchQueue.main.async {
                        CustomLoader.shared.stopLoading()
                        self.view.showToast( message: "unable to fetch presigned url")
                    }
                }
            }
            
        } else {
            
            // Add condition for fromDevice case only
            if viewModel.currenStreamType == .fromDevice {
                self.ism_showAlert("Error", message: "Stream Cover Image required".localized + "!")
                return
            }
            
            DispatchQueue.main.async {
                CustomLoader.shared.startLoading()
            }
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            viewModel.stillImageOutput.capturePhoto(with: settings, delegate: self)
            
        }
        
    }
    
    func didGoLiveStreamTypeActionTapped(with actionType: GoLiveStreamType) {
        
        viewModel.currenStreamType = actionType
        updateCameraStatus(forStreamType: actionType)
        
        // animate to the required action
        footerView.animateStreamTypeActions(action: actionType)
        
        let profileView = contentView.goLiveContentContainerView.profileView
        
        switch actionType {
        case .guestLive:
            
            viewModel.isHdBroadcast = false
            contentView.goLiveContentContainerView.animateToggles(withStreamOption: .hdBroadCast, isSelected: viewModel.isHdBroadcast)
            
            viewModel.isPersistentRTMPKey = false
            viewModel.isRTMPStream = false
            setupConditionalContent()
            
            break
        case .fromDevice:
            
            // by default both hdBroadcast and persistent rtmp key will be on
            viewModel.isHdBroadcast = true
            contentView.goLiveContentContainerView.animateToggles(withStreamOption: .hdBroadCast, isSelected: viewModel.isHdBroadcast)
            
            viewModel.isPersistentRTMPKey = true
            contentView.goLiveContentContainerView.animateToggles(withStreamOption: .persistentRTMPKey, isSelected: viewModel.isPersistentRTMPKey)
            
            // As camera is not available here so user has to select image from gallery
            profileView.profileCoverImageView.image = nil
            profileView.clearImageButton.isHidden = true
            
            viewModel.isRTMPStream = true
            setupConditionalContent()
            
            break
        }
        
    }
    
}

// MARK: - CONTENT SETUP ACTION

extension GoLiveViewController {
    
    func setupConditionalContent(){
        
        let isometrik = viewModel.isometrik
        let isProductEnabled = isometrik.getStreamOptionsConfiguration().isProductInStreamEnabled
        let isRestreamEnabled = isometrik.getStreamOptionsConfiguration().isRestreamEnabled
        let isScheduleEnabled = isometrik.getStreamOptionsConfiguration().isScheduleStreamEnabled
        let isRTMPEnabled = isometrik.getStreamOptionsConfiguration().isRTMPStreamEnabled
        let isPaidStreamEnabled = isometrik.getStreamOptionsConfiguration().isPaidStreamEnabled
        
        let contentContainerView = contentView.goLiveContentContainerView
        let restreamBroadCastToggle = contentContainerView.restreamBroadCastToggle
        let rtmpStreamKeyToggle = contentContainerView.rtmpStreamKeyToggle
        
        let premiumOptionStackView = contentContainerView.premiumOptionStackView
        let toggleStackview = contentContainerView.toggleStackView
        let contentStackView = contentContainerView.contentStackView
        
        let restreamOption = contentContainerView.restreamOption
        let scheduleToggle = contentContainerView.scheduleToggle
        let dateTimeSelectorView = contentContainerView.dateTimeSelectorView
        let infoLabelView = contentContainerView.infoLabelView
        let rtmpURLView = contentContainerView.rtmpURLView
        let streamKeyView = contentContainerView.streamKeyView
        let helpLabelView = contentContainerView.helpLabelView
        let goLiveButton = footerView.goLiveButton
        let premiumButton = contentContainerView.premiumButton
        let freeButton = contentContainerView.freeButton
        
        
        if !isPaidStreamEnabled || viewModel.currenStreamType == .fromDevice {
            premiumButton.isHidden = true
            freeButton.isHidden = true
            
            premiumOptionStackView.removeArrangedSubview(freeButton)
            premiumOptionStackView.removeArrangedSubview(premiumButton)
        } else {
            premiumButton.isHidden = false
            freeButton.isHidden = false
            
            premiumOptionStackView.addArrangedSubview(freeButton)
            premiumOptionStackView.addArrangedSubview(premiumButton)
        }
        
        if isRestreamEnabled {
            toggleStackview.addArrangedSubview(restreamBroadCastToggle)
            if viewModel.restreamBroadcast {
                restreamOption.isHidden = false
                contentStackView.addArrangedSubview(restreamOption)
            } else {
                contentStackView.removeArrangedSubview(restreamOption)
                restreamOption.isHidden = true
            }
        }
        
        if isRTMPEnabled {
            if viewModel.currenStreamType == .fromDevice {
                rtmpStreamKeyToggle.isHidden = false
                toggleStackview.addArrangedSubview(rtmpStreamKeyToggle)
                
                if !viewModel.isPersistentRTMPKey {
                    
                    contentStackView.removeArrangedSubview(rtmpURLView)
                    contentStackView.removeArrangedSubview(streamKeyView)
                    contentStackView.removeArrangedSubview(helpLabelView)
                    
                    rtmpURLView.isHidden = true
                    streamKeyView.isHidden = true
                    helpLabelView.isHidden = true
                    
                    contentStackView.addArrangedSubview(infoLabelView)
                    // change the text in info label
                    infoLabelView.formLabel.text = "If you disable PERSISTENT RTMP URL you will get a new URL and a stream key every time you start a new stream"
                    
                } else {
                    
                    rtmpURLView.isHidden = false
                    streamKeyView.isHidden = false
                    infoLabelView.isHidden = false
                    helpLabelView.isHidden = false
                    
                    contentStackView.addArrangedSubview(rtmpURLView)
                    contentStackView.addArrangedSubview(streamKeyView)
                    contentStackView.addArrangedSubview(infoLabelView)
                    contentStackView.addArrangedSubview(helpLabelView)
                    
                    // change the text in info label
                    infoLabelView.formLabel.text = "Please copy paste the STREAM KEY and the STREAM URL  into your RTMP streaming device."
                }
            } else {
                
                toggleStackview.removeArrangedSubview(rtmpStreamKeyToggle)
                
                contentStackView.removeArrangedSubview(rtmpURLView)
                contentStackView.removeArrangedSubview(streamKeyView)
                contentStackView.removeArrangedSubview(infoLabelView)
                contentStackView.removeArrangedSubview(helpLabelView)
                
                rtmpStreamKeyToggle.isHidden = true
                rtmpURLView.isHidden = true
                streamKeyView.isHidden = true
                infoLabelView.isHidden = true
                helpLabelView.isHidden = true
            }
        }
        
        if isProductEnabled {
            setupAddProductListView()
        }
        
        if isScheduleEnabled {
            contentStackView.addArrangedSubview(scheduleToggle)
            
            if viewModel.isScheduleStream {
                
                // change action button state
                goLiveButton.setTitle("Schedule Stream", for: .normal)
                
                dateTimeSelectorView.isHidden = false
                contentStackView.addArrangedSubview(dateTimeSelectorView)
                
            } else {
                dateTimeSelectorView.isHidden = true
                contentStackView.removeArrangedSubview(dateTimeSelectorView)
                
                viewModel.scheduleFor = nil
                contentContainerView.dateTimeSelectorView.formTextView.customTextLabel.text = "Choose Date and Time".localized
                
                goLiveButton.setTitle("Go Live", for: .normal)
            }
            
        }
        
    }
    
}


// MARK: - CONTENT DELEGATE ACTIONS

extension GoLiveViewController: LiveOptionsActionDelegate {
    
    func didToggleOptionTapped(withStreamOption: StreamOptionToggle) {
        
        let contentContainerView = contentView.goLiveContentContainerView
        
        switch withStreamOption {
        case .hdBroadCast:
            viewModel.isHdBroadcast = !viewModel.isHdBroadcast
            contentContainerView.animateToggles(withStreamOption: .hdBroadCast, isSelected: viewModel.isHdBroadcast)
            
        case .recordBroadCast:
            viewModel.recordBroadcast = !viewModel.recordBroadcast
            contentContainerView.animateToggles(withStreamOption: .recordBroadCast, isSelected: viewModel.recordBroadcast)
            
        case .restreamBroadcast:
            viewModel.restreamBroadcast = !viewModel.restreamBroadcast
            contentContainerView.animateToggles(withStreamOption: .restreamBroadcast, isSelected: viewModel.restreamBroadcast)
            setupConditionalContent()
            
        case .persistentRTMPKey:
            viewModel.isPersistentRTMPKey = !viewModel.isPersistentRTMPKey
            contentContainerView.animateToggles(withStreamOption: .persistentRTMPKey, isSelected: viewModel.isPersistentRTMPKey)
            setupConditionalContent()
            
        case .scheduleStream:
            
            viewModel.isScheduleStream = !viewModel.isScheduleStream
            contentContainerView.animateToggles(withStreamOption: .scheduleStream, isSelected: viewModel.isScheduleStream)
            setupConditionalContent()
            
            break
        }
        
    }
    
    func didDateTimeSelectorTapped() {
        
        if #available(iOS 15.0, *) {
            let controller = ScheduleStreamPopupViewController()
            controller.modalPresentationStyle = .pageSheet
            controller.sheetPresentationController?.detents = [.medium()]
            controller.sheetPresentationController?.preferredCornerRadius = 0
            
            controller.selectedDate = viewModel.scheduleFor
            
            controller.scheduleForCallback = { [weak self] date in
                guard let self = self else { return }
                self.viewModel.scheduleFor = date
                self.contentView.goLiveContentContainerView.dateTimeSelectorView.formTextView.customTextLabel.text = date.ism_toString(format: "d MMM YYYY, h:mm a")
            }
            
            self.present(controller, animated: true)
            
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func didRTMPURLCopied() {
        
        // write to clipboard
        UIPasteboard.general.string = viewModel.rtmpURL
        
        // copied animation
        self.view.showToast(message: "RTMP URL Copied!")
        
    }
    
    func didStreamKeyCopied() {
        // write to clipboard
        UIPasteboard.general.string = viewModel.streamKey
        
        // copied animation
        self.view.showToast(message: "Stream Key Copied!")
    }
    
    func didHelpLabelViewTapped() {
        
        let controller = RTMPInstructionViewController()
        controller.modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *) {
            if #available(iOS 16.0, *) {
                controller.sheetPresentationController?.prefersGrabberVisible = true
                controller.sheetPresentationController?.detents = [
                    .custom(resolver: { context in
                        return 180 + ism_windowConstant.getBottomPadding
                    })
                ]
            }
        }
        self.present(controller, animated: true)
        
    }
    
    func didRestreamTapped() {
        let controller = RestreamChannelsViewController()
        let restreamViewModel = RestreamViewModel()
        restreamViewModel.isometrik = viewModel.isometrik
        controller.viewModel = restreamViewModel
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTapAddProduct() {
        
        guard let navigationController = self.navigationController else { return }
        
        let isometrik = viewModel.isometrik
        if isometrik.getStreamOptionsConfiguration().isProductInStreamEnabled {
            viewModel.externalActionDelegate?.didAddProductTapped(selectedProductsIds: [], productIds: { productIds in
                
                // do something with productIds
                
            }, root: navigationController)
        }
        
//        let containerView = contentView.rtmpOptionsContainerView
//        let addProductView = containerView.addProductView
//        
//        let controller = AllProductsViewController()
//        
//        let viewModel = ProductViewModel(isometrik: viewModel.isometrik)
//        // changing the selected flag to true for selected products
//        self.viewModel.selectedProducts.indices.forEach { index in
//            self.viewModel.selectedProducts[index].isSelected = true
//        }
//        viewModel.selectedProductList = self.viewModel.selectedProducts
//        viewModel.productList = self.viewModel.allProducts
//        controller.productViewModel = viewModel
//        
//        controller.product_Callback = { [weak self] (selectedProducts, allProducts) in
//            
//            guard let selectedProducts, let self else {
//                // reset the product option height
//                containerView.addProductViewHeightConstraint?.constant = 170
//                addProductView.addButton.isHidden = true
//                return
//            }
//            
//            self.viewModel.selectedProducts = selectedProducts
//            self.viewModel.allProducts = allProducts
//            containerView.addProductViewHeightConstraint?.constant = 290
//            addProductView.addButton.isHidden = false
//            addProductView.productData = selectedProducts
//            
//        }
//        
//        let navVC = UINavigationController(rootViewController: controller)
//        navVC.modalPresentationStyle = .pageSheet
//        navVC.isModalInPresentation = false
//        
//        self.present(navVC, animated: true)
        
    }
    
    func didRemoveProduct(index: Int) {
        // remove the selected product
//        var selectedProducts = viewModel.selectedProducts
//        let containerView = contentView.rtmpOptionsContainerView
//        let addProductView = containerView.addProductView
//        
//        let toBeRemovedProductId = viewModel.selectedProducts[index].childProductID ?? ""
//        
//        if !(selectedProducts.count > 0) {
//            return
//        }
//        
//        selectedProducts.remove(at: index)
//        if selectedProducts.count == 0 {
//            addProductView.addButton.isHidden = true
//            
//            // Change the height of addProductView to normal
//            containerView.addProductViewHeightConstraint?.constant = 170
//            
//            viewModel.allProducts.removeAll()
//        }
//        
//        // making change to all products too
//        if let indexToChange = viewModel.allProducts.firstIndex(where: {$0.childProductID == toBeRemovedProductId}) {
//            viewModel.allProducts[indexToChange].isSelected = false
//            viewModel.allProducts[indexToChange].liveStreamfinalPriceList?.discountPercentage = 0
//        }
//        
//        viewModel.selectedProducts = selectedProducts
//        addProductView.productData = selectedProducts
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer){
        
        let isometrik = viewModel.isometrik
        let isRTMPEnabled = isometrik.getStreamOptionsConfiguration().isRTMPStreamEnabled
        
        // Disabling the gesture if rtmp is disabled
        if !isRTMPEnabled {
            return
        }
        
        // Disabling gestures if editing
        if viewModel.isEditing { return }
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case .right:
                print("Swiped right")
                
                if viewModel.currenStreamType == .guestLive {
                    return
                }
                
                viewModel.currenStreamType = .guestLive
                didGoLiveStreamTypeActionTapped(with: .guestLive)
                updateCameraStatus(forStreamType: .guestLive)
                
            case .down:
                print("Swiped down")
            case .left:
                print("Swiped left")
                
                if viewModel.currenStreamType == .fromDevice {
                    return
                }
                
                viewModel.currenStreamType = .fromDevice
                didGoLiveStreamTypeActionTapped(with: .fromDevice)
                updateCameraStatus(forStreamType: .fromDevice)
                
            case .up:
                print("Swiped up")
            default:
                break
            }
            
        }
        
    }
}

// MARK: - OTHER ACTIONS

extension GoLiveViewController {
    
    
    func startNewStream(userData: ISMStreamUser, description: String, imagePath: String, videoPath: String) {
        
        guard let isometrikUserId = userData.userId
        else { return }
        
        let isometrik = viewModel.isometrik
        let userName = isometrik.getUserSession().getUserName()
        
        if viewModel.selectedCoins > 0 {
            viewModel.paidAmount = viewModel.selectedCoins
            viewModel.isPaid = true
        } else {
            viewModel.paidAmount = 0
            viewModel.isPaid = false
        }
        
        let streamBody = StreamBody(
            streamImage: imagePath,
            streamDescription: description,
            members: [],
            createdBy: isometrikUserId,
            isPublic: true,
            audioOnly: false,
            multiLive: viewModel.multiLive,
            lowLatencyMode: viewModel.lowLatencyMode,
            restream: viewModel.restreamBroadcast,
            enableRecording: viewModel.recordBroadcast,
            hdBroadcast: viewModel.isHdBroadcast,
            isSelfHosted: viewModel.isSelfHosted,
            productsLinked: viewModel.isProductLinked,
            isPaid: viewModel.isPaid, 
            isPublicStream: true,
            isRecorded: viewModel.recordBroadcast,
            isScheduledStream: viewModel.isScheduleStream,
            amount: viewModel.paidAmount,
            userName: userName,
            rtmpIngest: viewModel.isRTMPStream,
            persistRtmpIngestEndpoint: viewModel.isPersistentRTMPKey,
            scheduleStartTime: viewModel.isScheduleStream ? Int64(viewModel.scheduleFor != nil ? viewModel.scheduleFor?.timeIntervalSince1970 ?? 0 : Date().timeIntervalSince1970 ) : nil,
            isGroupStream: viewModel.multiLive,
            products: [],
            currency: "USD"
        )
        
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(streamBody)
        } catch {
            print("Error While starting stream!")
        }
        
        
        isometrik.getIsometrik().startStream(streamBody: streamBody) { stream in
            
            /// Stop loading.
            CustomLoader.shared.stopLoading()
            
            if self.viewModel.isScheduleStream {
                
                let controller = CustomConfirmationPopupViewController()
                controller.infoLabel.text = "Stream Successfully scheduled" + "!"
                controller.isModalInPresentation = true
                
                if #available(iOS 16.0, *) {
                    if let sheet = controller.sheetPresentationController {
                        sheet.detents = [.custom(resolver: { context in
                            250 + ism_windowConstant.getBottomPadding
                        })]
                    }
                } else {
                    // Fallback on earlier versions
                    controller.sheetPresentationController?.detents = [.medium()]
                }
                
                // callback
                controller.close_callback = { [weak self] in
                    guard let self else { return }
                    self.viewModel.captureSession?.stopRunning()
                    DispatchQueue.main.async {
                        self.dismiss(animated: true)
                    }
                }
                
                controller.playAnimation(for: self.appearance.json.successAnimation)
                
                self.present(controller, animated: true)
                
            } else {
                self.viewModel.captureSession?.stopRunning()
                
                var streamData = stream
                streamData.isPaid = self.viewModel.isPaid
                streamData.amount = Double(self.viewModel.paidAmount)
                streamData.multiLive = self.viewModel.multiLive
                streamData.selfHosted = self.viewModel.selfHosted
                streamData.streamImage = imagePath
                streamData.streamDescription = description
                streamData.streamTitle = description
                streamData.status = LiveStreamStatus.started.rawValue
                streamData.hdBroadcast = self.viewModel.isHdBroadcast
                streamData.restream = self.viewModel.restreamBroadcast
                streamData.rtmpIngest = self.viewModel.isRTMPStream
                streamData.isRecorded = self.viewModel.recordBroadcast
                streamData.persistRtmpIngestEndpoint = self.viewModel.isPersistentRTMPKey
                
                let firstName = isometrik.getUserSession().getFirstName()
                let lastName = isometrik.getUserSession().getLastName()
                let userName = isometrik.getUserSession().getUserName()
                let profileImage = isometrik.getUserSession().getUserImage()
                let userId = isometrik.getUserSession().getUserId()
                
                streamData.userDetails = StreamUserDetails(firstName: firstName, isFollow: nil, isStar: nil, lastName: lastName, userName: userName, userProfile: profileImage, profilePic: profileImage, isomatricChatUserId: userId, id: "")
                
                // saving the stream data for later use
                UserDefaultsProvider.shared.setStreamData(model: streamData)
                
                isometrik.setHostUserId(userId: userId)
                
                let isStreamRTMP = self.viewModel.isRTMPStream
                isometrik.getUserSession().setRTMPStreamStatus(isStreamRTMP)
                
                DispatchQueue.main.async {
                    self.navigateToLiveStremViewController(streamInfo:[streamData])
                }
            }
            
        } failure: { error in
            
            /// Stop loading.
            CustomLoader.shared.stopLoading()
            
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
    
    func updateScheduleStream(userData: ISMStreamUser, description: String, imagePath: String, videoPath: String){
        
        guard let streamData = viewModel.streamData
        else { return }
        
        let isometrik = viewModel.isometrik
        
        let streamBody = StreamBody(
            streamImage: "\(imagePath)", 
            streamDescription: "\(description)",
            eventId: streamData.eventId ?? ""
        )
        
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(streamBody)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
        } catch {
            print("error")
        }
        
        isometrik.getIsometrik().updateScheduleStream(streamBody: streamBody) { [weak self] stream in
            
            guard let self else { return }
            
            CustomLoader.shared.stopLoading()
            
            let controller = CustomConfirmationPopupViewController()
            controller.infoLabel.text = "Stream Successfully updated" + "!"
            controller.isModalInPresentation = true
            
            if #available(iOS 16.0, *) {
                if let sheet = controller.sheetPresentationController {
                    sheet.detents = [.custom(resolver: { context in
                        250 + ism_windowConstant.getBottomPadding
                    })]
                }
            } else {
                // Fallback on earlier versions
                controller.sheetPresentationController?.detents = [.medium()]
            }
            
            // callback
            controller.close_callback = { [weak self] in
                guard let self else { return }
                self.viewModel.captureSession?.stopRunning()
                DispatchQueue.main.async {
                    self.viewModel.update_callback?(streamData.eventId ?? "")
                    self.dismiss(animated: true)
                }
            }
            
            controller.playAnimation(for: appearance.json.successAnimation)
            self.present(controller, animated: true)
            
        } failure: { [weak self] error in
            
            guard let self else { return }
            
            CustomLoader.shared.stopLoading()
            
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
    
    func navigateToLiveStremViewController(streamInfo:[ISMStream]?){
        
        guard let streamInfo
        else { return }
            
        let isometrik = viewModel.isometrik
        isometrik.getUserSession().setUserType(userType: .host)
        
        let viewModel = StreamViewModel(isometrik: isometrik, streamsData: streamInfo, delegate: self)
        viewModel.streamUserType = .host
        
        let streamController = StreamViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(streamController, animated: true)
        
    }
    
    func getUrlExtension(filePath: String) -> String {
        let fileURL = URL(string: filePath)
        return fileURL?.pathExtension ?? ""
    }
    
}

extension GoLiveViewController: ISMStreamActionDelegate {
    
    public func didShareStreamTapped(streamData: SharedStreamData, root: UINavigationController) {
        viewModel.externalActionDelegate?.didShareStreamTapped(streamData: streamData, root: root)
    }
    
    public func didStreamStoreOptionTapped(forUserType: StreamUserType, root: UINavigationController) {
        viewModel.externalActionDelegate?.didStreamStoreOptionTapped(forUserType: forUserType ,root: root)
    }
    
    public func didCloseStreamTapped(memberData: ISMMember?, callback: @escaping (Bool) -> (), root: UINavigationController) {}
    
}

// External view provider setup

extension GoLiveViewController {
    
    private func setupAddProductListView() {
        
        let contentContainerView = contentView.goLiveContentContainerView
        let contentStackView = contentContainerView.contentStackView
        let addProductView = contentContainerView.addProductView
        let customListView = addProductView.customListView
        
        if let customView = viewModel.addProductListViewProvider?.customAddProductListView() {
            
            //self.customAddProductView = customView
            customView.translatesAutoresizingMaskIntoConstraints = false
            customListView.addSubview(customView)
            customView.pin(to: customListView)
            
            if viewModel.productIds.isEmpty {
                contentContainerView.addProductViewHeightConstraint?.constant = 170
            } else {
                // setting view's height based on the content view's height
                contentContainerView.addProductViewHeightConstraint?.constant = customView.frame.height
            }
            
            // setting view's height based on the content view's height
            contentContainerView.addProductViewHeightConstraint?.constant = customView.frame.height
            
            contentStackView.addArrangedSubview(addProductView)
        }
        
    }
    
    public func updateAddProductListView(with data: Any) {
        viewModel.addProductListViewProvider?.updateAddProductListView(with: data)
    }

    
}
