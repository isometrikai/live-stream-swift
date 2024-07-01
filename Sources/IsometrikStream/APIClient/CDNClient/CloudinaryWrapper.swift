//
//  CloudinaryWrapper.swift
//  ISOMetrikSDK
//
// Created by Appscrip on 26/08/20.
//  Copyright © 2020 Appscrip. All rights reserved.
//

import Foundation
import UIKit
import Cloudinary

/// Cloudinary wrapper to upload the images on server.
final public class CloudinaryWrapper {
        
    fileprivate var cloudinary: CLDCloudinary?

    private init() {
        guard let config = CLDConfiguration(cloudinaryUrl: "cloudinary://665784837197343:HLNebnyS24gRCh_v-cCrB36Wjbg@dedibgpdw") else { return }
        cloudinary = CLDCloudinary(configuration: config)
    }
    
    /// Upload image to cloudinary
    /// - Parameters:
    ///   - image: Image need to upload, Type should be UIImage
    ///   - onCompletion: completion handler to get the image URL.
    public class func uploadImage(image: UIImage, width: CGFloat = 500, height: CGFloat = 500, onCompletion: @escaping (_ imageURL: String?) -> Void) {
        let resizedImage = image.resizeImage(image: image ,targetSize: CGSize(width: width, height: height))
        guard let imageData = resizedImage.jpegData(compressionQuality: 0.7) else {
            onCompletion(nil)
            return
        }
        let params = CLDUploadRequestParams()
        params.setFolder("Isometrik/iOS/streams")
        CloudinaryWrapper().cloudinary?.createUploader().signedUpload(data: imageData, params: params, progress: nil, completionHandler: { (result, error) in
            if error != nil {
                onCompletion(nil)
            } else {
                guard let url = result?.secureUrl else {
                    onCompletion(nil)
                    return
                }
                onCompletion(url)
            }
        })
    }
    
}



extension UIImage {
    
    public func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
       let size = image.size

       let widthRatio  = targetSize.width  / size.width
       let heightRatio = targetSize.height / size.height

       // Figure out what our orientation is, and use that to form the rectangle
       var newSize: CGSize
       if(widthRatio > heightRatio) {
           newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
       } else {
           newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
       }
        

       // This is the rect that we've calculated out and this is what is actually used below
       let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

       // Actually do the resizing to the rect using the ImageContext stuff
       UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
       image.draw(in: rect)
       let newImage = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()

       return newImage!
   }
    
}

