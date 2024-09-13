//
//  File.swift
//  
//
//  Created by Appscrip 3Embed on 01/07/24.
//

import UIKit
import Photos
import IsometrikStream

extension GoLiveViewController {
    
    func requestPhotoLibraryPermission(from viewController: UIViewController, completion: @escaping (Bool) -> Void) {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized, .limited:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized || status == .limited {
                        completion(true)
                    } else {
                        self.showPhotoLibraryPermissionDeniedAlert(on: viewController)
                        completion(false)
                    }
                }
            }
        case .denied, .restricted:
            self.showPhotoLibraryPermissionDeniedAlert(on: viewController)
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
    func showPhotoLibraryPermissionDeniedAlert(on viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Photo Library Access Denied",
            message: "You have denied access to the photo library. Please go to Settings to enable it.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        })
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
}

extension GoLiveViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    /// Image picker view controller
    func configureImagePickerViewController() {
        requestPhotoLibraryPermission(from: self) { [weak self] granted in
            guard granted else {
                print("Photo library permission not granted")
                return
            }
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.mediaTypes = ["public.image", "public.movie"]
            imagePicker.videoMaximumDuration = 15.0
            self?.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            self.dismiss(animated: true, completion: nil)
            
            viewModel.videoPreviewUrl = url
            let uiImage = self.getImageFromVideoUrl(url: url)
            let profileImage = contentView.goLiveContentContainerView.profileView.profileCoverImageView
            profileImage.image = uiImage
            contentView.goLiveContentContainerView.profileView.clearImageButton.isHidden = false
        }
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.dismiss(animated: true, completion: nil)
            
            let profileImage = contentView.goLiveContentContainerView.profileView.profileCoverImageView
            profileImage.image = pickedImage
            viewModel.newImagePicked = true
            contentView.goLiveContentContainerView.profileView.clearImageButton.isHidden = false
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
        
        let profileImageView = contentView.goLiveContentContainerView.profileView.profileCoverImageView
        contentView.goLiveContentContainerView.profileView.clearImageButton.isHidden = false
        
        let image = UIImage(data: imageData)
        profileImageView.image = image
        
        CustomLoader.shared.stopLoading()
        
        didGoLiveButtonTapped()
    }
    
}

