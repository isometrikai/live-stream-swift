import Foundation
import IsometrikStream

enum StreamProductsForm {
    case myStore
    case otherStore
}

enum StreamProductDiscountType: Int {
    case flat = 0
    case percentage
    case combo
}

class ProductViewModel {
    
    var myStore: Bool = true
    
    var isometrik: IsometrikSDK
//    var cartVM = CartVM()
    var streamInfo: ISMStream?
    
    // My Store
    
    var myStorePage = 1
    var totalProducts: Int = 0
    var productList: [StreamProductModel] = []
    var selectedProductList: [StreamProductModel] = []
    var taggedProductList: [StreamProductModel] = []
    var productsToRemove: [StreamProductModel] = []
    var totalTaggedProductCount = 0
    
    //:
    
    // Other Store
    var storesList: [StreamStoreModel] = []
    var storePage = 1
    var storeProductsTotalCount = 0
    
    var storeProductList: [StreamProductModel] = []
    var selectedStoreProductList: [StreamProductModel] = []
    //:
    
    var pinnedProductData: StreamProductModel?
    
    var limit: Int = 10
    var skip: Int = 0
    var isOfferEditable: Bool = false
    
    // callbacks
    var pinnedProduct_Callback: ((ProductViewModel?)-> Void)?
    var cartUpdates_callback: (()->Void)?
    //:
    
//    var savedAddressVM = SavedAddressVM()
    
    init(isometrik: IsometrikSDK) {
        self.isometrik = isometrik
//        savedAddressVM.address(type: .get, addLoader: false)
    }
    
    // MARK: - SERVICE FUNCTIONS
    
    func fetchProducts(_ completion: @escaping(Bool, String?)->Void) {
        
//        guard let storeId = UserDefaults.standard.object(forKey: AppConstants.UserDefaults.storeId) as? String
//        else {
//            completion(false, "Unknown error")
//            return
//        }
        
        let storeId = ""
        
        fetchStoreProducts(storeId: storeId, myStore: true) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
        
    }
    
    func fetchProductDetails(productId: String, _ completion: @escaping(_ productData: StreamProductModel?,  _ errorString: String?)->Void) {
        
        isometrik.getIsometrik().getProductDetails(productId: productId) { result in
            guard let productListData = result.data?.productData?.data else { return }
            
            if productListData.count > 0 {
                DispatchQueue.main.async {
                    completion(productListData.first, nil)
                }
            } else {
                completion(nil, "Product data not found")
            }
        } failure: { error in
            print(error)
            DispatchQueue.main.async {
                completion(nil, "error")
            }
        }

    }
    
    func fetchTaggedProducts(query: String = "", clearBeforeCall: Bool = false, _ completion: @escaping(Bool, String?)->Void) {
        
        guard let streamInfo
        else { return }
        
        var streamId = ""
        let streamStatus = LiveStreamStatus(rawValue: streamInfo.status ?? "SCHEDULED")
        
        streamId = streamInfo._id.unwrap
        if streamId.isEmpty {
            streamId = streamInfo.streamId.unwrap
        }
        
        isometrik.getIsometrik().getTaggedProductsInStream(streamId: streamId, skip: skip, limit: limit, query: query) { result in
            
            guard let productListData = result.data else {
                DispatchQueue.main.async {
                    completion(false, "")
                }
                return
            }
            
//                if self.productList.count.isMultiple(of: self.limit) {
//                    self.skip += self.limit
//                }
            
            if clearBeforeCall {
                self.taggedProductList.removeAll()
                self.totalTaggedProductCount = 0
            }
            
            self.totalTaggedProductCount = result.count ?? 0
            
            if self.taggedProductList.count > 0 {
                self.taggedProductList.append(contentsOf: productListData)
            } else {
                self.taggedProductList = productListData
            }
            
            // automatically add to selected product list
            self.addTaggedProductToSelectedList()
            
            DispatchQueue.main.async {
                completion(true, nil)
            }
            
        } failure: { error in
            print(error)
            DispatchQueue.main.async {
                completion(false, "error string")
            }
        }
        
    }
    
