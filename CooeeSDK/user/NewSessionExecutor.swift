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
@objc
public class NewSessionExecutor: NSObject {
    // MARK: Lifecycle

    // private let SafeHTTPService safeHTTPService

    override init() {
        devicePropertyCollector = DevicePropertyCollector()
        appInfo = CooeeFactory.shared.appInfo
        sessionManager = CooeeFactory.shared.sessionManager
    }

    // MARK: Public

    /**
     Use to set wrapper name. Can use only in Flutter/Cordova/React-Native to keep track of wrappers.

     - Parameters:
       - wrapperType: Type of wrapper
       - versionNumber:  Version number of wrapper
       - versionCode:  Version code of wrapper
     */
    @objc
    public static func updateWrapperInformation(wrapperType: WrapperType, versionNumber: String, versionCode: Int) {
        if versionCode == 0 {
            return
        }

        wrapper = WrapperDetails(wrapperName: wrapperType.name(), versionNumber: versionNumber, versionCode: versionCode)
    }

    // MARK: Internal

    func execute() {
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
    private static var wrapper: WrapperDetails?

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

        sendDefaultDeviceProperties(deviceMutableProperties: mutableDeviceProperty)
    }

    /**
     * Runs when app is opened for the first time after sdkToken is received from server asynchronously
     */
    private func sendFirstLaunchEvent() {
        let event = Event(eventName: "CE App Installed", deviceProps: devicePropertyCollector.getMutableDeviceProps())
        CooeeFactory.shared.safeHttpService.sendEvent(event: event)

        var firstLaunchProps = [String: Any]()
        firstLaunchProps["firstLaunch"] = DateUtils.formatDateToUTCString(date: Date())
        firstLaunchProps["installedTime"] = devicePropertyCollector.getAppInstallDate()
        sendDefaultDeviceProperties(deviceMutableProperties: firstLaunchProps)
    }

    private func sendDefaultDeviceProperties(deviceMutableProperties: [String: Any]?) {
        var deviceProperties = devicePropertyCollector.getImmutableDeviceProps()
        if deviceMutableProperties != nil {
            deviceProperties.merge(deviceMutableProperties!) { _, new in
                new
            }
        }

        let props = DeviceDetails()
        props.props = deviceProperties

        if let wrapper = NewSessionExecutor.wrapper {
            props.wrp = wrapper
        }

        CooeeFactory.shared.safeHttpService.updateDeviceProperty(deviceProp: props)
    }
}
