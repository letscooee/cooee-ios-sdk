//
//  CooeeBootstarp.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 01/10/21.
//

import Foundation
import FirebaseCore
import FirebaseMessaging

class CooeeBootstrap {
    public init() {
        _ = CooeeFactory.shared
        _ = AppLifeCycle.shared
       // registerFirebase()
    }

    private func registerFirebase() {
        FirebaseApp.configure()
        let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()
    }
}
