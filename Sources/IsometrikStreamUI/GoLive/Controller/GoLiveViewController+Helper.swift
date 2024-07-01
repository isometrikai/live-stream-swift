//
//  GoLiveViewController+Helper.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 07/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import AVFoundation
import MBProgressHUD

extension GoLiveViewController {
    
    func openCoinDialog(){
        
//        let viewController = PaidStreamCardViewController()
//        let premiumButton = headerView.premiumButton
//
//        let sheetController = SheetViewController(
//            controller: viewController,
//            sizes: [.fixed(350 + ISM_windowConstant.getBottomPadding) , .marginFromTop(ISM_windowConstant.getTopPadding + 50)], options: viewModel.options)
//
//        viewController.coinTextField.becomeFirstResponder()
//
//        viewController.selectedCoin = { (coins) in
//            if coins != 0 {
//                self.viewModel.selectedCoins = coins
//                premiumButton.setImage(UIImage(named: "Coin_balance"), for: .normal)
//                premiumButton.setTitle(" \(coins) coins", for: .normal)
//            } else {
//                if self.viewModel.selectedCoins == 0 {
//                    premiumButton.setTitle("Premium".ism_localized, for: .normal)
//                    premiumButton.setImage(UIImage(named: "ism_Classic"), for: .normal)
//                }
//            }
//        }
//
//        sheetController.gripSize = CGSize(width: 0, height: 0)
//        sheetController.gripColor = UIColor(white: 0, alpha: 0)
//        sheetController.cornerRadius = 0
//        sheetController.minimumSpaceAbovePullBar = 0
//        sheetController.pullBarBackgroundColor = UIColor.clear
//        sheetController.treatPullBarAsClear = false
//        sheetController.dismissOnOverlayTap = true
//        sheetController.dismissOnPull = true
//        sheetController.allowPullingPastMaxHeight = false
//        sheetController.autoAdjustToKeyboard = true
//        self.present(sheetController, animated: true, completion: nil)
        
    }
    
    func createSession(){
        
        viewModel.captureSession = AVCaptureSession()
        viewModel.captureSession?.automaticallyConfiguresCaptureDeviceForWideColor = false
        viewModel.captureSession?.sessionPreset = .medium
        
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("No front camera.")
            return 
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            
            viewModel.stillImageOutput = AVCapturePhotoOutput()
            
            let canAddInput = viewModel.captureSession?.canAddInput(input) ?? false
            let canAddOutput = viewModel.captureSession?.canAddOutput(viewModel.stillImageOutput) ?? false
            
            if canAddInput && canAddOutput {
                viewModel.captureSession?.addInput(input)
                viewModel.captureSession?.addOutput(viewModel.stillImageOutput)
            }
            
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    func setupLivePreview() {
        
        guard let captureSession = viewModel.captureSession
        else { return }
        
        viewModel.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        viewModel.videoPreviewLayer.videoGravity = .resizeAspectFill
        viewModel.videoPreviewLayer.connection?.videoOrientation = .portrait
        cameraView.layer.addSublayer(viewModel.videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
        
        viewModel.videoPreviewLayer.frame = self.cameraView.bounds
        
    }
    
    func updateCameraStatus(forStreamType: GoLiveStreamType) {
        
        switch forStreamType {
        case .guestLive:
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                // start capture session
                self.viewModel.captureSession?.startRunning()

                DispatchQueue.main.async {
                    self.cameraView.isHidden = false
                }
                
            }
            
        case .fromDevice:
            
            DispatchQueue.global(qos: .userInitiated).async {
                // stop capture session
                self.viewModel.captureSession?.stopRunning()
                DispatchQueue.main.async {
                    self.cameraView.isHidden = true
                }
            }
            
        }
    }
    
}

extension GoLiveViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    /// Image picker view controller
    func configureImagePickerViewController() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        imagePicker.videoMaximumDuration = 15.0
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            self.dismiss(animated: true, completion: nil)
            
            viewModel.videoPreviewUrl = url
            let uiImage = self.getImageFromVideoUrl(url: url)
            let profileImage = contentView.rtmpOptionsContainerView.profileView.profileCoverImageView
            profileImage.image = uiImage
            contentView.rtmpOptionsContainerView.profileView.clearImageButton.isHidden = false
        }
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.dismiss(animated: true, completion: nil)
            
            let profileImage = contentView.rtmpOptionsContainerView.profileView.profileCoverImageView
            profileImage.image = pickedImage
            contentView.rtmpOptionsContainerView.profileView.clearImageButton.isHidden = false
            //self.present(cropVC, animated: true, completion: nil)
        }
    }
    
    func getImageFromVideoUrl(url: URL?) -> UIImage? {
        
        guard let url else { return UIImage() }
        
        let asset = AVURLAsset(url: url, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let cgImage = try imgGenerator.copyCGImage(at: CMTime(value: 0, timescale: 1), actualTime: nil)
            let uiImage = UIImage(cgImage: cgImage)
            return uiImage
        } catch {
            print(error)
            return UIImage()
        }
        
    }
    
}

extension GoLiveViewController: AVCapturePhotoCaptureDelegate {
    
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        
        let profileImageView = contentView.rtmpOptionsContainerView.profileView.profileCoverImageView
        contentView.rtmpOptionsContainerView.profileView.clearImageButton.isHidden = false
        
        let image = UIImage(data: imageData)
        profileImageView.image = image
        
        MBProgressHUD.hide(for: self.view, animated: true)
        
        didGoLiveButtonTapped()
    }
    
}
