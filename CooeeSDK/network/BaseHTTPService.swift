//
//  BaseHTTPService.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 21/09/21.
//

import Foundation
import UIKit

/**
  A base or lower level HTTP service which simply hits the backend for given request. It does not perform
 any retries or it does not cache the request for future reattempts. This server should not contain any business logic.
 <p>
 Make sure these methods are not called in the main-thread.

  - Author: Ashish Gaikwad
  - Since: 1.3.0
  */
class BaseHTTPService {
    // MARK: Lifecycle

    init() {
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            isTesting = true
        }
    }

    // MARK: Internal

    class CommonHeaders {
        // MARK: Lifecycle

        init() {
            dictionary = ["device-name": DeviceInfo.shared.cachedInfo.name.urlEncoded!,
                          "sdk-version": SDKInfo.shared.cachedInfo.sdkVersion,
                          "sdk-version-code": "\(SDKInfo.shared.cachedInfo.sdkVersionCode)",
                          "app-version": AppInfo.shared.getAppVersion()]
        }

        // MARK: Internal

        var sdkToken: String?
        var userID: String?
        var dictionary: [String: String]
        var wrapper: String?

        func getDictionary() -> [String: String] {
            if !(sdkToken?.isEmpty ?? true) {
                dictionary["x-sdk-token"] = sdkToken ?? ""
            }

            if !(userID?.isEmpty ?? true) {
                dictionary["user-id"] = userID ?? ""
            }

            if !(wrapper?.isEmpty ?? true) {
                dictionary["sdk-wrapper"] = wrapper!
            }

            if AppInfo.shared.isAppDebugging() {
                dictionary["app-debug"] = "1"
            }

            if SDKInfo.shared.cachedInfo.isDebugging {
                dictionary["sdk-debug"] = "1"
            }

            return dictionary
        }
    }

    static let shared = BaseHTTPService()

    let webService = WebService.shared
    let externalApiClient = ExternalApiClient.shared
    let publicApiClient = PublicApiClient.shared
    let commonHeaders = CommonHeaders()
    var isTesting: Bool = false

    func sendPushToken(token: String?) throws {
        if isTesting {
            return
        }

        if token == nil {
            return
        }
        var requestData = [String: Any]()
        requestData["pushToken"] = token!

        _ = try webService.getResponse(fromURL: Constants.saveFCM, method: .POST, params: requestData,
                header: commonHeaders.getDictionary())
    }

    func registerDevice(body: DeviceAuthenticationBody, completion: @escaping (DeviceAuthResponse?, Error?) -> ()) {
        if isTesting {
            completion(DeviceAuthResponse(), nil)
        }

        do {
            let result = try webService.getResponse(fromURL: Constants.registerUser, method: .POST,
                    params: body.toDictionary(), header: commonHeaders.getDictionary())

            completion(DeviceAuthResponse.deserialize(from: result), nil)
        } catch {
            completion(nil, error)
        }
    }

    func sendSessionConcludedEvent(body: [String: Any]) throws {
        if isTesting {
            return
        }

        _ = try webService.getResponse(fromURL: Constants.concludeSession, method: .POST, params: body,
                header: commonHeaders.getDictionary())
    }

    func keepAliveSession(body: [String: Any]) {
        if isTesting {
            return
        }

        do {
            _ = try webService.getResponse(fromURL: Constants.keepAlive, method: .POST, params: body,
                    header: commonHeaders.getDictionary())
        } catch {
        }
    }

    func updateUserProfile(requestData: [String: Any]) throws {
        if isTesting {
            return
        }

        let response = try webService.getResponse(fromURL: Constants.updateProfile, method: .PUT, params: requestData,
                header: commonHeaders.getDictionary())

        // send to update the local storage & api client
        CooeeFactory.shared.deviceAuthService.checkAndUpdate(response)
    }

    func updateDeviceProp(requestData: [String: Any]) throws {
        if isTesting {
            return
        }

        _ = try webService.getResponse(fromURL: Constants.deviceUpdate, method: .PUT, params: requestData,
                header: commonHeaders.getDictionary())
    }

    func sendEvent(event: Event) throws {
        if isTesting {
            return
        }

        let responseData = try webService.getResponse(fromURL: Constants.trackEvent, method: .POST, params: event.toJSON()!,
                header: commonHeaders.getDictionary())

        DispatchQueue.main.async {
            do {
                try EngagementTriggerHelper().renderInAppTriggerFromResponse(response: responseData)
            } catch {
                NSLog("\(Constants.TAG) \(error.localizedDescription)")
            }
        }
    }

    func loadTriggerDetails(id triggerId: String) throws -> [String: Any] {
        let response = try webService.getResponse(fromURL: "\(Constants.triggerDetails)\(triggerId)", method: .GET, params: [String: Any](),
                header: commonHeaders.getDictionary())
        return response ?? [String: Any]()
    }

    func downloadFont(_ url: URL, atPath filePath: URL) throws {
        if isTesting {
            return
        }

        try externalApiClient.downloadFile(webURL: url, filePath: filePath)
    }

    func getAppConfig(appID: String) throws -> [String: Any]? {
        if isTesting {
            return nil
        }

        return try publicApiClient.getAppConfig(appID: appID)
    }

    func uploadScreenshot(imageToUpload: UIImage, screenName: String) throws -> [String: Any]? {
        if isTesting {
            return nil
        }

        let response = try publicApiClient.uploadImage(imageToUpload: imageToUpload, screenName: screenName, header: commonHeaders.getDictionary())
        return response
    }
}
