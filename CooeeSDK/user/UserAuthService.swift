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
        baseHttp = BaseHTTPService()
    }

    // MARK: Internal

    static let shared = UserAuthService()

    var baseHttp: BaseHTTPService?

    func acquireSDKToken() {
        if self.hasToken() {
            return
        }

        print("Attempt to acquire SDK token")

        self.getSDKTokenFromServer()
    }

    func hasToken() -> Bool {
        let sdkToken = LocalStorageHelper.getString(key: Constants.STORAGE_SDK_TOKEN)
        return !(sdkToken?.isEmpty ?? true)
    }

    func updateAPI() {
        
    }

    // MARK: Private

    private var userID: String?
    private var deviceID: String?
    private var sdkToken: String?
    private var uuID: String?

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
