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

    func sendFirebaseToken(token: String?) {
        if token == nil {
            return
        }
        var requestData = [String: Any]();
        requestData["firebaseToken"] = token!

        webService.getResponse(fromURL: Constants.saveFCM, method: .POST, params: requestData, header: commonHeaders.getDictionary()) {
            (result: [String: String]) in
            if result != nil {
                print(result)
            }
        }
    }

    static let shared = BaseHTTPService()

    let webService = WService.shared
    let commonHeaders = CommonHeaders()

    func registerDevice(body: AuthenticationRequestBody, completion: @escaping (UserAuthResponse) -> ()) {
        webService.getResponse(fromURL: Constants.registerUser, method: .POST, params: body.toDictionary(), header: commonHeaders.getDictionary()) {
            (result: UserAuthResponse) in
            if result != nil {
                completion(result)
            }
        }
    }

    func sendSessionConcludedEvent(body: [String: Any]) {
        webService.getResponse(fromURL: Constants.concludeSession, method: .POST, params: body, header: commonHeaders.getDictionary()) {
            (result: [String: String]) in
            if result != nil {
                print(result)
            }
        }
    }

    func keepAliveSession(body: [String: Any]) {
        webService.getResponse(fromURL: Constants.keepAlive, method: .POST, params: body, header: commonHeaders.getDictionary()) {
            (result: [String: String]) in
            if result != nil {
                print(result)
            }
        }
    }

    func updateUserPropertyOnly(userProperty: [String: Any]) {
        updateUserProfile(userData: [String: Any](), userProperties: userProperty)
    }

    func updateUserProfile(userData: [String: Any], userProperties: [String: Any]) {
        var body = [String: Any]()
        body["userProperties"] = userProperties
        body["userData"] = userData

        webService.getResponse(fromURL: Constants.updateProfile, method: .PUT, params: body, header: commonHeaders.getDictionary()) {
            (result: [String: String]) in
            if result != nil {
                print(result)
            }
        }
    }

    func updateUserDataOnly(userData: [String: Any]) {
        updateUserProfile(userData: userData, userProperties: [String: Any]())
    }

    func sendEvent(event: Event) {
        webService.getResponse(fromURL: Constants.trackEvent, method: .POST, params: event.toDictionary(), header: commonHeaders.getDictionary()) {
            (result: [String: String]) in
            if result != nil {
                print(result)
            }
        }
    }
}
