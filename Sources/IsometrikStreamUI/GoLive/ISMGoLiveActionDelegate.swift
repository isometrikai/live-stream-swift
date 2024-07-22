
import UIKit

public protocol ISMGoLiveActionDelegate {
    func didAddProductTapped(selectedProductsIds: [String]?, productIds: @escaping ([String]?)->Void, root: UINavigationController)
    func didStreamStoreOptionTapped(forUserType: StreamUserType, root: UINavigationController)
}
