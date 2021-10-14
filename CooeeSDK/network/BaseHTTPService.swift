//
//  BaseHTTPService.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 21/09/21.
//

import Foundation

/**
  A base or lower level HTTP service which simply hits the backend for given request. It does not perform
 any retries or it does not cache the request for future reattempts. This server should not contain any business logic.
 <p>
 Make sure these methods are not called in the main-thread.

  - Author: Ashish Gaikwad
  - Since: 0.1.0
  */
class BaseHTTPService {

    class CommonHeaders {
        // MARK: Lifecycle

        init() {
            dictionary = ["device-name": DeviceInfo.shared.cachedInfo.name,
                          "sdk-version": SDKInfo.shared.cachedInfo.sdkVersion,
                          "sdk-version-code": SDKInfo.shared.cachedInfo.sdkLongVersion,
                          "app-version": AppInfo.shared.getAppVersion()]
        }

        // MARK: Internal

        var sdkToken: String?
        var userID: String?
        var dictionary: [String: String]

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

    let webService = WebService.shared
    let commonHeaders = CommonHeaders()

    func sendFirebaseToken(token: String?) throws {
        if token == nil {
            return
        }
        var requestData = [String: Any]()
        requestData["firebaseToken"] = token!

        _ = try webService.getResponse(fromURL: Constants.saveFCM, method: .POST, params: requestData, header: commonHeaders.getDictionary(), t: [String: String].self)
    }

    func registerDevice(body: DeviceAuthenticationBody, completion: @escaping (UserAuthResponse?, Error?) -> ()) {
        do {
            let result = try webService.getResponse(fromURL: Constants.registerUser, method: .POST, params: body.toDictionary(), header: commonHeaders.getDictionary(), t: UserAuthResponse.self)
            completion(result, nil)
        } catch {
            completion(nil, error)
        }
    }

    func sendSessionConcludedEvent(body: [String: Any]) throws {
        _ = try webService.getResponse(fromURL: Constants.concludeSession, method: .POST, params: body, header: commonHeaders.getDictionary(), t: [String: String].self)
    }

    func keepAliveSession(body: [String: Any]) {
        do {
            _ = try webService.getResponse(fromURL: Constants.keepAlive, method: .POST, params: body, header: commonHeaders.getDictionary(), t: [String: String].self)
        } catch {}
    }

    func updateUserProfile(requestData: [String: Any]) throws {
        _ = try webService.getResponse(fromURL: Constants.updateProfile, method: .PUT, params: requestData, header: commonHeaders.getDictionary(), t: [String: String].self)
    }

    func sendEvent(event: Event) throws {
        _ = try webService.getResponse(fromURL: Constants.trackEvent, method: .POST, params: event.toDictionary(), header: commonHeaders.getDictionary(), t: [String: String].self)
    }
}
