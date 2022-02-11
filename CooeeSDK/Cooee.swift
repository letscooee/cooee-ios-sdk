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
@objc
public final class CooeeSDK: NSObject {
    // MARK: Lifecycle

    override init() {
        self.safeHttpService = CooeeFactory.shared.safeHttpService
        self.runtimeData = RuntimeData.shared
        self.sentryHelper = CooeeFactory.shared.sentryHelper
        self.onCTAHandler = nil
    }

    // MARK: Public

    @objc
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
    @objc
    public func sendEvent(eventName: String, eventProperties: [String: Any]? = [String: Any]()) throws {
        
        for (key, _) in eventProperties ?? [String: Any]() {
            let prefix = String(key.prefix(2))

            if prefix.caseInsensitiveCompare(Constants.SYSTEM_DATA_PREFIX) == .orderedSame {
                throw CustomError.PropertyError
            }
        }

        let event = Event(eventName: eventName, properties: eventProperties ?? [String: Any]())
        safeHttpService.sendEvent(event: event)
    }

    /**
     Send given user data to the server
     - Parameter userData: The common user data like name, email.
     */
    @objc
    public func updateUserData(userData: [String: Any]) {
        sentryHelper.setUserInfo(userData: userData)
        safeHttpService.updateUserDataOnly(userData: userData)
    }

    /**
     Send given user properties to the server
     - Parameter userProperties: The additional user properties.
     */
    @objc
    public func updateUserProperties(userProperties: [String: Any]) {
        safeHttpService.updateUserPropertyOnly(userProperty: userProperties)
    }

    /**
     Send the given user data and user properties to the server.
     - Parameters:
       - userData: The common user data like name, email.
       - userProperties: The additional user properties.
     */
    @objc
    public func updateUserProfile(userData: [String: Any], userProperties: [String: Any]) {
        sentryHelper.setUserInfo(userData: userData)
        safeHttpService.updateUserProfile(userData: userData, userProperties: userProperties)
    }

    /**
     Set current screen name where user navigated.
     - Parameter screenName: Name of the screen. Like Login, Cart, Wishlist etc.
     */
    @objc
    public func setCurrentScreen(screenName: String) {
        runtimeData.setCurrentScreenName(name: screenName)
    }

    /**
     Provide the userID of the current user
     - Returns: String value
     */
    @objc
    public func getUserID() -> String? {
        CooeeFactory.shared.userAuthService.getUserID()
    }

    @objc
    public func setOnCTADelegate(_ onCTAHandler: CooeeCTADelegate) {
        self.onCTAHandler = onCTAHandler
    }

    @objc
    public func getOnCTAListener() -> CooeeCTADelegate? {
        onCTAHandler
    }

    /**
     Send APNS device token to server
     - Parameter data: data provided by application(application:didRegisterForRemoteNotificationsWithDeviceToken:)
     */
    @objc
    public func setDeviceToken(token data: Data?) {
        guard let rawToken = data else {
            NSLog("Received empty device token")
            return
        }

        let tokenString = rawToken.reduce("") {
            $0 + String(format: "%02X", $1)
        }
        var requestBody = [String: Any]()
        requestBody["pushToken"] = tokenString

        CooeeFactory.shared.safeHttpService.updatePushToken(requestData: requestBody)
    }

    /**
     Accepts data received from user ``userNotificationCenter(:didReceive:withCompletionHandler:)`` and perform related
     actions by Cooee

     - Parameter response:``UNNotificationResponse`` provided by ``userNotificationCenter(:didReceive:withCompletionHandler:)``
     */
    @objc
    public func notificationAction(_ response: UNNotificationResponse) {
        guard let triggerData = getTriggerData(response.notification) else {
            return
        }

        switch response.actionIdentifier {
            case UNNotificationDismissActionIdentifier:
                CooeeNotificationService.sendEvent("CE Notification Cancelled", withTriggerData: triggerData)
            case UNNotificationDefaultActionIdentifier:
                notificationClicked(triggerData)
            default:
                // Handle other actions
                break
        }
    }

    /**
     Checks for Cooee Notification for foreground status otherwise returns default ``UNNotificationPresentationOptions``

     - Parameter notification: ``UNNotification`` provided by ``userNotificationCenter(_:willPresent:withCompletionHandler:)``
     - Returns:
     */
    @objc
    public func presentNotification(_ notification: UNNotification) -> UNNotificationPresentationOptions {
        guard let triggerData = getTriggerData(notification) else {
            return [.alert, .sound, .badge]
        }

        if triggerData.getPushNotification() == nil {
            launchInApp(with: triggerData)
            return []
        }

        return [.alert, .sound, .badge]
    }

    /**
     Use to set wrapper name. Can use only in Flutter/Cordova/React-Native to keep track of wrappers

     - parameters:
     - wrapperName: Name of the wrapper
    - warning:  Can use only in Flutter/Cordova/React-Native to keep track of wrappers
     */
    @objc
    public func setWrapper(_ wrapperName: String) {
        CooeeFactory.shared.baseHttpService.commonHeaders.wrapper = wrapperName
    }

    // MARK: Private

    private static var shared: CooeeSDK?

    private let safeHttpService: SafeHTTPService
    private let runtimeData: RuntimeData
    private let sentryHelper: SentryHelper
    private var onCTAHandler: CooeeCTADelegate?

    /**
     Extract trigger data from raw ``UNNotification``

     - Parameter notification: raw ``UNNotification``
     - Returns: optional ``TriggerData``
     */
    private func getTriggerData(_ notification: UNNotification) -> TriggerData? {
        let userInfo = notification.request.content.userInfo

        let rawTriggerData = userInfo["triggerData"]

        if rawTriggerData == nil {
            return nil
        }

        guard let triggerData = TriggerData.deserialize(from: "\(rawTriggerData!)") else {
            return nil
        }

        return triggerData
    }

    /**
     Performs the notification click action

     - Parameter triggerData: ``TriggerData`` received via click action of push notification
     */
    private func notificationClicked(_ triggerData: TriggerData) {
        if triggerData.getPushNotification() != nil {
            CooeeNotificationService.sendEvent("CE Notification Clicked", withTriggerData: triggerData)
        }

        guard let notificationClickAction = triggerData.getPushNotification()?.getClickAction() else {
            launchInApp(with: triggerData)
            return
        }

        guard let launchType = notificationClickAction.open else {
            launchInApp(with: triggerData)
            return
        }

        if launchType == 1 {
            launchInApp(with: triggerData)
        } else {
            let triggerContext = TriggerContext()
            triggerContext.setTriggerData(triggerData: triggerData)
            if let activeViewController = UIApplication.shared.topMostViewController() {
                triggerContext.setPresentViewController(presentViewController: activeViewController)
            }

            ClickActionExecutor(notificationClickAction, triggerContext).execute()
        }
    }

    /**
     Provide data to the ``EngagementTriggerHelper.renderInAppFromPushNotification`` to launch in-App

     - Parameter triggerData: ``TriggerData``
     */
    private func launchInApp(with triggerData: TriggerData) {
        EngagementTriggerHelper.renderInAppFromPushNotification(for: triggerData)
    }
}
