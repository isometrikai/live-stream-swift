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

extension GoLiveViewController: GoLiveHeaderActionDelegate {
    
    func didClearImageButtonTapped() {
        let profileView = contentView.rtmpOptionsContainerView.profileView
        profileView.clearImageButton.isHidden = true
        profileView.profileCoverImageView.image = nil
        viewModel.videoPreviewUrl = nil
    }
    
    func didCloseButtonTapped() {
        self.dismiss(animated: true)
    }
    
    func didActionButtonTapped(with actionType: GoLiveActionType) {
        
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
        let profileView = contentView.rtmpOptionsContainerView.profileView
        
        let streamTextView = profileView.streamTextView.text
        let profileImageView = profileView.profileCoverImageView
        
//        if streamTextView == "Add description..." {
//            self.ism_showAlert("Error", message: "Stream Title Required!")
//            return
//        }
        
        // show user error if mqtt connection not connected
        if !(isometrik.getMqttSession().isConnected) {
            self.view.makeToast("connection not established, Try Again".localized + "!",duration: 3.0, position: .bottom)
            return
        }
        
//        if viewModel.selectedProducts.count == 0 {
//            self.ism_showAlert("Error", message: "Add products to proceed".localized + "!")
//            return
//        }
        
        if viewModel.isScheduleStream {
            if viewModel.scheduleFor == nil {
                self.ism_showAlert("Error", message: "Choose Date and Time for scheduling".localized + "!")
                return
            }
        }
        
//        if let image = profileImageView.image {
//            ISMLiveShowLoader.shared.startLoading()
//            
//            let description = streamTextView.unwrap
//            let userData = isometrik.getUserSession().getUserModel()
//            
//            viewModel.uploadImage(image: image) { imageUrl in
//                let imageUrlString = String(imageUrl ?? "")
//                self.startNewStream(userData: userData, description: description, imagePath: imageUrlString, videoPath: "")
//            }
//            
//        } else {
//            
//            // Add condition for fromDevice case only
//            if viewModel.currenStreamType == .fromDevice {
//                self.ism_showAlert("Error", message: "Stream Cover Image required".localized + "!")
//                return
//            }
//            
//            ISMLiveShowLoader.shared.startLoading()
//            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
//            viewModel.stillImageOutput.capturePhoto(with: settings, delegate: self)
//            
//        }
        
        
        ISMLiveShowLoader.shared.startLoading()

        let description = streamTextView.unwrap
        let userData = isometrik.getUserSession().getUserModel()
        self.startNewStream(userData: userData, description: description, imagePath: "https://picsum.photos", videoPath: "")
        
    }
    
    func didGoLiveStreamTypeActionTapped(with actionType: GoLiveStreamType) {
        
        viewModel.currenStreamType = actionType
        updateCameraStatus(forStreamType: actionType)
        
        // animate to the required action
        footerView.animateStreamTypeActions(action: actionType)
        
        let stackView = contentView.rtmpOptionsContainerView.toggleStackView
        let persistentRTMPView = contentView.rtmpOptionsContainerView.rtmpStreamKeyToggle
        let rtmpURLView = contentView.rtmpOptionsContainerView.rtmpURLView
        let streamKeyView = contentView.rtmpOptionsContainerView.streamKeyView
        let infoLabelView = contentView.rtmpOptionsContainerView.infoLabelView
        let helpLabelView = contentView.rtmpOptionsContainerView.helpLabelView
        let profileView = contentView.rtmpOptionsContainerView.profileView
        
        switch actionType {
        case .guestLive:
            
            viewModel.isHdBroadcast = false
            contentView.rtmpOptionsContainerView.animateToggles(withStreamOption: .hdBroadCast, isSelected: viewModel.isHdBroadcast)
            
            viewModel.isPersistentRTMPKey = false
            
            viewModel.isRTMPStream = false
            
            persistentRTMPView.isHidden = true
            stackView.removeArrangedSubview(persistentRTMPView)
            
            rtmpURLView.isHidden = true
            stackView.removeArrangedSubview(rtmpURLView)
            
            streamKeyView.isHidden = true
            stackView.removeArrangedSubview(streamKeyView)
            
            infoLabelView.isHidden = true
            stackView.removeArrangedSubview(infoLabelView)
            
            helpLabelView.isHidden = true
            stackView.removeArrangedSubview(helpLabelView)
            
            break
        case .fromDevice:
            
            // by default both hdBroadcast and persistent rtmp key will be on
            viewModel.isHdBroadcast = true
            contentView.rtmpOptionsContainerView.animateToggles(withStreamOption: .hdBroadCast, isSelected: viewModel.isHdBroadcast)
            
            viewModel.isPersistentRTMPKey = true
            contentView.rtmpOptionsContainerView.animateToggles(withStreamOption: .persistentRTMPKey, isSelected: viewModel.isPersistentRTMPKey)
            
            // As camera is not available here so user has to select image from gallery
            profileView.profileCoverImageView.image = nil
            profileView.clearImageButton.isHidden = true
            
            viewModel.isRTMPStream = true
            
            persistentRTMPView.isHidden = false
            stackView.addArrangedSubview(persistentRTMPView)
            
            rtmpURLView.isHidden = false
            stackView.addArrangedSubview(rtmpURLView)
            
            streamKeyView.isHidden = false
            stackView.addArrangedSubview(streamKeyView)
            
            infoLabelView.isHidden = false
            stackView.addArrangedSubview(infoLabelView)
            
            helpLabelView.isHidden = false
            stackView.addArrangedSubview(helpLabelView)
            
            break
        }
        
    }
    
}

