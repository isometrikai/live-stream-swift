
import UIKit
import IsometrikStream

public protocol ISMGoLiveActionDelegate {
    
    func didAddProductTapped(selectedProductsIds: [String]?, productIds: @escaping ([String]?)->Void, root: UINavigationController)
    
    func didStreamStoreOptionTapped(forUserType: StreamUserType, root: UINavigationController)
    func didShareStreamTapped(streamData: SharedStreamData, root: UINavigationController)
}
