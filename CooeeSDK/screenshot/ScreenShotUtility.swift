//
//  ScreenShotUtility.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 22/12/21.
//

import Foundation
import UIKit

/**
 Generate the screenshot of the currently viewing ViewController and sends to server
 
 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
class ScreenShotUtility {
    // MARK: Internal

    /**
     Generates and send screenshot to server
     */
    static func captureAndSendScreenShot() {
        let isAppInDebugMode = CooeeFactory.shared.appInfo.isAppDebugging()

        if !isAppInDebugMode {
            NSLog("Skipping screenshot send as App is not in debug mode")
            return
        }

        let screenShot = UIApplication.shared.makeSnapshot()
        var screenName: String = "HomeScreen"
        if let visibleController = UIApplication.shared.topMostViewController() {
            screenName = "\(visibleController.className)"
        }

        if screenShot == nil {
            return
        }

        if !isTimeToSendScreenshot(for: screenName) {
            NSLog("Skipping screenshot send as its before \(Constants.SCREENSHOT_SEND_INTERVAL_HOURS) hours")
            return
        }

        do {
            let response = try CooeeFactory.shared.baseHttpService.uploadScreenshot(imageToUpload: screenShot!, screenName: screenName)

            if response != nil && response!["saved"] != nil && response!["saved"] as! Bool {
                updateLastSentTime(for: screenName)
            }
        } catch {
            CooeeFactory.shared.sentryHelper.capture(error: error as NSError)
        }
    }

    // MARK: Private

    /**
     Update Constants.STORAGE_SCREENSHOT_SYNC_TIME data once screenshot save got success for screen

     - Parameter screenName: screen name
     */
    private static func updateLastSentTime(for screenName: String) {
        var sentTime = LocalStorageHelper.getDictionary(Constants.STORAGE_SCREENSHOT_SYNC_TIME, defaultValue: nil)

        if sentTime == nil {
            sentTime = [String: Any]()
        }

        sentTime!.updateValue(Date().timeIntervalSince1970, forKey: screenName)

        LocalStorageHelper.putDictionary(sentTime!, for: Constants.STORAGE_SCREENSHOT_SYNC_TIME)
    }

    /**
     Checks if its correct time for sending screenshot of given <code>screenName</code>

     - Parameter screenName: name of screen for which want to check timer
     - Returns: true if current time passes Constants.SCREENSHOT_SEND_INTERVAL_HOURS from last attempt; otherwise, false
     */
    private static func isTimeToSendScreenshot(for screenName: String) -> Bool {
        let sentTime = LocalStorageHelper.getDictionary(Constants.STORAGE_SCREENSHOT_SYNC_TIME, defaultValue: nil)

        if sentTime == nil {
            return true
        }

        let lastTime = sentTime![screenName]

        if lastTime == nil {
            return true
        }

        let lastTimeInDate = Date(timeIntervalSince1970: lastTime as! Double)
        let timeAfterInterval = Calendar.current.date(bySetting: .hour, value: Constants.SCREENSHOT_SEND_INTERVAL_HOURS, of: lastTimeInDate)

        if timeAfterInterval == nil || timeAfterInterval! < Date() {
            return true
        }

        return false
    }
}

extension UIApplication {
    func getKeyWindow() -> UIWindow? {
        if #available(iOS 13, *) {
            return windows.first {
                $0.isKeyWindow
            }
        } else {
            return keyWindow
        }
    }

    func makeSnapshot() -> UIImage? {
        return getKeyWindow()?.layer.makeSnapshot()
    }
}

extension UIViewController {
    var className: String {
        NSStringFromClass(classForCoder).components(separatedBy: ".").last!
    }
}

extension CALayer {
    func makeSnapshot() -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        render(in: context)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        return screenshot
    }
}

extension UIView {
    func makeSnapshot() -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: frame.size)
            return renderer.image { _ in
                drawHierarchy(in: bounds, afterScreenUpdates: true)
            }
        } else {
            return layer.makeSnapshot()
        }
    }
}

extension UIImage {
    convenience init?(snapshotOf view: UIView) {
        guard let image = view.makeSnapshot(), let cgImage = image.cgImage else {
            return nil
        }
        self.init(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }
}
