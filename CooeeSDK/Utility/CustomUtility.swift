//
//  CustomUtility.swift
//  CooeeSDK
//
//  Created by Surbhi Lath on 21/04/21.
//

import UIKit

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController?.topMostViewController()
    }
}

extension UIViewController {
    func topMostViewController() -> UIViewController? {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? nil
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}

