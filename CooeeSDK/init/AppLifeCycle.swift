//
//  AppLifeCycle.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 01/10/21.
//

import Foundation
import UIKit

/**
  Register callbacks of different lifecycle of all the activities.

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class AppLifeCycle: NSObject {
    // MARK: Lifecycle

    override init() {
        runtimeData = RuntimeData.shared
        sessionManager = SessionManager.shared
        super.init()
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToLaunch), name: UIApplication.didFinishLaunchingNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToKill), name: UIApplication.willTerminateNotification, object: nil)
    }

    // MARK: Internal

    static let shared = AppLifeCycle()

    @objc func appMovedToBackground() {
        runtimeData.setInBackground()

        // stop sending check message of session alive on app background
        sessionManager.stopSessionAlive()

        let duration = runtimeData.getTimeInForegroundInSeconds()

        var sessionProperties = [String: Any]()
        sessionProperties["aDur"] = duration

        let session = Event(eventName: "CE App Background", properties: sessionProperties)
        CooeeFactory.shared.safeHttpService.sendEvent(event: session)

        CooeeNotificationService.processPendingNotification()
    }

    @objc func appMovedToLaunch() {
        runtimeData.setInForeground()
        runtimeData.setLaunchType(launchType: .ORGANIC)
        _ = sessionManager.checkSessionValidity()
        DispatchQueue.main.async {
            NewSessionExecutor().execute()
        }
    }

    @objc func appMovedToForeground() {
        let willCreateNewSession = sessionManager.checkSessionValidity()
        let isNewSession = willCreateNewSession || runtimeData.isFirstForeground();
        DispatchQueue.main.async {
            if isNewSession && self.runtimeData.getLaunchType() == .ORGANIC {
                EngagementTriggerHelper().performOrganicLaunch()
            }

            self.sessionManager.keepSessionAlive()

            if self.runtimeData.isFirstForeground() {
                return
            }

            self.runtimeData.setInForeground()

            let backgroundDuration = self.runtimeData.getTimeInBackgroundInSeconds()

            var eventProps = [String: Any]()
            eventProps["iaDur"] = backgroundDuration
            let session = Event(eventName: "CE App Foreground", properties: eventProps)

            CooeeFactory.shared.safeHttpService.sendEvent(event: session)
        }
    }

    @objc func appMovedToKill() {
        // Stop Pending task job once app get killed
        CooeeJobUtils.timer?.invalidate()
    }

    func currentTimeInMilliSeconds() -> Int {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970 * 1000)
    }

    // MARK: Private

    private var runtimeData: RuntimeData
    private let notificationCenter = NotificationCenter.default
    private let sessionManager: SessionManager
}
