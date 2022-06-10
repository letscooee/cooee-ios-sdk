//
//  CooeeBootstrap.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 01/10/21.
//

import Foundation
import UIKit

/**
 A one time initializer class which initialises the Cooee SDK. This is used internally by the SDK
 and should be quick.
 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
class CooeeBootstrap: NSObject {
    // MARK: Lifecycle

    override public init() {
        super.init()
        swizzleDidReceiveRemoteNotification()
        _ = AppLifeCycle.shared
        DispatchQueue.main.async {
            _ = CooeeFactory.shared
            self.startPendingTaskJob()
            FontProcessor.checkAndUpdateBrandFonts()
            self.registerCategory()
        }
        // ARHelper.initAndShowUnity()
    }

    // MARK: Private

    /**
     Registers custom didReceiveRemoteNotification on current appDelegate
     */
    private func swizzleDidReceiveRemoteNotification() {
        let appDelegate = UIApplication.shared.delegate
        let appDelegateClass: AnyClass? = object_getClass(appDelegate)

        let originalSelector = #selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:))
        let swizzledSelector = #selector(CooeeBootstrap.application(_:didReceiveRemoteNotification:fetchCompletionHandler:))

        guard let swizzledMethod = class_getInstanceMethod(CooeeBootstrap.self, swizzledSelector) else {
            return
        }

        if let originalMethod = class_getInstanceMethod(appDelegateClass, originalSelector) {
            // exchange implementation
            method_exchangeImplementations(originalMethod, swizzledMethod)
        } else {
            // add implementation
            class_addMethod(appDelegateClass, swizzledSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        }
    }

    private func startPendingTaskJob() {
        CooeeJobUtils.schedulePendingTaskJob()
    }

    private func registerCategory() {
        let category = UNNotificationCategory(identifier: "CooeeNotification", actions: [], intentIdentifiers: [], options: .customDismissAction)

        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([category])
    }
}

extension CooeeBootstrap {
    @objc
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let rawTriggerData = userInfo["triggerData"] else {
            NSLog("No Trigger Data found in notification")
            completionHandler(.noData)
            return
        }

        guard let notificationID = LocalStorageHelper.getString(key: Constants.STORAGE_NOTIFICATION_ID) else {
            NSLog("No NotificationID found in storage")
            completionHandler(.noData)
            return
        }

        guard let triggerData = TriggerData.deserialize(from: "\(rawTriggerData)") else {
            NSLog("Fail to deserialize triggerData")
            return
        }
        CacheTriggerContent().loadAndSaveTriggerData(triggerData, forNotification: notificationID)
        completionHandler(.noData)
    }
}
