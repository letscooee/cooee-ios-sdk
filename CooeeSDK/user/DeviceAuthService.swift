//
//  UserAuthService.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 20/09/21.
//

import Foundation

/**
 Utility class to register user with server and to provide related data

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
class DeviceAuthService {
    // MARK: Lifecycle

    init(_ helper: SentryHelper) {
        self.baseHttp = BaseHTTPService.shared
        self.sentryHelper = helper
    }

    // MARK: Internal

    let lock = NSRecursiveLock()

    /**
     * Method will ensure that the SDK has acquired the token. If on the first time, token can't be pulled
     * from the server, calling this method will reattempt the same maximum within 1 minute.
     */
    func acquireSDKToken() {
        self.lock.lock()
        if self.hasToken() {
            NSLog("Already has SDK token")
            self.populateUserDataFromStorage()
            return
        }

        NSLog("Attempt to acquire SDK token")

        self.getSDKTokenFromServer()
        self.lock.unlock()
    }

    func hasToken() -> Bool {
        let sdkToken = LocalStorageHelper.getString(key: Constants.STORAGE_SDK_TOKEN)
        return !(sdkToken?.isEmpty ?? true)
    }

    func updateAPI() {
        if SDKInfo.shared.cachedInfo.isDebugging {
            NSLog("SDK Token - \(self.sdkToken ?? "")")
            NSLog("User ID - \(self.userID ?? "")")
        }

        self.baseHttp?.commonHeaders.sdkToken = self.sdkToken
        self.baseHttp?.commonHeaders.userID = self.userID
        self.sentryHelper.setUserId(id: self.userID!)

        /*
        Send screenshot once sdk token is acquired/published
        Stopping service as server not accepting screenshot request
        if !(self.sdkToken?.isEmpty ?? true) {
            DispatchQueue.main.async {
                ScreenShotUtility.captureAndSendScreenShot()
            }
        }*/
    }

    func getUserID() -> String? {
        self.userID
    }

    /**
     Update auth details if its available.
     This is mainly used while profile merging.

     - Parameter response: response from server
     */
    func checkAndUpdate(_ response: [String: Any]?) {
        guard let deviceAuthResponse = DeviceAuthResponse.deserialize(from: response) else {
            return
        }

        // If sdkToken is present then replace it immediatly
        if let sdkToken = deviceAuthResponse.sdkToken, !sdkToken.isEmpty {
            self.setSDKToken(sdkToken: sdkToken)
        }

        // If userID is present then replace it immediatly
        if let userID = deviceAuthResponse.userID, !userID.isEmpty {
            self.setUserID(userID: userID)
        }

        // If deviceID is present then replace it immediatly
        if let deviceID = deviceAuthResponse.deviceID, deviceID.isEmpty {
            self.setDeviceID(deviceID: deviceID)
        }

        // Send to update the local storage & api client
        self.updateAPI()
    }

    // MARK: Private

    private let baseHttp: BaseHTTPService?
    private let sentryHelper: SentryHelper

    private var userID: String?
    private var deviceID: String?
    private var sdkToken: String?
    private var uuID: String?

    /**
     Populates value to the ``deviceID`` and LocalStorage immediately.
     - Parameter deviceID: deviceID to be setÏ
     */
    private func setDeviceID(deviceID: String) {
        self.deviceID = deviceID
        LocalStorageHelper.putString(key: Constants.STORAGE_DEVICE_ID, value: deviceID)
    }

    /**
     Populates value to the ``userID`` and LocalStorage immediately.
     - Parameter userID: userID to be set
     */
    private func setUserID(userID: String) {
        self.userID = userID
        LocalStorageHelper.putString(key: Constants.STORAGE_USER_ID, value: userID)
    }

    /**
     Populates value to the ``sdkToken`` and LocalStorage immediately.
     - Parameter sdkToken: sdkToken to be set
     */
    private func setSDKToken(sdkToken: String) {
        self.sdkToken = sdkToken
        LocalStorageHelper.putString(key: Constants.STORAGE_SDK_TOKEN, value: sdkToken)
    }

    /**
     * This method will pull user data (like SDK token & user ID) from the local storage (shared preference)
     * and populates it for further use.
     */
    private func populateUserDataFromStorage() {
        self.sdkToken = LocalStorageHelper.getString(key: Constants.STORAGE_SDK_TOKEN)
        self.userID = LocalStorageHelper.getString(key: Constants.STORAGE_USER_ID)
        self.deviceID = LocalStorageHelper.getString(key: Constants.STORAGE_DEVICE_ID)

        if self.sdkToken?.isEmpty ?? true {
            NSLog("No SDK token found in preference")
        }

        if self.userID?.isEmpty ?? true {
            NSLog("No user ID found in preference")
        }

        self.updateAPI()
    }

    /**
     * Make user registration with server (if not already) and acquire a SDK token which will be later used to authenticate
     * other endpoints.
     */
    private func getSDKTokenFromServer() {
        self.uuID = ObjectID().hexString
        let appInfo = InfoPlistReader.shared
        let props = DevicePropertyCollector().getImmutableDeviceProps()

        if appInfo.appID.isEmpty {
            NSLog("Missing App credentials in Info.plist. Check Integration https://docs.letscooee.com/developers/ios/quickstart")
            return
        }

        let authBody = DeviceAuthenticationBody(appID: appInfo.appID, uuid: self.uuID!, props: props)
        self.baseHttp?.registerDevice(body: authBody) {
            result, error in
            if let result = result {
                self.saveUserDataInStorage(data: result)
                CooeeJobUtils.triggerPendingTaskJobImmediately()
            } else {
                self.sentryHelper.capture(message: "Unable to acquire token- \(error.debugDescription)")
            }
        }
    }

    /**
     Save user data in local storage (shared preference)
     - Parameter data: data to be saved
     */
    private func saveUserDataInStorage(data: DeviceAuthResponse) {
        self.setSDKToken(sdkToken: data.sdkToken!)
        self.setUserID(userID: data.userID!)
        self.setDeviceID(deviceID: data.deviceID!)
        self.updateAPI()

        LocalStorageHelper.putString(key: Constants.STORAGE_DEVICE_UUID, value: self.uuID!)
    }
}
