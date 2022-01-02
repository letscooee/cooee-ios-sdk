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
        sendDefaultUserProperties(userProperties: nil)

        let event = Event(eventName: "CE App Launched", properties: devicePropertyCollector.getCommonEventProperties())
        CooeeFactory.shared.safeHttpService.sendEvent(event: event)
    }

    /**
     * Runs when app is opened for the first time after sdkToken is received from server asynchronously
     */
    private func sendFirstLaunchEvent() {
        var userProperties = [String: Any]()
        userProperties["CE First Launch Time"] = DateUtils.formatDateToUTCString(date: Date())
        userProperties["CE Installed Time"] = devicePropertyCollector.getAppInstallDate()
        sendDefaultUserProperties(userProperties: userProperties)

        let event = Event(eventName: "CE App Installed", properties: devicePropertyCollector.getCommonEventProperties())
        CooeeFactory.shared.safeHttpService.sendEvent(event: event)
    }

    private func sendDefaultUserProperties(userProperties: [String: Any]?) {
        var dictionary = devicePropertyCollector.getDefaultValues()
        if userProperties != nil {
            dictionary.merge(userProperties!) { _, new in
                new
            }
        }

        dictionary["CE Session Count"] = sessionManager.getCurrentSessionNumber()
        dictionary["CE Last Launch Time"] = DateUtils.formatDateToUTCString(date: Date())

        CooeeFactory.shared.safeHttpService.updateUserPropertyOnly(userProperty: dictionary)
    }
}