    func pinProduct(productId: String, _ completion: @escaping(Bool, String?)->Void){
        
        guard let streamInfo
        else {
            completion(false, "")
            return
        }
        
        var streamId = streamInfo._id.unwrap
        if streamId.isEmpty {
            streamId = streamInfo.streamId.unwrap
        }
        
        let bodyData = StreamPinProductBodyModel(streamId: streamId, productId: productId)
        
        isometrik.getIsometrik().pinProductStream(bodyData: bodyData) { result in
            
            guard let success = result.status else {
                completion(false, "")
                return
            }
            
            let message = result.message.unwrap
            
            DispatchQueue.main.async {
                if success == "success" {
                    
                    // set current pin product data
                    guard let productData = self.getProductData(productId: productId) else { return }
                    self.pinnedProductData = productData
                    
                    completion(true, nil)
                    
                } else {
                    completion(false, message)
                }
            }
            
        } failure: { error in
            print(error)
            DispatchQueue.main.async {
                completion(false, "error string")
            }
        }
        
    }
    
    func fetchPinnedProductInStream(_ completion: @escaping(_ pinnedProductId: String?, _ errorString: String?)->Void) {
        
        guard let streamInfo
        else { return }
        
        let streamId = streamInfo._id.unwrap
        
        isometrik.getIsometrik().getPinnedProduct(streamId: streamId) { result in
        
            guard let pinnedProductData = result.data else { return }
            
            let pinnedProductId = pinnedProductData.pinProductId ?? ""
            
            DispatchQueue.main.async {
                completion(pinnedProductId, nil)
            }
            
        } failure: { error in
            print(error)
            DispatchQueue.main.async {
                completion(nil, "error string")
            }
        }
        
    }
    
    func updateOfferOnProduct(productData: StreamProductModel?, discountPercentage: Double, _ completion: @escaping(Bool, String?)->Void){
        
        guard let productData
        else { return }
        
        let productId = productData.childProductID ?? ""
        let offerId = productData.productOfferId ?? ""
    
        let bodyData = UpdateOfferModel(productId: productId, offerId: offerId, offerPrice: discountPercentage)
        
        isometrik.getIsometrik().updateProductOffer(bodyData: bodyData) { result in
            
            let message = result.message.unwrap
            DispatchQueue.main.async {
                completion(true, nil)
            }
            
        } failure: { error in
            print(error)
            DispatchQueue.main.async {
                completion(false, "Error while updating offer!")
            }
        }
        
    }
    
    // MARK: -  LOCAL FUNCTION
    
    func getMyStoreId() -> String {
//        if let storeId = UserDefaults.standard.value(forKey: AppConstants.UserDefaults.storeId) as? String {
//            return storeId
//        }
        return ""
    }
    
    func updateSelectedProducts(productData: StreamProductModel, _ completion: @escaping(() -> Void)){
        
        let filteredData = selectedProductList.filter { data in
            data.childProductID == productData.childProductID
        }
        
        if filteredData.count > 0 {
            
            for i in 0..<selectedProductList.count {
                
                guard let currentProduct = selectedProductList[safe:i] else { return }
                
                if currentProduct.childProductID == productData.childProductID{
                    if productData.isSelected {
                        // replace if exist and isSelected
                        selectedProductList[i] = productData
                    } else {
                        // otherwise remove from list
                        selectedProductList.removeAll { product in
                            product.childProductID == productData.childProductID
                        }
                    }
                    completion()
                }
            }
            
        } else {
            selectedProductList.append(productData)
            completion()
        }
        
    }
    
    func unselectProductFromProductList(productData: StreamProductModel, _ completion: @escaping(() -> Void)){
        
        let index = productList.firstIndex { data in
            data.childProductID == productData.childProductID
        }
        
        guard let index else {
            completion()
            return
        }
        
        productList[index].isSelected = false
        productList[index].liveStreamfinalPriceList?.discountPercentage = 0.0
        completion()
        
    }
    
    func getProductData(productId: String) -> StreamProductModel? {
        
        let filteredData = taggedProductList.filter { product in
            product.childProductID == productId
        }
        
        if !(filteredData.count > 0) {
            return nil
        }
        
        return filteredData.first
        
    }
    
    func addTaggedProductToSelectedList(){
        
        self.selectedProductList = taggedProductList
        
        // make
        self.selectedProductList.forEach { product in
            if let indexToChange = self.selectedProductList.firstIndex(where: {$0.childProductID == product.childProductID}) {
                selectedProductList[indexToChange].isSelected = true
            }
        }
        
    }
    
