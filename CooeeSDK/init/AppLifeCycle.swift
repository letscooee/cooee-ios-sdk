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
        timer?.invalidate()

        let duration = runtimeData.getTimeInForegroundInSeconds()

        var sessionProperties = [String: Any]()
        sessionProperties["aDur"] = duration

        let session = Event(eventName: "CE App Background", properties: sessionProperties)
        CooeeFactory.shared.safeHttpService.sendEvent(event: session)

        CooeeNotificationService.processPendingNotification()
    }

    @objc func appMovedToLaunch() {
        runtimeData.setInForeground()
        DispatchQueue.main.async {
            NewSessionExecutor().execute()
        }

    }

    @objc func appMovedToForeground() {
        DispatchQueue.main.async {
            self.keepSessionAlive()

            if self.runtimeData.isFirstForeground() {
                return
            }

            self.runtimeData.setInForeground()

            let backgroundDuration = self.runtimeData.getTimeInBackgroundInSeconds()

            if backgroundDuration > Constants.IDLE_TIME_IN_SECONDS {
                self.sessionManager.conclude()

                NewSessionExecutor().execute()
                NSLog("After 30 min of App Background " + "Session Concluded")
            } else {
                var eventProps = [String: Any]()
                eventProps["iaDur"] = backgroundDuration
                let session = Event(eventName: "CE App Foreground", properties: eventProps)

                CooeeFactory.shared.safeHttpService.sendEvent(event: session)
            }
        }
    }

    @objc func appMovedToKill() {
        // Stop Pending task job once app get killed
        CooeeJobUtils.timer?.invalidate()
        sessionManager.conclude()
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
    private var timer: Timer?

    /**
     * Send server check message every 5 min that session is still alive
     */
    private func keepSessionAlive() {
        // send server check message every 5 min that session is still alive
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(Constants.KEEP_ALIVE_TIME_IN_MS), target: self,
                selector: #selector(keepAlive), userInfo: nil, repeats: true)
    }

    @objc private func keepAlive() {
        sessionManager.pingServerToKeepAlive()
    }
}
