//
//  CooeeBootstrap.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 01/10/21.
//

import FirebaseCore
import FirebaseMessaging
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
        self.swizzleDidReceiveRemoteNotification()
        _ = CooeeFactory.shared
        _ = AppLifeCycle.shared

        DispatchQueue.main.async {
            self.registerFirebase()
            self.updateFirebaseToken()
            self.startPendingTaskJob()
            FontProcessor.checkAndUpdateBrandFonts()
        }
    }

    // MARK: Internal

    func notificationClicked(_ triggerData: TriggerData) {
        NotificationService.sendEvent("CE Notification Clicked", withTriggerData: triggerData)

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

    private func registerFirebase() {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in })

        Messaging.messaging().delegate = self
        UIApplication.shared.registerForRemoteNotifications()
    }

    private func updateFirebaseToken() {
        Messaging.messaging().token { token, _ in
            var requestBody = [String: Any]()
            requestBody["firebaseToken"] = token
            CooeeFactory.shared.safeHttpService.updatePushToken(requestData: requestBody)
        }
    }
}

extension CooeeBootstrap: MessagingDelegate {
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        var requestBody = [String: Any]()
        requestBody["firebaseToken"] = fcmToken
        CooeeFactory.shared.safeHttpService.updatePushToken(requestData: requestBody)
    }
}

extension CooeeBootstrap {
    @objc
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        _ = NotificationService(userInfo: userInfo)
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
                NotificationService.sendEvent("CE Notification Cancelled", withTriggerData: triggerData!)
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