// MARK: - CONTENT ACTIONS

extension GoLiveViewController: LiveOptionsActionDelegate {
    
    func didToggleOptionTapped(withStreamOption: StreamOptionToggle) {
        
        let rtmpContainerView = contentView.rtmpOptionsContainerView
        let stackview = rtmpContainerView.toggleStackView
        let contentStackView = rtmpContainerView.contentStackView
        let rtmpURLView = contentView.rtmpOptionsContainerView.rtmpURLView
        let streamKeyView = contentView.rtmpOptionsContainerView.streamKeyView
        let infoLabelView = contentView.rtmpOptionsContainerView.infoLabelView
        let helpLabelView = contentView.rtmpOptionsContainerView.helpLabelView
        let restreamDetailLink = contentView.rtmpOptionsContainerView.restreamOption
        let addProductView = rtmpContainerView.addProductView
        let restreamOption = rtmpContainerView.restreamOption
        let scheduleToggle = rtmpContainerView.scheduleToggle
        let dateSelectorView = rtmpContainerView.dateTimeSelectorView
        let goLiveButton = footerView.goLiveButton
        
        switch withStreamOption {
        case .hdBroadCast:
            
            viewModel.isHdBroadcast = !viewModel.isHdBroadcast
            
            rtmpContainerView.animateToggles(withStreamOption: .hdBroadCast, isSelected: viewModel.isHdBroadcast)
            
        case .recordBroadCast:
            
            viewModel.recordBroadcast = !viewModel.recordBroadcast
            
            rtmpContainerView.animateToggles(withStreamOption: .recordBroadCast, isSelected: viewModel.recordBroadcast)
            
        case .restreamBroadcast:
            
            viewModel.restreamBroadcast = !viewModel.restreamBroadcast
            
            rtmpContainerView.animateToggles(withStreamOption: .restreamBroadcast, isSelected: viewModel.restreamBroadcast)
            
            if viewModel.restreamBroadcast {
                
                contentStackView.addArrangedSubview(restreamOption)
                contentStackView.addArrangedSubview(addProductView)
                contentStackView.addArrangedSubview(scheduleToggle)
                contentStackView.addArrangedSubview(dateSelectorView)
                restreamDetailLink.isHidden = false
                
            } else {
                
                contentStackView.removeArrangedSubview(restreamDetailLink)
                restreamDetailLink.isHidden = true
                
            }
            
        case .persistentRTMPKey:
            
            viewModel.isPersistentRTMPKey = !viewModel.isPersistentRTMPKey
            
            rtmpContainerView.animateToggles(withStreamOption: .persistentRTMPKey, isSelected: viewModel.isPersistentRTMPKey)
            
            if !viewModel.isPersistentRTMPKey {
                
                // if user disable the persistent
                stackview.removeArrangedSubview(rtmpURLView)
                stackview.removeArrangedSubview(streamKeyView)
                stackview.removeArrangedSubview(helpLabelView)
        
                // hide views
                rtmpURLView.isHidden = true
                streamKeyView.isHidden = true
                helpLabelView.isHidden = true
                
                // change the text in info label
                infoLabelView.formLabel.text = "If you disable PERSISTENT RTMP URL you will get a new URL and a stream key every time you start a new stream".localized
                
            } else {
                
                // removing it before to maintain order
                stackview.removeArrangedSubview(infoLabelView)
                
                // unhide hidden views
                rtmpURLView.isHidden = false
                streamKeyView.isHidden = false
                helpLabelView.isHidden = false
                
                // if user enable the persistent
                stackview.addArrangedSubview(rtmpURLView)
                stackview.addArrangedSubview(streamKeyView)
                stackview.addArrangedSubview(infoLabelView)
                stackview.addArrangedSubview(helpLabelView)
                
                // change the text in info label
                infoLabelView.formLabel.text = "Please copy paste the STREAM KEY and the STREAM URL  into your RTMP streaming device".localized + "."
            }
            
        case .scheduleStream:
            
            viewModel.isScheduleStream = !viewModel.isScheduleStream
            rtmpContainerView.animateToggles(withStreamOption: .scheduleStream, isSelected: viewModel.isScheduleStream)
            
            if viewModel.isScheduleStream {
                
                // change action button state
                goLiveButton.setTitle("Schedule Stream".localized, for: .normal)
                
                contentStackView.addArrangedSubview(dateSelectorView)
                dateSelectorView.isHidden = false
                
            } else {
                contentStackView.removeArrangedSubview(dateSelectorView)
                dateSelectorView.isHidden = true
                
                viewModel.scheduleFor = nil
                self.contentView.rtmpOptionsContainerView.dateTimeSelectorView.formTextView.customTextLabel.text = "Choose Date and Time".localized
                
                goLiveButton.setTitle("Go Live".localized, for: .normal)
                
            }
            
            break
        }
        
    }
    