    func updateAllProductListFromSelectedProduct(_ completion: @escaping(() -> Void)){
        
        selectedProductList.forEach { product in
            
            let filteredData = productList.filter { data in
                data.childProductID == product.childProductID
            }
            
            if filteredData.count > 0 {
                
                for i in 0..<productList.count {
                    guard let currentProduct = productList[safe:i] else { return }
                    if currentProduct.childProductID == product.childProductID{
                        productList[i].liveStreamfinalPriceList = product.liveStreamfinalPriceList
                        productList[i].finalPriceList = product.finalPriceList
                        productList[i].isSelected = product.isSelected
                        DispatchQueue.main.async {
                            completion()
                        }
                    }
                }
                
            }
            
        } //: loop
        
    }
    
    func pinNextProductInTaggedList(_ completion: @escaping(Bool, String?)->Void){
        
        guard let pinnedProductData else { return }
        
        let pinnedProductId = pinnedProductData.childProductID ?? ""
        let pinnedProductIndex = pinnedProductIndexInTaggedProductList(pinnedProductId: pinnedProductId)
        var nextItemIndex = 0
        if taggedProductList.count > (pinnedProductIndex + 1) {
            nextItemIndex = pinnedProductIndex + 1
        }
        
        let nextItemProductId = taggedProductList[nextItemIndex].childProductID ?? ""
        
        self.pinProduct(productId: nextItemProductId) { success, error in
            completion(success, error)
        }
        
    }
    
    func pinnedProductIndexInTaggedProductList(pinnedProductId: String) -> Int {
        
        for i in 0..<taggedProductList.count {
            if taggedProductList[i].childProductID == pinnedProductId {
                return i
            }
        }
        
        return 0
    }
    
    func isProductExistInTaggedProductList(productData: StreamProductModel) -> Bool {
        let index = taggedProductList.firstIndex { data in
            data.childProductID == productData.childProductID
        }
        
        return (index != nil)
    }
    
    func handleProductToRemove(_ productData: StreamProductModel){
        
        if isProductExistInTaggedProductList(productData: productData) {
            // append to remove this product
            self.addProductToRemove(productData)
        }
        
    }
    
    func addProductToRemove(_ productData: StreamProductModel) {

        let index = productsToRemove.firstIndex { data in
            data.childProductID == productData.childProductID
        }
        
        if index == nil {
            productsToRemove.append(productData)
        }
        
    }
    
    // MARK: - EXTERNAL CART FUNCTIONS
    
    func addProductToCart(productId: String?, buyNow: Bool = false, withLiveStreamOffer: Bool = true, _ completion: @escaping(Bool, String?)->Void) {
        
        guard let productId else { return }
        fetchProductDetails(productId: productId) { productData, errorString in
            if productData != nil {
                self.addProductToCart(productData: productData, buyNow: buyNow, withLiveStreamOffer: withLiveStreamOffer) { success, errorString in
                    if success {
                        completion(true, nil)
                    } else {
                        completion(false, errorString)
                    }
                }
            } else {
                completion(false, errorString)
            }
        }
        
    }
    
