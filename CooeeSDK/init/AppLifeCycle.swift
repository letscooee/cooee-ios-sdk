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
        devicePropertyCollector = DevicePropertyCollector()
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

        var event = Event(eventName: Constants.EVENT_APP_BACKGROUND, properties: sessionProperties)
        event.deviceProps = self.devicePropertyCollector.getMutableDeviceProps()
        
        CooeeFactory.shared.safeHttpService.sendEvent(event: event)
    }

    @objc func appMovedToLaunch() {
        runtimeData.setInForeground()
        runtimeData.setLaunchType(launchType: .ORGANIC)
        DispatchQueue.main.async {
            NewSessionExecutor().execute()
        }
    }

    @objc func appMovedToForeground() {
        let willCreateNewSession = sessionManager.checkSessionValidity()
        let isNewSession = willCreateNewSession || runtimeData.isFirstForeground();
        DispatchQueue.main.async {
            if isNewSession && self.runtimeData.getLaunchType() == .ORGANIC {
                do {
                    try EngagementTriggerHelper().performOrganicLaunch()
                } catch {
                    NSLog("Error: \(error.localizedDescription)")
                }
            }

            self.sessionManager.keepSessionAlive()

            if self.runtimeData.isFirstForeground() {
                return
            }

            self.runtimeData.setInForeground()

            let backgroundDuration = self.runtimeData.getTimeInBackgroundInSeconds()

            var eventProps = [String: Any]()
            eventProps["iaDur"] = backgroundDuration
            var event = Event(eventName: Constants.EVENT_APP_FOREGROUND, properties: eventProps)
            event.deviceProps = self.devicePropertyCollector.getMutableDeviceProps()

            CooeeFactory.shared.safeHttpService.sendEvent(event: event)
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
    private let devicePropertyCollector: DevicePropertyCollector
}
