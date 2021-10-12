//
//  CooeeBootstarp.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 01/10/21.
//

import Foundation
import FirebaseCore
import FirebaseMessaging

/**
 A one time initializer class which initialises the Cooee SDK. This is used internally by the SDK
 and should be quick.
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class CooeeBootstrap {
    public init() {
        _ = CooeeFactory.shared
        _ = AppLifeCycle.shared
        registerFirebase()
        updateFirebaseToken()
        startPendingTaskJob()
    }

    private func startPendingTaskJob() {
        CooeeJobUtils.schedulePendingTaskJob()
    }

    private func registerFirebase() {
        FirebaseApp.configure()
        let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()
    }

    private func updateFirebaseToken() {
        Messaging.messaging().token { (token, _) in
            BaseHTTPService.shared.sendFirebaseToken(token: token)
        }
    }
}