    func didDateTimeSelectorTapped() {
        
        if #available(iOS 15.0, *) {
            let controller = ScheduleStreamPopupViewController()
            controller.modalPresentationStyle = .pageSheet
            controller.sheetPresentationController?.detents = [.medium()]
            
            controller.selectedDate = viewModel.scheduleFor
            
            controller.scheduleForCallback = { [weak self] date in
                guard let self = self else { return }
                self.viewModel.scheduleFor = date
                self.contentView.rtmpOptionsContainerView.dateTimeSelectorView.formTextView.customTextLabel.text = date.ism_toString(format: "d MMM YYYY, h:mm a")
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
        self.view.makeToast("RTMP URL Copied".localized + "!", duration: 2.0, position: .bottom)
        
    }
    
    func didStreamKeyCopied() {
        // write to clipboard
        UIPasteboard.general.string = viewModel.streamKey
        
        // copied animation
        self.view.makeToast("Stream Key Copied".localized + "!", duration: 2.0, position: .bottom)
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
        
        let containerView = contentView.rtmpOptionsContainerView
        let addProductView = containerView.addProductView
        
        let controller = AllProductsViewController()
        
        let viewModel = ProductViewModel(isometrik: viewModel.isometrik)
        // changing the selected flag to true for selected products
        self.viewModel.selectedProducts.indices.forEach { index in
            self.viewModel.selectedProducts[index].isSelected = true
        }
        viewModel.selectedProductList = self.viewModel.selectedProducts
        viewModel.productList = self.viewModel.allProducts
        controller.productViewModel = viewModel
        
        controller.product_Callback = { [weak self] (selectedProducts, allProducts) in
            
            guard let selectedProducts, let self else {
                // reset the product option height
                containerView.addProductViewHeightConstraint?.constant = 170
                addProductView.addButton.isHidden = true
                return
            }
            
            self.viewModel.selectedProducts = selectedProducts
            self.viewModel.allProducts = allProducts
            containerView.addProductViewHeightConstraint?.constant = 290
            addProductView.addButton.isHidden = false
            addProductView.productData = selectedProducts
            
        }
        
        let navVC = UINavigationController(rootViewController: controller)
        navVC.modalPresentationStyle = .pageSheet
        navVC.isModalInPresentation = false
        
        self.present(navVC, animated: true)
    }
    
    func didRemoveProduct(index: Int) {
        // remove the selected product
        var selectedProducts = viewModel.selectedProducts
        let containerView = contentView.rtmpOptionsContainerView
        let addProductView = containerView.addProductView
        
        let toBeRemovedProductId = viewModel.selectedProducts[index].childProductID ?? ""
        
        if !(selectedProducts.count > 0) {
            return
        }
        
        selectedProducts.remove(at: index)
        if selectedProducts.count == 0 {
            addProductView.addButton.isHidden = true
            
            // Change the height of addProductView to normal
            containerView.addProductViewHeightConstraint?.constant = 170
            
            viewModel.allProducts.removeAll()
        }
        
        // making change to all products too
        if let indexToChange = viewModel.allProducts.firstIndex(where: {$0.childProductID == toBeRemovedProductId}) {
            viewModel.allProducts[indexToChange].isSelected = false
            viewModel.allProducts[indexToChange].liveStreamfinalPriceList?.discountPercentage = 0
        }
        
        viewModel.selectedProducts = selectedProducts
        addProductView.productData = selectedProducts
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer){
        
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
        
        var paidAmount = 0
        var isPaid = false
        if viewModel.selectedCoins > 0 {
            paidAmount = viewModel.selectedCoins
            isPaid = true
        } else {
            paidAmount = 0
            isPaid = false
        }
        
//        let streamBody = StartStreamBody(
//            streamImage: imagePath,
//            streamDescription: description,
//            selfHosted: viewModel.selfHosted,
//            restream: viewModel.restreamBroadcast,
//            productsLinked: viewModel.productsLinked,
//            products: viewModel.products,
//            multiLive: viewModel.multiLive,
//            members: viewModel.members,
//            lowLatencyMode: viewModel.lowLatencyMode,
//            isPublic: viewModel.isPublic,
//            hdBroadcast: viewModel.isHdBroadcast,
//            enableRecording: viewModel.recordBroadcast,
//            audioOnly: viewModel.audioOnly,
//            rtmpIngest: viewModel.isRTMPStream,
//            persistRtmpIngestEndpoint: viewModel.isPersistentRTMPKey
//        )
        
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
            paymentAmount: viewModel.paidAmount,
            userName: userName,
            rtmpIngest: viewModel.isRTMPStream,
            persistRtmpIngestEndpoint: viewModel.isPersistentRTMPKey,
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
            ISMLiveShowLoader.shared.stopLoading()
            
            if self.viewModel.isScheduleStream {
                
                let controller = CustomConfirmationPopupViewController()
                controller.infoLabel.text = "Stream Successfully scheduled".localized + "!"
                controller.isModalInPresentation = true
                
                if #available(iOS 16.0, *) {
                    if let sheet = controller.sheetPresentationController {
                        sheet.detents = [.custom(resolver: { context in
                            250 + ism_windowConstant.getBottomPadding
                        })]
                    }
                } else {
                    // Fallback on earlier versions
                }
                
                // callback
                controller.close_callback = { [weak self] in
                    guard let self else { return }
                    self.viewModel.captureSession?.stopRunning()
                    DispatchQueue.main.async {
                        self.dismiss(animated: true)
                    }
                }
                
                //controller.playAnimation(for: "success-animation")
                
                self.present(controller, animated: true)
                
            } else {
                self.viewModel.captureSession?.stopRunning()
                
                var streamData = stream
                streamData.isPaid = isPaid
                streamData.paymentAmount = Double(paidAmount)
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
            
            switch error{
            case .noResultsFound(_):
                // handle noresults found here
                break
            case .invalidResponse:
                DispatchQueue.main.async {
                    self.view.showISMLiveErrorToast( message: "GoLive Error : Invalid Response")
                }
            case.networkError(let error):
                DispatchQueue.main.async {
                    self.view.showISMLiveErrorToast( message: "Network Error \(error.localizedDescription)")
                }
            case .httpError(let errorCode, let errorMessage):
                DispatchQueue.main.async {
                    self.view.showISMLiveErrorToast( message: "\(errorCode) \(errorMessage?.error ?? "error")")
                }
                
            default :
                DispatchQueue.main.async {
                    self.view.showISMLiveErrorToast( message: "Stream Error: Failed to start a new stream")
                }
                break
            }
            
        }
        
    }
    