    func addProductToCart(productData: StreamProductModel?, buyNow: Bool = false, withLiveStreamOffer: Bool = true, _ completion: @escaping(Bool, String?)->Void) {
        
//        guard let productData, let streamInfo, let streamId = streamInfo._id else { return }
//        
//        let parentProductId = productData.parentProductID.unwrap
//        let childProductId = productData.childProductID.unwrap
//        let productName = productData.productName.unwrap
//        let unitId = productData.unitId.unwrap
//        let userType = 1
//        let storeId = productData.storeId ?? ""
//        let productAvailableQuantity = productData.availableQuantity.unwrap
//        var quantity = 1
//        var offers: [String: Any] = [:]
//        let cartType = 2
//        let storeTypeId = 8
//        var actionType: CartVM.CartActionType = .add
//        
//
//        // checking whether this product belongs to streamer, if so referralUserId will be empty string
//        var referralUserId = ""
//        let supplierStoreId = productData.storeId  ?? ""
//        if supplierStoreId == streamInfo.storeId {
//            referralUserId = ""
//        } else {
//            referralUserId = streamInfo.userDetails?.id ?? ""
//        }
//        //:
//        
//        // convert stream offer into [String: Any]
//        if withLiveStreamOffer {
//            if let offersData = productData.offers, offersData.count > 0 {
//                let offerData = try! JSONEncoder().encode(offersData.first)
//                if let offer = getOfferFromData(offerData: offerData) {
//                    offers = offer
//                }
//            }
//        } else {
//            if let offersData = productData.offer {
//                let offerData = try! JSONEncoder().encode(offersData)
//                if let offer = getOfferFromData(offerData: offerData) {
//                    offers = offer
//                }
//            }
//        }
//        
//        
//        if !buyNow {
//            if isProductExistInCart(childProductId: childProductId, parentProductId: parentProductId) {
//                // check for product quantity availability
//                let currentQuantity = getProductQuantityInCart(forProductWithId: childProductId)
//                if currentQuantity < productAvailableQuantity {
//                    quantity = currentQuantity + 1
//                } else {
//                    let error = "Total available Quantity \(productAvailableQuantity) only!"
//                    completion(false, error)
//                    return
//                }
//                actionType = .modify
//            } else {
//                actionType = .add
//            }
//        } else {
//            actionType = .add
//        }
//        
//        let cartDetails = CartVM.AddToCart(
//            productName: productName,
//            centralProductId: parentProductId,
//            productId: childProductId,
//            unitId: unitId,
//            userType: userType,
//            storeId: storeId,
//            quantity: quantity,
//            cartType: cartType,
//            offers: offers,
//            storeTypeId: storeTypeId
//        )
//        
//        cartVM.addToCart(itemDetails: cartDetails, actionType: actionType, referralUserId: referralUserId ,buyNow: buyNow,liveStreamId: streamId) { _ in
//            DispatchQueue.main.async {
//                completion(true, nil)
//            }
//        }
        
    }
    
    func isProductExistInCart(childProductId: String, parentProductId: String) -> Bool {
        
//        guard let cartProduct = CartVM.cartProducts.first(where: { ($0.product.centralProductId == parentProductId) && ($0.product._id == childProductId) }),
//            let productQuantity = cartProduct.product.quantity?.value
//        else { return false }
//        
//        return  productQuantity > 0
        
        return false
        
    }
    
    func getProductQuantityInCart(forProductWithId childProductId: String) -> Int {
//        return CartVM.cartProducts.filter{$0.product._id == childProductId}.first?.product.quantity?.value ?? 0
        return 0
    }
    
    func getCartCount() -> Int {
//        return CartVM.cartProducts.count
        return 0
    }
    
