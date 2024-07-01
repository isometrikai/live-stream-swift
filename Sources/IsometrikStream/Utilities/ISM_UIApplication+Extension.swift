//
//  ISM_UIApplication+Extension.swift
//  Yelo
//
//  Created by Nikunj M1 on 20/09/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

extension UIApplication {
    
    ///It returns top most view controller
    class func ISM_GetTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return ISM_GetTopMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return ISM_GetTopMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return ISM_GetTopMostViewController(base: presented)
        }
        return base
    }
    
    ///It returns top most view controller
    class func ISM_GetTopMostViewControllerByWindow(base: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return ISM_GetTopMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return ISM_GetTopMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return ISM_GetTopMostViewController(base: presented)
        }
        return base
    }
}
