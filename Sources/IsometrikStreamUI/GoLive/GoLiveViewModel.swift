//
//  GoLiveViewModel.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 07/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import IsometrikStream

enum StreamOptionToggle: Int {
    case hdBroadCast = 1
    case recordBroadCast
    case persistentRTMPKey
    case restreamBroadcast
    case scheduleStream
}

enum GoLiveStreamType: Int {
    case guestLive = 1
    case fromDevice
}

enum GoLivePremiumActionType {
    case paid
    case free
}

public protocol GoliveAddProductListViewProvider {
    func customAddProductListView() -> UIView
    func updateAddProductListView(with data: Any)
}

typealias response = ((Bool) -> Void)

final public class GoLiveViewModel {
    
    // For edit stream
    var streamData: ISMStream?
    var isEditing: Bool = false
    //:
    
    var isometrik: IsometrikSDK
    var externalActionDelegate: ISMGoLiveActionDelegate?
    var addProductListViewProvider: GoliveAddProductListViewProvider?
    
    var currenStreamType: GoLiveStreamType = .guestLive
    let uploadingManager = UploadingManager()
    
    var isPaid: Bool = false
    var paidAmount: Int = 0
    
    var isProductLinked: Bool = false
    var isSelfHosted: Bool = true
    var isHdBroadcast: Bool = false
    var recordBroadcast: Bool = false
    var restreamBroadcast: Bool = false
    var isRTMPStream: Bool = false
    var isPersistentRTMPKey: Bool = false
    var lowLatencyMode: Bool = false
    var isPublic: Bool = true
    var productsLinked: Bool = false
    var products: [String] = []
    var selfHosted: Bool = true
    var audioOnly: Bool = false
    
    var multiLive: Bool = true
    var members: [String] = []
    
    var isScheduleStream: Bool = false
    var scheduleFor: Date?
    
    var thumbImagePicker = UIImagePickerController()
    
    var userDetail: ISMStreamUser?
    
    var rtmpURL: String = "rtmp://rtmp.isometrik.io"
    var streamKey: String = ""
    var videoPreviewUrl: URL?
    var presignedUrlString: String?
    var mediaUrlString: String?
    var newImagePicked: Bool = false
    
    var selectedCoins: Int = 0
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var stillImageOutput: AVCapturePhotoOutput!
    var productIds: [String] = []
    
    
//    var selectedProducts: [StreamProductModel] = []
//    var allProducts: [StreamProductModel] = []
    
    var update_callback: ((_ streamId: String)->())?
    
    public init(isometrik: IsometrikSDK, delegate: ISMGoLiveActionDelegate? = nil, addProductListViewProvider: GoliveAddProductListViewProvider? = nil) {
        self.isometrik = isometrik
        self.externalActionDelegate = delegate
        self.addProductListViewProvider = addProductListViewProvider
//        self.productViewModel = ProductViewModel(isometrik: isometrik)
    }
    
