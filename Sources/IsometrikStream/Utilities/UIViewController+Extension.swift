import UIKit

extension UIViewController {
    
    // Helper function to get the top-most view controller
    public func topMostViewController() -> UIViewController {
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController()
        } else if let navigationController = self as? UINavigationController, let visibleViewController = navigationController.visibleViewController {
            return visibleViewController.topMostViewController()
        } else if let tabBarController = self as? UITabBarController, let selectedViewController = tabBarController.selectedViewController {
            return selectedViewController.topMostViewController()
        } else {
            return self
        }
    }
    
}