    func getOfferFromData(offerData: Data?) -> [String: Any]? {
        guard let data = offerData else{ return nil }
        do {
            // make sure this JSON is in the format we expect
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                return json
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        return nil
    }
    
    //:
    
    // MARK: - FETCH STORE AND STORE PRODUCTS
    
    func fetchAllStores(_ completion: @escaping(Bool, String?)->Void){
        
//        guard let storeId = Utility.getCurrentStoreId()
//        else { return }
        
        let storeId = ""
        
        isometrik.getIsometrik().getAllStores(storeId: storeId, isBusiness: 1) { result in
            
            guard let storeList = result.data else { return }
            self.storesList = storeList
            DispatchQueue.main.async {
                completion(true, nil)
            }
            
        } failure: { error in
            print(error)
            DispatchQueue.main.async {
                completion(false, "error string")
            }
        }
        
    }
    
    // function to get others product data
    
    func fetchStoreProducts(storeId: String?, myStore: Bool = false, _ completion: @escaping(Bool, String?)->Void){
        
        guard let storeId else { return }
        
        let page = myStore ? myStorePage : storePage

        isometrik.getIsometrik().fetchStoreProducts(storeId: storeId, page: page) { result in
            
            guard let productListData = result.data?.products,
                  let totalProducts = result.data?.totalCount
            else {
                DispatchQueue.main.async {
                    completion(false, "Not Found")
                }
                return
            }
            
            if myStore {
                
                self.totalProducts = totalProducts
                
                if self.productList.count > 0 {
                    self.productList.append(contentsOf: productListData)
                } else {
                    self.productList = productListData
                }
                
                if self.productList.count.isMultiple(of: 10) {
                    self.myStorePage += 1
                }
                
            } else {
                self.storeProductsTotalCount = totalProducts
                
                if self.storeProductList.count > 0 {
                    self.storeProductList.append(contentsOf: productListData)
                } else {
                    self.storeProductList = productListData
                }
                
                if self.storeProductList.count.isMultiple(of: 10) {
                    self.storePage += 1
                }
            }
            
            DispatchQueue.main.async {
                completion(true, nil)
            }
            
        } failure: { error in
            print(error)
            DispatchQueue.main.async {
                completion(false, "error string")
            }
        }
        
    }
    
    func updateSelectedStoreProductList(productData: StreamProductModel, _ completion: @escaping(() -> Void)){
        
        let filteredData = selectedStoreProductList.filter { data in
            data.childProductID == productData.childProductID
        }
        
        if filteredData.count > 0 {
            
            for i in 0..<selectedStoreProductList.count {
                
                guard let currentProduct = selectedStoreProductList[safe:i] else { return }
                
                if currentProduct.childProductID == productData.childProductID{
                    if productData.isSelected {
                        // replace if exist and isSelected
                        selectedStoreProductList[i] = productData
                    } else {
                        // otherwise remove from list
                        selectedStoreProductList.removeAll { product in
                            product.childProductID == productData.childProductID
                        }
                    }
                    completion()
                }
            }
            
        } else {
            selectedStoreProductList.append(productData)
            completion()
        }
        
    }
    
    func mergeOtherStoreProductAndMyStoreProduct(_ completion: @escaping(() -> Void)){
        
        for i in 0..<selectedStoreProductList.count {
            
            let productData = selectedStoreProductList[i]
            self.updateSelectedProducts(productData: productData){}
            
            if i+1 == selectedStoreProductList.count {
                completion()
            }
        }
        
    }
    
    //:
    
    func getDataCount() -> Int {
        
        if myStore {
            return productList.count
        } else {
            return storesList.count
        }
        
    }
    
    func islastCell(index: Int) -> Bool {
        if myStore {
            return index == (productList.count - 1)
        } else {
            return index == (storesList.count - 1)
        }
    }
    
    func getStoreId() -> String {
//        if let storeId = UserDefaults.standard.value(forKey: AppConstants.UserDefaults.storeId) as? String {
//            return storeId
//        }
        return ""
    }
    
    // Create new offer and tag new product to live stream
    
    func createOfferAndTagProductToLiveStream(_ completion: @escaping(Bool, String?)->Void){
        
        guard let streamInfo
        else {
            completion(false, "Something went wrong!")
            return
        }
        
        let streamId = streamInfo._id != nil ? streamInfo._id.unwrap : streamInfo.streamId.unwrap
        
        let bodyData = CreateLiveStreamOffers(
            streamId: streamId,
            products: getMyProducts(),
            otherProducts: getOtherProducts(),
            storeId: getStoreId()
        )
        
        isometrik.getIsometrik().createProductOffer(bodyData: bodyData) { result in
            
            let message = result.message.unwrap
            DispatchQueue.main.async {
                completion(true, nil)
            }
            
        } failure: { error in
            print(error)
            DispatchQueue.main.async {
                completion(false, "Error while updating offer!")
            }
        }
        
    }
    
    func removeTaggedProducts(_ completion: @escaping(Bool, String?)->Void){
        
        if productsToRemove.count == 0 {
            completion(true, nil)
            return
        }
        
        guard let streamInfo else {
            completion(false, "something went wrong!")
            return
        }
        
        var streamId = streamInfo._id.unwrap
        if streamId.isEmpty {
            streamId = streamInfo.streamId.unwrap
        }
        
        let productIds = getProductIdsToRemove()
        let bodyData = RemoveTaggedProducts(streamId: streamId, productId: productIds)
        
        isometrik.getIsometrik().removeTaggedProduct(bodyData: bodyData) { result in
            
            let status = result.status.unwrap
            let message = result.message.unwrap
            
            DispatchQueue.main.async {
                if status == "success" {
                    completion(true, nil)
                } else {
                    completion(false, message)
                }
            }
            
        } failure: { error in
            DispatchQueue.main.async {
                completion(false, "Error while removing tagged product!")
            }
        }
        
    }
    
    func getProductIdsToRemove() -> [String] {
        
        var productIds: [String] = []
        
        for i in 0..<productsToRemove.count {
            let productId = productsToRemove[i].childProductID.unwrap
            let exist = selectedProductList.firstIndex { data in
                data.childProductID == productId
            }
            
            if exist == nil {
                productIds.append(productId)
            }
        }
        
        return productIds
        
    }
    
    func getMyProducts() -> [ISMProductToBeTagged] {
        
        var products: [ISMProductToBeTagged] = []
        
        // Get selected products that are not in tagged product list and don't have same offer
        let requiredProducts = self.getProductsThatAreNotTagged(checkOffers: true)
        
        
        for requiredProduct in requiredProducts {
            
            // Only return the product from my store
            if requiredProduct.storeId != nil && requiredProduct.storeId == self.getStoreId() {
                let productId = requiredProduct.childProductID ?? ""
                let categoryId = requiredProduct.categoryJson?.first?.categoryId ?? ""
                let discountedPercentage = requiredProduct.liveStreamfinalPriceList?.discountPercentage ?? 0
                let brandId = requiredProduct.brandId ?? ""
                
                let product = ISMProductToBeTagged(id:productId, discount: discountedPercentage, parentCategoryId: categoryId, brandId: brandId)
                products.append(product)
            } else {
                break
            }
            
        }
        
        return products
        
    }
    
    func getOtherProducts() -> [ISMOthersProductToBeTagged] {
        
        var otherProducts: [ISMOthersProductToBeTagged] = []
        
        // Get selected products that are not in tagged product list
        let requiredProducts = self.getProductsThatAreNotTagged()
        
        for requiredProduct in requiredProducts {
            
            let storeId = requiredProduct.storeId ?? ""
            
            // Only product which are not mine
            if storeId != self.getStoreId() && !storeId.isEmpty {
                
                // check whether products for this store already added in the othersProduct array or not
                let productForCurrentStore = otherProducts.filter { store in
                    return store.storeId == storeId
                }
                
                // if so return
                if productForCurrentStore.count > 0 {
                    break
                }
                
                var products: [ISMProductToBeTagged] = []
                
                // filter the products with the storeId
                let filteredProduct = requiredProducts.filter { product in
                    if let productStoreId = product.storeId {
                        return productStoreId == storeId
                    } else {
                        return false
                    }
                }
                
                for productData in filteredProduct {
                    let productId = productData.childProductID ?? ""
                    let categoryId = productData.categoryJson?.first?.categoryId ?? ""
                    let discountedPercentage = productData.liveStreamfinalPriceList?.discountPercentage ?? 0
                    let brandId = productData.brandId ?? ""
                    
                    let product = ISMProductToBeTagged(id:productId, discount: discountedPercentage, parentCategoryId: categoryId, brandId: brandId)
                    products.append(product)
                }
                
                let otherProduct = ISMOthersProductToBeTagged(storeId: storeId, products: products)
                otherProducts.append(otherProduct)
                
            }
        }
        
        return otherProducts
        
    }
    
    func getProductsThatAreNotTagged(checkOffers: Bool = false) -> [StreamProductModel] {
        // if product exist with the same discount in the tag product list remove the products
        if self.taggedProductList.isEmpty { return [] }
        
        var requiredProducts: [StreamProductModel] = []
        
        for i in 0..<self.selectedProductList.count {
            
            let selectedProduct = self.selectedProductList[i]
            
            let containsSelectedProduct = self.taggedProductList.contains { taggedProduct in
                
                // Check for offer
                if checkOffers {
                    return (
                        selectedProduct.childProductID == taggedProduct.childProductID &&
                        selectedProduct.liveStreamfinalPriceList?.discountPercentage == taggedProduct.liveStreamfinalPriceList?.discountPercentage
                    )
                } else {
                    return ( selectedProduct.childProductID == taggedProduct.childProductID )
                }
                
            }
            
            if !containsSelectedProduct {
                requiredProducts.append(selectedProduct)
            }
            
        }
        
        return requiredProducts
        
    }
    
    func isStreamScheduled() -> Bool {
        
        guard let streamInfo else { return false }
        let streamStatus = LiveStreamStatus(rawValue: streamInfo.status ?? "")
        
        if streamStatus == .scheduled {
            return true
        }
        return false
        
    }
    
}