    func getUserDetails(completion: @escaping response){
        
        isometrik.getIsometrik().fetchUser { userData in
            self.setRTMPKeys(ingestURL: userData.rtmpIngestUrl) { success in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        } failure: { error in
            print(error)
        }
        
    }
    
    func setRTMPKeys(ingestURL: String?, completion: @escaping response) {
        
        guard let ingestURL else { return }
        
        var url = ingestURL
        var componentArray = url.split(separator: "/")
        let streamKey = componentArray.last
        componentArray.removeLast()
        let rtmpUrl = componentArray.joined(separator: "//")
        
        self.streamKey = "\(streamKey ?? "")"
        self.rtmpURL = "\(rtmpUrl)"
        
        completion(true)
    }

    func getPayloadForMyProducts() -> [ISMProductToBeTagged] {
        
//        var products: [ISMProductToBeTagged] = []
//        
//        for selectedProduct in selectedProducts {
//            
//            // Only return the product from my store
//            if selectedProduct.storeId != nil && selectedProduct.storeId == self.getStoreId() {
//                let productId = selectedProduct.childProductID ?? ""
//                let categoryId = selectedProduct.categoryJson?.first?.categoryId ?? ""
//                let discountedPercentage = selectedProduct.liveStreamfinalPriceList?.discountPercentage ?? 0
//                let brandId = selectedProduct.brandId ?? ""
//                
//                let product = ISMProductToBeTagged(id:productId, discount: discountedPercentage, parentCategoryId: categoryId, brandId: brandId)
//                products.append(product)
//            } else {
//                break
//            }
//            
//        }
//        
//        return products
        return []
    }
    
    func getPayloadForOtherProducts() -> [ISMOthersProductToBeTagged] {
        
//        var otherProducts: [ISMOthersProductToBeTagged] = []
//        
//        for selectedProduct in selectedProducts {
//            
//            let storeId = selectedProduct.supplier?.id ?? ""
//            
//            // Only product which are not mine
//            if storeId != self.getStoreId() && !storeId.isEmpty {
//                
//                // check whether products for this store already added in the othersProduct array or not
//                let productForCurrentStore = otherProducts.filter { store in
//                    return store.storeId == storeId
//                }
//                
//                // if so return
//                if productForCurrentStore.count > 0 {
//                    break
//                }
//                
//                var products: [ISMProductToBeTagged] = []
//                
//                // filter the products with the storeId
//                let filteredProduct = selectedProducts.filter { product in
//                    if let productStoreId = product.supplier?.id {
//                        return productStoreId == storeId
//                    } else {
//                        return false
//                    }
//                }
//                
//                for productData in filteredProduct {
//                    let productId = productData.childProductID ?? ""
//                    let categoryId = productData.categoryJson?.first?.categoryId ?? ""
//                    let discountedPercentage = productData.liveStreamfinalPriceList?.discountPercentage ?? 0
//                    let brandId = selectedProduct.brandId ?? ""
//                    
//                    let product = ISMProductToBeTagged(id:productId, discount: discountedPercentage, parentCategoryId: categoryId, brandId: brandId)
//                    products.append(product)
//                }
//                
//                let otherProduct = ISMOthersProductToBeTagged(storeId: storeId, products: products)
//                otherProducts.append(otherProduct)
//                
//            }
//            
//        }
//        
//        return otherProducts
        return []
    }
    
    func getProductIds() -> [String] {
        
//        var products: [String] = []
//        
//        for selectedProduct in selectedProducts {
//            let productId = selectedProduct.childProductID ?? ""
//            products.append(productId)
//        }
//        
//        return products
//
        return []
    }
    
    func getStoreId() -> String {
//        if let storeId = UserDefaults.standard.value(forKey: AppConstants.UserDefaults.storeId) as? String {
//            return storeId
//        }
        return ""
    }
    
    func getUrlWithoutExtension(urlString: String) -> String {
        
        guard !urlString.isEmpty else { return "" } 
        
        var array = urlString.split(separator: ".")
        array.removeLast()
        let updatedString = array.joined(separator: ".")
        return updatedString
        
    }
    
    // MARK: FOR SCHEDULED STREAM UPDATES -
    
    func getProducts(_ completionBlock: @escaping(_ success: Bool) -> Void){
        
//        guard let streamData else { return }
//        productViewModel.streamInfo = streamData
//        
//        self.productViewModel.fetchTaggedProducts { success, error in
//            if success {
//                self.selectedProducts = self.productViewModel.taggedProductList
//                DispatchQueue.main.async {
//                    completionBlock(true)
//                }
//            } else {
//                DispatchQueue.main.async {
//                    completionBlock(false)
//                }
//            }
//        }
        
    }
    
    //:
    
    // MARK: Stream Uploads
    
    func getPresignedUrl(streamTitle: String, completion: @escaping (_ success: Bool, _ error: String?)-> Void) {
        
        isometrik.getIsometrik().getPresignedUrl(streamTitle: streamTitle, mediaExtension: "jpeg") { response in
            self.presignedUrlString = response.presignedUrl.unwrap
            self.mediaUrlString = response.mediaUrl.unwrap
            DispatchQueue.main.async {
                completion(true, nil)
            }
        } failure: { error in
            DispatchQueue.main.async {
                completion(false, error.localizedDescription)
            }
        }
        
    }
    
    func uploadStreamCover(image: UIImage, _ completion: @escaping (UploadStatus) -> Void){
        
        // Down sample the image before uploading
        if let downsampledImageData = downsampleImage(image: image, maxSizeInMB: 0.8), let downSampledImage = UIImage(data: downsampledImageData) {
            
            if let presignedUrlString, let presignedUrl = URL(string: presignedUrlString) {
                uploadingManager.uploadImageToS3(presignedURL: presignedUrl, image: downSampledImage) { result in
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
            }
            
        }
        
        
        
    }
    
    func uploadVideo(url: URL?, completion: @escaping (_ videoUrl: String?) -> Void) {
        guard let url else {
            completion(nil)
            return
        }
        let videoUrlExtension = url.absoluteString.getUrlExtension()
    }
    
    func downsampleImage(image: UIImage, maxSizeInMB: Double) -> Data? {
        let maxSizeInBytes = maxSizeInMB * 1024 * 1024
        var compression: CGFloat = 1.0
        var imageData = image.jpegData(compressionQuality: compression)
        
        while let data = imageData, Double(data.count) > maxSizeInBytes, compression > 0 {
            compression -= 0.1
            imageData = image.jpegData(compressionQuality: compression)
        }
        
        return imageData
    }
    
    //:
    
}
