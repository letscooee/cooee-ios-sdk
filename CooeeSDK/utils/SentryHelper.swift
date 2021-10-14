//
//  SentryHelper.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 13/10/21.
//

import Foundation
import Sentry

/**
 Utility class for Sentry initialization, logging & other utility.

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class SentryHelper {
    // MARK: Lifecycle

    init(_ appInfo: AppInfo, _ sdkInfo: SDKInfo, _ infoPlistReader: InfoPlistReader) {
        self.appInfo = appInfo
        self.sdkInfo = sdkInfo
        self.infoPlistReader = infoPlistReader
        self.enabled = sdkInfo.cachedInfo.isDebugging
    }

    // MARK: Public

    /**
     Set Cooee's User id to Sentry's {@link User} so that this information can be shown in the Sentry dashboard as well.

     - Parameter id: Identify of the Cooee's User.
     */
    public func setUserId(id: String) {
        self.user.userId = id
    }

    /**
     Set additional Cooee's User information to Sentry's {@link User} so that this information can be shown in
     the Sentry dashboard as well. Sentry is already GDPR compliant.

     - Parameter userData: Additional user data which may contain <code>mobile</code>, <code>name</code> or <code>mobile</code>.
     */
    public func setUserInfo(userData: [String: Any?]?) {
        if userData == nil {
            return
        }

        if let name = userData!["name"], !"\(String(describing: name))".isEmpty {
            self.user.username = String(describing: name)
        }

        if let email = userData!["email"], !"\(String(describing: email))".isEmpty {
            self.user.email = String(describing: email)
        }

        if let mobile = userData!["mobile"], !"\(String(describing: mobile))".isEmpty {
            let userDataExtra = ["mobile", mobile]
            self.user.data = userDataExtra
        }
    }

    /**
     Capture any plain message to Sentry. This method prefix the message with the word "Cooee" so that
     {@link #setupFilterToExcludeNonCooeeEvents(SentryOptions)} can pass the validation and send it to Sentry.

     - Parameter message: Any custom message to send.
     */
    public func capture(message: String) {
        print("\(Constants.TAG) \(message)")
        SentrySDK.capture(message: message)
    }

    /**
     Utility method to capture exception in Sentry.
     - Parameter error: NSError to log
     */
    public func capture(error: NSError) {
        print("\(Constants.TAG) \(error)")
        SentrySDK.capture(error: error)
    }

    // MARK: Internal

    func initSentry() {
        print("Initializing Sentry: \(self.enabled)")

        if !self.enabled {
            return
        }

        SentrySDK.start { options in
            options.dsn = SentryHelper.COOEE_DSN
            options.debug = self.sdkInfo.cachedInfo.isDebugging
            options.releaseName = "com.letscooee@\(self.sdkInfo.cachedInfo.sdkVersion)+\(self.sdkInfo.cachedInfo.sdkLongVersion)"
            options.environment = self.sdkInfo.cachedInfo.isDebugging ? "development" : "production"
            self.setupFilterToExcludeNonCooeeEvents(options)
        }
        self.setupGlobalTags()
    }

    // MARK: Private

    private static let COOEE_DSN = "https://93ac02d69b4043c59fe6fd088ea93d53@o559187.ingest.sentry.io/5698931"

    private let appInfo: AppInfo
    private let sdkInfo: SDKInfo
    private let enabled: Bool
    private let infoPlistReader: InfoPlistReader
    private let user = User()

    /**
     Adds some global tags to each event.
     */
    private func setupGlobalTags() {
        SentrySDK.configureScope { scope in
            scope.setTag(value: self.appInfo.cachedInfo.packageName, key: "client.appPackage")
            scope.setTag(value: self.appInfo.cachedInfo.version, key: "client.appVersion")
            scope.setTag(value: self.appInfo.cachedInfo.name, key: "client.appName")
            scope.setTag(value: self.infoPlistReader.appID, key: "client.appId")
            scope.setTag(value: self.appInfo.cachedInfo.isDebugging ? "debug" : "release", key: "appBuildType")
        }
    }

    /**
     Side effect of adding Sentry to an SDK is that the exceptions from the app is also gathered in our Sentry dashboard.

     - Parameter options: Sentry options
     */
    private func setupFilterToExcludeNonCooeeEvents(_ options: Options) {
        options.beforeSend = { event in
            if !self.containsWordCooee(event) {
                print("Skipping Sentry event with message: \(String(describing: event.message))")
                return nil
            }

            if self.sdkInfo.cachedInfo.isDebugging {
                return nil
            }

            return event
        }
    }

    /**
     Checks if the event message or stacktrace contains the word "Cooee" (case insensitive).

     - Parameter event: will be SentryEvent
     - Returns: true if contains cooee keyword otherwise false
     */
    private func containsWordCooee(_ event: Sentry.Event) -> Bool {
        if let message = event.message {
            if message.formatted.lowercased().contains("cooee") {
                return true
            }
        }

        if event.error == nil {
            return false
        }

        let description = "\(String(describing: event.error))"

        return description.lowercased().contains("cooee")
    }
}
