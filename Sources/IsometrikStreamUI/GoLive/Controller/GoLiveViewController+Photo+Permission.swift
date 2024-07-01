//
//  File.swift
//  
//
//  Created by Appscrip 3Embed on 01/07/24.
//

import UIKit
import Photos
import MBProgressHUD

extension GoLiveViewController {
    
    func requestPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized, .limited:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    completion(status == .authorized || status == .limited)
                }
            }
        case .denied, .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
}

extension GoLiveViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    /// Image picker view controller
    func configureImagePickerViewController() {
        requestPhotoLibraryPermission { [weak self] granted in
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

