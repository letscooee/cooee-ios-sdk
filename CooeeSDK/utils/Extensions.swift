//
// Created by Ashish Gaikwad on 22/10/21.
//

import Foundation
import UIKit

/**
 Extensions for all class

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
extension UIColor {

    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

public extension CGFloat {
    /**
     Converts pixels to points based on the screen scale. For example, if you
     call CGFloat(1).pixelsToPoints() on an @2x device, this method will return
     0.5.

     - parameter pixels: to be converted into points

     - returns: a points representation of the pixels
     */
    func pixelsToPoints() -> CGFloat {
        return self / UIScreen.main.scale
    }

    /**
     Returns the number of points needed to make a 1 pixel line, based on the
     scale of the device's screen.

     - returns: the number of points needed to make a 1 pixel line
     */
    static func onePixelInPoints() -> CGFloat {
        return CGFloat(1).pixelsToPoints()
    }
}

extension UIApplication {

    /**
     Fetch root ViewController and find top most running UIViewController in it

     - Returns: top most UIViewController
     */
    func topMostViewController() -> UIViewController? {
        return UIApplication.shared.windows.filter {
            $0.isKeyWindow
        }.first?.rootViewController?.topMostViewController()
    }
}

extension UIViewController {

    /**
     Find top most running UIViewController in root view controller

     - Returns: UIViewController
     */
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