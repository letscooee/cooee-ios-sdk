//
//  BaseHTTPService.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 21/09/21.
//

import Foundation

class BaseHTTPService {
    struct CommomHeaders {
        // MARK: Lifecycle

        init() {
            dictionary["device-name"] = DeviceInfo.shared.cachedInfo.name
            dictionary["sdk-version"] = SDKInfo.shared.catchedInfo.sdkVersion
            dictionary["sdk-version-code"] = SDKInfo.shared.catchedInfo.sdkLongVersion
            dictionary["app-version"] = AppInfo.shared.getAppVersion()
        }

        // MARK: Internal

        var sdkToken: String?
        var userID: String?
        var dictionary = [String: String]()

        mutating func getDictinary() -> [String: String] {
            if !(sdkToken?.isEmpty ?? true) {
                dictionary["x-sdk-token"] = sdkToken
            }

            if !(userID?.isEmpty ?? true) {
                dictionary["user-id"] = userID
            }

            return dictionary
        }
    }

    static let shared = BaseHTTPService()

    let webService = WService.shared

    func registerDevice(body: AuthenticationRequestBody, completion: @escaping (UserAuthResponse) -> ()) {
        webService.getResponse(fromURL: EndPoints.registerUser, method: .POST, params: body.toDictionary(), header: CommomHeaders().dictionary) {
            (result: UserAuthResponse) in
            if result != nil {
                completion(result)
            }
        }
    }
}
