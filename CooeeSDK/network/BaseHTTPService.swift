//
//  BaseHTTPService.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 21/09/21.
//

import Foundation

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

    func registerDevice(body: AuthenticationRequestBody, completion: @escaping (UserAuthResponse) -> ()) {
        webService.getResponse(fromURL: EndPoints.registerUser, method: .POST, params: body.toDictionary(), header: commonHeaders.getDictionary()) {
            (result: UserAuthResponse) in
            if result != nil {
                completion(result)
            }
        }
    }

    func sendSessionConcludedEvent(body: [String: Any]) {
        webService.getResponse(fromURL: EndPoints.concludeSession, method: .POST, params: body, header: commonHeaders.getDictionary()) {
            (result: [String: String]) in
            if result != nil {
                print(result)
            }
        }
    }

    func keepAliveSession(body: [String: Any]) {
        webService.getResponse(fromURL: EndPoints.keepAlive, method: .POST, params: body, header: commonHeaders.getDictionary()) {
            (result: [String: String]) in
            if result != nil {
                print(result)
            }
        }
    }

    func updateUserPropertyOnly(userProperty: [String: Any]) {
        var dictionary = [String: Any]()
        dictionary["userProperties"] = userProperty
        dictionary["userData"] = [String: Any]()
        updateUserProfile(body: dictionary)
    }

    func updateUserProfile(body: [String: Any]) {
        webService.getResponse(fromURL: EndPoints.updateProfile, method: .PUT, params: body, header: commonHeaders.getDictionary()) {
            (result: [String: String]) in
            if result != nil {
                print(result)
            }
        }
    }

    func sendEvent(event: Event) {
        webService.getResponse(fromURL: EndPoints.trackEvent, method: .POST, params: event.toDictionary(), header: commonHeaders.getDictionary()) {
            (result: [String: String]) in
            if result != nil {
                print(result)
            }
        }
    }
}
