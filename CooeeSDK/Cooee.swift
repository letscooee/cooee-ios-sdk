//
//  Cooee.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 16/09/21.
//

import Foundation
import UIKit

/**
 The CooeeSDK class contains all the functions required by application to achieve the campaign tasks(Singleton Class)
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
public final class CooeeSDK {
    // MARK: Lifecycle

    init() {
        self.baseHttpService = CooeeFactory.shared.baseHttpService
        self.runtimeData = RuntimeData.shared
    }

    // MARK: Public

    public static func getInstance() -> CooeeSDK {
        if shared == nil {
            shared = CooeeSDK()
        }
        return shared!
    }

    /**
     Sends custom events to the server and returns with the campaign details(if any)
     - Parameters:
       - eventName: Name the event like onDeviceReady
       - eventProperties: Properties associated with the event
     - Throws: Throws {@link CustomError#PropertyError} if user try to send any property start with {@link Constants.SYSTEM_DATA_PREFIX}
     */
    public func sendEvent(eventName: String, eventProperties: [String: Any]) throws {
        for (key, _) in eventProperties {
            let prefix = String(key.prefix(2))
            print(prefix)
            if prefix.caseInsensitiveCompare(Constants.SYSTEM_DATA_PREFIX) == .orderedSame {
                throw CustomError.PropertyError
            }
        }

        let event = Event(eventName: eventName, properties: eventProperties)
        baseHttpService.sendEvent(event: event)
    }

    /**
     Send given user data to the server
     - Parameter userData: The common user data like name, email.
     */
    public func updateUserData(userData: [String: Any]) {
        baseHttpService.updateUserData(userData: userData)
    }

    /**
     Send given user properties to the server
     - Parameter userProperties: The additional user properties.
     */
    public func updateUserProperties(userProperties: [String: Any]) {
        baseHttpService.updateUserProperty(userProperty: userProperties)
    }

    /**
     Send the given user data and user properties to the server.
     - Parameters:
       - userData: The common user data like name, email.
       - userProperties: The additional user properties.
     */
    public func updateUserProfile(userData: [String: Any], userProperties: [String: Any]) {
        baseHttpService.updateUserProfile(userData: userData, userProperties: userProperties)
    }

    /**
     Set current screen name where user navigated.
     - Parameter screenName: Name of the screen. Like Login, Cart, Wishlist etc.
     */
    public func setCurrentScreen(screenName: String) {
        runtimeData.setCurrentScreenName(name: screenName)
    }

    /**
     Provide the userID of the current user
     - Returns: String value
     */
    public func getUserID() -> String? {
        CooeeFactory.shared.userAuthService.getUserID()
    }

    // MARK: Private

    private static var shared: CooeeSDK?

    private let baseHttpService: BaseHTTPService
    private let runtimeData: RuntimeData
}
