//
//  BaseHTTPService.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 21/09/21.
//

import Foundation

/**
 Central point to make communication with server

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class BaseHTTPService {
    class CommonHeaders {
        // MARK: Lifecycle

        init() {
            dictionary["device-name"] = DeviceInfo.shared.cachedInfo.name
            dictionary["sdk-version"] = SDKInfo.shared.cachedInfo.sdkVersion
            dictionary["sdk-version-code"] = SDKInfo.shared.cachedInfo.sdkLongVersion
            dictionary["app-version"] = AppInfo.shared.getAppVersion()
        }

        // MARK: Internal

        var sdkToken: String?
        var userID: String?
        var dictionary = [String: String]()

        func getDictionary() -> [String: String] {
            if !(sdkToken?.isEmpty ?? true) {
                dictionary["x-sdk-token"] = sdkToken ?? ""
            }

            if !(userID?.isEmpty ?? true) {
                dictionary["user-id"] = userID ?? ""
            }

            return dictionary
        }
    }

    static let shared = BaseHTTPService()

    let webService = WService.shared
    let commonHeaders = CommonHeaders()

    func sendFirebaseToken(token: String?) throws {
        if token == nil {
            return
        }
        var requestData = [String: Any]()
        requestData["firebaseToken"] = token!

        try webService.getResponse(fromURL: Constants.saveFCM, method: .POST, params: requestData, header: commonHeaders.getDictionary()) {
            (result: [String: String]?, error: Error?) in
            if error == nil {
                print(result ?? "")
            } else {
                // throw error
            }
        }
    }

    func registerDevice(body: AuthenticationRequestBody, completion: @escaping (UserAuthResponse) -> ()) {
        do {
            try webService.getResponse(fromURL: Constants.registerUser, method: .POST, params: body.toDictionary(), header: commonHeaders.getDictionary()) {
                (result: UserAuthResponse?, _: Error?) in
                if result != nil {
                    completion(result!)
                }
            }
        } catch {}
    }

    func sendSessionConcludedEvent(body: [String: Any]) throws {
        try webService.getResponse(fromURL: Constants.concludeSession, method: .POST, params: body, header: commonHeaders.getDictionary()) {
            (result: [String: String]?, _: Error?) in
            if result != nil {
                print(result ?? "")
            }
        }
    }

    func keepAliveSession(body: [String: Any]) {
        do {
            try webService.getResponse(fromURL: Constants.keepAlive, method: .POST, params: body, header: commonHeaders.getDictionary()) {
                (result: [String: String]?, _: Error?) in
                if result != nil {
                    print(result ?? "")
                }
            }
        } catch {}
    }

    func updateUserProfile(requestData: [String: Any]) throws {
        try webService.getResponse(fromURL: Constants.updateProfile, method: .PUT, params: requestData, header: commonHeaders.getDictionary()) {
            (result: [String: String]?, _: Error?) in
            if result != nil {
                print(result ?? "")
            }
        }
    }

    func sendEvent(event: Event) throws {
        try webService.getResponse(fromURL: Constants.trackEvent, method: .POST, params: event.toDictionary(), header: commonHeaders.getDictionary()) {
            (result: [String: String]?, _: Error?) in
            if result != nil {
                print(result ?? "")
            }
        }
    }
}
