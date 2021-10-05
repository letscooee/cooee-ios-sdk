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
 - Since:0.1
 */
class UserAuthService {
    // MARK: Lifecycle

    init() {
        baseHttp = BaseHTTPService.shared
    }

    // MARK: Internal

    static let shared = UserAuthService()

    let lock = NSRecursiveLock()
    var baseHttp: BaseHTTPService?

    /**
     * Method will ensure that the SDK has acquired the token. If on the first time, token can't be pulled
     * from the server, calling this method will reattempt the same maximum within 1 minute.
     */
    func acquireSDKToken() {
        lock.lock()
        if self.hasToken() {
            print("Already has SDK token")
            self.populateUserDataFromStorage()
            return
        }

        print("Attempt to acquire SDK token")

        self.getSDKTokenFromServer()
        lock.unlock()
    }

    func hasToken() -> Bool {
        let sdkToken = LocalStorageHelper.getString(key: Constants.STORAGE_SDK_TOKEN)
        return !(sdkToken?.isEmpty ?? true)
    }

    func updateAPI() {
        if SDKInfo.shared.catchedInfo.isDebugging {
            print("SDK Token - \(self.sdkToken ?? "")")
            print("User ID - \(self.userID ?? "")")
        }

        baseHttp?.commonHeaders.sdkToken = self.sdkToken
        baseHttp?.commonHeaders.userID = self.userID
    }

    // MARK: Private

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
        let props = DefaultPropertyCollector().getDefaultVales()

        let authBody = AuthenticationRequestBody(appID: appInfo.appID, appSecret: appInfo.appSecret, uuid: self.uuID!, props: props)
        baseHttp?.registerDevice(body: authBody) {
            result in

            self.saveUserDataInStorage(data: result)
        }
    }

    private func saveUserDataInStorage(data: UserAuthResponse) {
        self.sdkToken = data.sdkToken ?? ""
        self.userID = data.id ?? ""
        self.updateAPI()
        // TODO: Add device id
        LocalStorageHelper.putString(key: Constants.STORAGE_SDK_TOKEN, value: self.sdkToken!)
        LocalStorageHelper.putString(key: Constants.STORAGE_USER_ID, value: self.userID!)
        LocalStorageHelper.putString(key: Constants.STORAGE_DEVICE_UUID, value: self.uuID!)
    }
}