    func updateScheduleStream(userData: ISMStreamUser, description: String, imagePath: String, videoPath: String, isPublic: Bool, multiLive: Bool, members:[String]? = [] , productLinked: Bool , products: [String] = []){
        
        guard let isometrikUserId = userData.userId,
              let streamData = viewModel.streamData
        else { return }
        
        let isometrik = viewModel.isometrik
        let userName = isometrik.getUserSession().getUserName()
        
        
        // create stream body
        let streamBody = StreamBody(
            streamImage: imagePath,
            streamPreviewUrl: videoPath,
            streamDescription: description,
            members: members ?? [],
            createdBy: isometrikUserId,
            isPublic: true,
            audioOnly: false,
            multiLive: multiLive,
            lowLatencyMode: false,
            restream: viewModel.restreamBroadcast,
            enableRecording: viewModel.recordBroadcast,
            hdBroadcast: viewModel.isHdBroadcast,
            isSelfHosted: true,
            productsLinked: productLinked,
            isPaid: streamData.isPaid ?? false,
            isPublicStream: true,
            isRecorded: viewModel.recordBroadcast,
            isScheduledStream: viewModel.isScheduleStream,
            paymentAmount: Int(streamData.paymentAmount ?? 0),
            streamTitle: userName, userName: userName,
            rtmpIngest: viewModel.isRTMPStream,
            persistRtmpIngestEndpoint: viewModel.isPersistentRTMPKey,
            isHighLighted: false,
            scheduleStartTime: Int64(streamData.scheduleStartTime ?? 0),
            isometrikUserId: isometrikUserId,
            taggedProductIds: viewModel.selectedProducts.isEmpty ? streamData.taggedProductIds : viewModel.getProductIds(),
            storeId: viewModel.getStoreId(),
            storeCategoryId: "",
            products: viewModel.selectedProducts.isEmpty ? streamData.products : viewModel.getPayloadForMyProducts(),
            otherProducts: viewModel.selectedProducts.isEmpty ? streamData.otherProducts : viewModel.getPayloadForOtherProducts(),
            eventId: streamData._id ?? ""
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
            
            ISMLiveShowLoader.shared.stopLoading()
            
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
            }
            
            // callback
            controller.close_callback = { [weak self] in
                guard let self else { return }
                self.viewModel.captureSession?.stopRunning()
                DispatchQueue.main.async {
                    self.viewModel.update_callback?(streamData._id ?? "")
                    self.dismiss(animated: true)
                }
            }
            
            //controller.playAnimation(for: "success-animation")
            self.present(controller, animated: true)
            
        } failure: { [weak self] error in
            
            guard let self else { return }
            
            ISMLiveShowLoader.shared.stopLoading()
            
            switch error{
            case .noResultsFound(_):
                // handle noresults found here
                break
            case .invalidResponse:
                DispatchQueue.main.async {
                    self.view.showISMLiveErrorToast( message: "GoLive Error : Invalid Response")
                }
            case.networkError(let error):
                DispatchQueue.main.async {
                    self.view.showISMLiveErrorToast( message: "Network Error \(error.localizedDescription)")
                }
            case .httpError(let errorCode, let errorMessage):
                DispatchQueue.main.async {
                    self.view.showISMLiveErrorToast( message: "\(errorCode) \(errorMessage?.error ?? "error")")
                }
                
            default :
                DispatchQueue.main.async {
                    self.view.showISMLiveErrorToast( message: "Stream Error: Failed to start a new stream")
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
        
        let viewModel = StreamViewModel()
        viewModel.streamUserType = .host
        viewModel.streamsData = streamInfo
        viewModel.isometrik = isometrik
        
        let streamController = StreamViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(streamController, animated: true)
        
    }
    
    func getUrlExtension(filePath: String) -> String {
        let fileURL = URL(string: filePath)
        return fileURL?.pathExtension ?? ""
    }
    
}
