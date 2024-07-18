
import UIKit

public protocol GoLiveActionDelegate {
    func didAddProductTapped(selectedProductsIds: [String]?, productIds: @escaping ([String]?)->Void, root: UINavigationController)
}
