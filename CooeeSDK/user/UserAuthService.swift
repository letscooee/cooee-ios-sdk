//
//  UserAuthService.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 20/09/21.
//

import BSON
import Foundation

/**
 Utility class to register user with server and to provide related data

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
class UserAuthService {
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
            print("Already has SDK token")
            self.populateUserDataFromStorage()
            return
        }

        print("Attempt to acquire SDK token")

        self.getSDKTokenFromServer()
        self.lock.unlock()
    }

    func hasToken() -> Bool {
        let sdkToken = LocalStorageHelper.getString(key: Constants.STORAGE_SDK_TOKEN)
        return !(sdkToken?.isEmpty ?? true)
    }

    func updateAPI() {
        if SDKInfo.shared.cachedInfo.isDebugging {
            print("SDK Token - \(self.sdkToken ?? "")")
            print("User ID - \(self.userID ?? "")")
        }

        self.baseHttp?.commonHeaders.sdkToken = self.sdkToken
        self.baseHttp?.commonHeaders.userID = self.userID
        self.sentryHelper.setUserId(id: self.userID!)

        // send screenshot once sdk token is acquired/published
        DispatchQueue.main.async {
            ScreenShotUtility.captureAndSendScreenShot()
        }
    }

    func getUserID() -> String? {
        self.userID
    }

    // MARK: Private

    private let baseHttp: BaseHTTPService?
    private let sentryHelper: SentryHelper

    private var userID: String?
    private var deviceID: String?
    private var sdkToken: String?
    private var uuID: String?

    /**
     * This method will pull user data (like SDK token & user ID) from the local storage (shared preference)
     * and populates it for further use.
     */
    private func populateUserDataFromStorage() {
        self.sdkToken = LocalStorageHelper.getString(key: Constants.STORAGE_SDK_TOKEN)
        self.userID = LocalStorageHelper.getString(key: Constants.STORAGE_USER_ID)
        self.deviceID = LocalStorageHelper.getString(key: Constants.STORAGE_DEVICE_ID)

        if self.sdkToken == nil {
            print("No SDK token found in preference")
        }

        if self.userID == nil {
            print("No user ID found in preference")
        }

        self.updateAPI()
    }

    /**
     * Make user registration with server (if not already) and acquire a SDK token which will be later used to authenticate
     * other endpoints.
     */
    private func getSDKTokenFromServer() {
        self.uuID = ObjectId().hexString
        let appInfo = InfoPlistReader.shared
        let props = DevicePropertyCollector().getDefaultValues()

        let authBody = DeviceAuthenticationBody(appID: appInfo.appID, appSecret: appInfo.appSecret, uuid: self.uuID!, props: props)
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

    private func saveUserDataInStorage(data: DeviceAuthResponse) {
        self.sdkToken = data.sdkToken ?? ""
        self.userID = data.id ?? ""
        self.deviceID = data.deviceID ?? ""
        self.updateAPI()

        LocalStorageHelper.putString(key: Constants.STORAGE_DEVICE_ID, value: self.deviceID!)
        LocalStorageHelper.putString(key: Constants.STORAGE_SDK_TOKEN, value: self.sdkToken!)
        LocalStorageHelper.putString(key: Constants.STORAGE_USER_ID, value: self.userID!)
        LocalStorageHelper.putString(key: Constants.STORAGE_DEVICE_UUID, value: self.uuID!)
    }
}
