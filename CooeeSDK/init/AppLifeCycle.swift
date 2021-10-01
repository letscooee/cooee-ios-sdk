//
//  AppLifeCycle.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 01/10/21.
//

import Foundation
import UIKit
class AppLifeCycle: NSObject {
    // MARK: Lifecycle

    override init() {
        super.init()
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToLaunch), name: UIApplication.didFinishLaunchingNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToForground), name: UIApplication.willEnterForegroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToKill), name: UIApplication.willTerminateNotification, object: nil)
    }

    // MARK: Internal

    static let shared = AppLifeCycle()

    let notificationCenter = NotificationCenter.default

    @objc func appMovedToBackground() {
        print("************** Background")
    }

    @objc func appMovedToLaunch() {
        print("************** Launch \(currentTimeInMilliSeconds())")
    }

    @objc func appMovedToForground() {
        print("************** Forground \(currentTimeInMilliSeconds())")
    }

    @objc func appMovedToKill() {
        print("************** Kill")
    }

    func currentTimeInMilliSeconds() -> Int {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
}
