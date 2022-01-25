//
//  CooeeBootstrap.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 01/10/21.
//
import Foundation

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
        _ = AppLifeCycle.shared
        DispatchQueue.main.async {
            _ = CooeeFactory.shared
            self.startPendingTaskJob()
            FontProcessor.checkAndUpdateBrandFonts()
        }
        // ARHelper.initAndShowUnity()
    }

    // MARK: Internal

    func notificationClicked(_ triggerData: TriggerData) {
        CooeeNotificationService.sendEvent("CE Notification Clicked", withTriggerData: triggerData)

        guard let notificationClickAction = triggerData.getPushNotification()?.getClickAction() else {
            self.launchInApp(with: triggerData)
            return
        }

        guard  let launchType = notificationClickAction.open else {
            self.launchInApp(with: triggerData)
            return
        }

        if launchType == 1 {
            self.launchInApp(with: triggerData)
        } else if launchType == 2 {
            // Launch Self AR
            //EngagementTriggerHelper.renderInAppFromPushNotification(for: triggerData)
        } else if launchType == 3 {
            // Launch Native AR
        }

    }

    // MARK: Private

    private func launchInApp(with triggerData: TriggerData) {
        EngagementTriggerHelper.renderInAppFromPushNotification(for: triggerData)
    }

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

    private func registerForPushNotification() {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in
                    self.registerCategory()
                }
                
        )

        UIApplication.shared.registerForRemoteNotifications()
    }
    
    private func registerCategory() -> Void{

        let category : UNNotificationCategory = UNNotificationCategory.init(identifier: "COOEENOTIFICATION", actions: [], intentIdentifiers: [], options: [])

        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([category])

    }
}

extension CooeeBootstrap {
    @objc
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        _ = CooeeNotificationService(userInfo: userInfo)
        completionHandler(.newData)
    }
}

extension CooeeBootstrap: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([[.badge, .sound, .alert]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let rawTriggerData = userInfo["triggerData"]

        if rawTriggerData == nil {
            return
        }

        let triggerData = TriggerData.deserialize(from: "\(rawTriggerData!)")

        if triggerData == nil {
            return
        }

        switch response.actionIdentifier {
            case UNNotificationDismissActionIdentifier:
                CooeeNotificationService.sendEvent("CE Notification Cancelled", withTriggerData: triggerData!)
                break
            case UNNotificationDefaultActionIdentifier:
                self.notificationClicked(triggerData!)
                break
            default:
                // Handle other actions
                break
        }


        completionHandler()
    }
}
