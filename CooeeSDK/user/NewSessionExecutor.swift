//
//  NewSessionExecutor.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 05/10/21.
//

import Foundation

/**
 PostLaunchActivity initialized when app is launched

 - Author: Ashish Gaikwad
 - Since: 0.1.0
   */
class NewSessionExecutor {
    // MARK: Lifecycle

    // private let SafeHTTPService safeHTTPService

    init() {
        devicePropertyCollector = DevicePropertyCollector()
        appInfo = CooeeFactory.shared.appInfo
        sessionManager = CooeeFactory.shared.sessionManager
    }

    // MARK: Public

    public func execute() {
        if isAppFirstTimeLaunch() {
            sendFirstLaunchEvent()
        } else {
            sendSuccessiveLaunchEvent()
        }
    }

    // MARK: Private

    private let devicePropertyCollector: DevicePropertyCollector
    private let appInfo: AppInfo
    private let sessionManager: SessionManager

    /**
      Check if app is launched for first time

     - Returns: true if app is launched for first time, else false
     */
    private func isAppFirstTimeLaunch() -> Bool {
        if LocalStorageHelper.getBoolean(key: Constants.STORAGE_FIRST_TIME_LAUNCH, defaultValue: true) ?? true {
            LocalStorageHelper.putBoolean(key: Constants.STORAGE_FIRST_TIME_LAUNCH, value: false)
            return true
        } else {
            return false
        }
    }

    /**
     * Runs every time when app is opened for a new session
     */

    private func sendSuccessiveLaunchEvent() {
        let mutableDeviceProperty = devicePropertyCollector.getMutableDeviceProps()
        let event = Event(eventName: "CE App Launched", deviceProps: mutableDeviceProperty)
        CooeeFactory.shared.safeHttpService.sendEvent(event: event)
    }

    /**
     * Runs when app is opened for the first time after sdkToken is received from server asynchronously
     */
    private func sendFirstLaunchEvent() {
        let event = Event(eventName: "CE App Installed", deviceProps: devicePropertyCollector.getMutableDeviceProps())
        CooeeFactory.shared.safeHttpService.sendEvent(event: event)
    }
}
