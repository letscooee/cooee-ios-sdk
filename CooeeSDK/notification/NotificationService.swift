//
//  NotificationService.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 01/12/21.
//

import Foundation
import NotificationCenter

@objc
public class CooeeNotificationService: NSObject {
    // MARK: Lifecycle

    init(userInfo: [AnyHashable: Any]) {
        self.userInfo = userInfo
        super.init()
    }

    // MARK: Public

    /**
     This method Updates Notification content and returns data back to extension.

     - Parameter request: UNNotificationRequest object which is used to update notification content
     - Returns: MutableNotificationContent object which has updated content
     */
    @objc
    public static func updateContentFromRequest(_ request: UNNotificationRequest) -> UNMutableNotificationContent? {
        var userInfo = request.content.userInfo
        userInfo["notificationID"] = request.identifier
        userInfo["sdkCode"] = Constants.VERSION_CODE
        LocalStorageHelper.putString(key: Constants.STORAGE_NOTIFICATION_ID, value: request.identifier)
        return updateNotificationContent(request.content.mutableCopy() as! UNMutableNotificationContent, with: userInfo)
    }

    // MARK: Internal

    /**
     Create and send the event to the server
     - Parameters:
       - eventName: Name of event
       - triggerData: trigger information of event
     */
    static func sendEvent(_ eventName: String, withTriggerData triggerData: TriggerData) {
        DispatchQueue.main.async {
            let event = Event(eventName: eventName, triggerData: triggerData)
            CooeeFactory.shared.safeHttpService.sendEventWithoutNewSession(event: event)
        }
    }

    /**
     Process all parts and create one string to show in PN

     - Parameter textElement: The text element to be processed.
     - Returns: String
     */
    static func getTextFromPart(from textElement: TextElement?) -> String? {
        if textElement == nil {
            return nil
        }

        var string = ""
        guard let parts = textElement!.prs else {
            return nil
        }

        let count = parts.count - 1

        for index in 0...count {
            string = "\(string) \(parts[index].getPartText().trimmingCharacters(in: .newlines))"
        }

        return string
    }


    // MARK: Private

    private static var pendingNotificationContent: UNMutableNotificationContent?
    private static var triggerData: TriggerData?

    private var userInfo: [AnyHashable: Any]

    /**
     This method Updates Notification content and returns data back to extension.

     - Parameters:
       - mutableNotificationContent: MutableNotificationContent object which is used to update notification content
       - userInfo: userInfo dictionary which is passed from notification
     - Returns: MutableNotificationContent object which has updated content
     */
    private static func updateNotificationContent(_ mutableNotificationContent: UNMutableNotificationContent, with userInfo: [AnyHashable: Any]) -> UNMutableNotificationContent? {
        let content = mutableNotificationContent
        let rawTriggerData = userInfo["triggerData"]

        if rawTriggerData == nil {
            return content
        }

        let triggerData = TriggerData.deserialize(from: "\(rawTriggerData!)")

        if triggerData!.v == nil, triggerData!.v! >= 4.0, triggerData!.v! < 5.0 {
            NSLog("\(Constants.TAG) Unsupported payload version \(triggerData!.v!)")
            return content
        }

        if triggerData!.getPushNotification() == nil {
            EngagementTriggerHelper().loadLazyData(for: triggerData!)
            return nil
        }

        guard let pushNotification = triggerData?.getPushNotification() else {
            return content
        }

        CooeeNotificationService.sendEvent(Constants.EVENT_NOTIFICATION_RECEIVED, withTriggerData: triggerData!)

        let title: String? = getTextFromPart(from: pushNotification.getTitle())
        let subTitle: String? = getTextFromPart(from: pushNotification.getSubTitle())
        let body: String? = getTextFromPart(from: pushNotification.getBody())

        content.categoryIdentifier = "CooeeNotification"
        content.sound = UNNotificationSound.default
        content.userInfo = userInfo

        if let title = title {
            content.title = title
        }

        if let subTitle = subTitle, !subTitle.isEmpty {
            content.subtitle = subTitle
        }

        if let body = body {
            content.body = body
        }

        let image = pushNotification.getSmallImage() ?? pushNotification.getLargeImage()
        var attachments = [UNNotificationAttachment]()

        if let smallImageAttachment = getAttachment(from: image) {
            attachments.append(smallImageAttachment)
            content.attachments = attachments
        }

        sendEvent(Constants.EVENT_NOTIFICATION_VIEWED, withTriggerData: triggerData!)
        return content
    }

    /**
     Download the image from the given URL and return the UNNotificationAttachment.

     - Parameter imageURL: The URL of the image to be downloaded.
     - Returns: The UNNotificationAttachment. Nil if the image could not be downloaded.
     */
    private class func getAttachment(from imageURL: String?) -> UNNotificationAttachment? {
        guard let imageURL = imageURL, !imageURL.isEmpty else {
            return nil
        }

        guard let url = URL(string: imageURL) else {
            logSentryError("Fail to create Swift.URL from:\(imageURL)")
            return nil
        }

        guard let fileData = try? Data(contentsOf: url) else {
            logSentryError("Fail to load Data for image:\(imageURL)")
            return nil
        }

        guard let fileExtension = fileData.mimeType else {
            logSentryError("Could not determine file extension for image at URL: \(url)")
            return nil
        }

        guard let attachment = UNNotificationAttachment.create(imageFileIdentifier: "image\(fileExtension)", data: NSData(data: fileData), options: nil) else {
            logSentryError("Fail UNNotificationAttachment.create()")
            return nil
        }

        return attachment
    }

    /**
     Logs ``logMessage`` to Sentry

     - Parameter logMessage: The message to log
     */
    private static func logSentryError(_ logMessage: String) {
        CooeeFactory.shared.sentryHelper.capture(message: logMessage)
    }
}

extension UNNotificationAttachment {
    /// Save the image to disk
    static func create(imageFileIdentifier: String, data: NSData, options: [NSObject: AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        guard let tmpSubFolderURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true) else {
            return nil
        }

        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
            try data.write(to: fileURL, options: [])
            let imageAttachment = try UNNotificationAttachment(identifier: imageFileIdentifier, url: fileURL, options: options)
            return imageAttachment
        } catch {
            NSLog("\(Constants.TAG) Fail to download Attachment: \(error)")
        }

        return nil
    }
}
