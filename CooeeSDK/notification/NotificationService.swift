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
        processPN()
    }

    // MARK: Public

    /**
     This method Updates Notification content and returns data back to extension.

     - Parameters:
       - mutableNotificationContent: MutableNotificationContent object which is used to update notification content
       - userInfo: userInfo dictionary which is passed from notification
     - Returns: MutableNotificationContent object which has updated content
     */
    @available(*, deprecated, renamed: "updateContentFromRequest(_:)")
    @objc
    public static func updateContent(_ mutableNotificationContent: UNMutableNotificationContent, with userInfo: [AnyHashable: Any]) -> UNMutableNotificationContent? {
        updateNotificationContent(mutableNotificationContent, with: userInfo)
    }

    /**
     This method Updates Notification content and returns data back to extension.

     - Parameter request: UNNotificationRequest object which is used to update notification content
     - Returns: MutableNotificationContent object which has updated content
     */
    @objc
    public static func updateContentFromRequest(_ request: UNNotificationRequest) -> UNMutableNotificationContent? {
        var userInfo = request.content.userInfo
        userInfo["notificationID"] = request.identifier
        return updateNotificationContent((request.content.mutableCopy() as! UNMutableNotificationContent), with: userInfo)
    }

    /**
     This method Updates Notification content and returns data back to extension.

     - Parameters:
       - mutableNotificationContent: MutableNotificationContent object which is used to update notification content
       - userInfo: userInfo dictionary which is passed from notification
     - Returns: MutableNotificationContent object which has updated content
     */
    private static func updateNotificationContent(_ mutableNotificationContent: UNMutableNotificationContent, with userInfo: [AnyHashable: Any]) -> UNMutableNotificationContent? {
        NSLog("*** posted")
        let content = mutableNotificationContent
        let rawTriggerData = userInfo["triggerData"]

        if rawTriggerData == nil {
            return content
        }

        let triggerData = TriggerData.deserialize(from: "\(rawTriggerData!)")

        if triggerData!.v == nil, triggerData!.v! >= 4.0, triggerData!.v! < 5.0 {
            NSLog("Unsupported payload version \(triggerData!.v!)")
            return content
        }

        if triggerData!.getPushNotification() == nil {
            EngagementTriggerHelper().loadLazyData(for: triggerData!)
            return nil
        }

        guard let pushNotification = triggerData?.getPushNotification() else {
            return content
        }

        CooeeNotificationService.sendEvent("CE Notification Received", withTriggerData: triggerData!)

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

        let smallImage = pushNotification.getSmallImage()
        let largeImage = pushNotification.getLargeImage()

        if smallImage?.isEmpty ?? true && largeImage?.isEmpty ?? true {
            sendEvent("CE Notification Viewed", withTriggerData: triggerData!)
            return content
        } else {
            var attachments = [UNNotificationAttachment]()
            if let smallImageAttachment = getAttachment(from: smallImage) {
                attachments.append(smallImageAttachment)
            }

            if let largeImageAttachment = getAttachment(from: largeImage) {
                attachments.append(largeImageAttachment)
            }

            content.attachments = attachments
            sendEvent("CE Notification Viewed", withTriggerData: triggerData!)
            return content
        }
    }

    // MARK: Internal


/**
     Download the image from the given URL and return the UNNotificationAttachment.

     - Parameter imageURL: The URL of the image to be downloaded.
     - Returns: The UNNotificationAttachment. Nil if the image could not be downloaded.
     */
    private class func getAttachment(from imageURL: String?) -> UNNotificationAttachment? {
        if imageURL == nil {
            return nil
        }

        guard let url = URL(string: imageURL!) else {
            return nil
        }

        guard let imageData = NSData(contentsOf: url) else {
            return nil
        }

        guard let attachment = UNNotificationAttachment.create(imageFileIdentifier: "image.jpg", data: imageData, options: nil) else {
            NSLog("Error in UNNotificationAttachment.create()")
            return nil
        }

        return attachment
    }

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

    static func addPendingNotification(_ notificationContent: UNMutableNotificationContent, _ triggerData: TriggerData) {
        CooeeNotificationService.triggerData = triggerData
        pendingNotificationContent = notificationContent
    }

    static func processPendingNotification() {
        if pendingNotificationContent == nil {
            return
        }

        renderPN(pendingNotificationContent!, silent: true)

        pendingNotificationContent = nil
    }

    /**
     Requests <code>ImageDownloader</code> to download Image from URL

     - Parameters:
         - urlString: Web URL of Image
         - completion: provide UIImage
     */
    func getMediaAttachment(for urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        ImageDownloader.shared.downloadImage(forURL: url) { result in
            guard let image = try? result.get() else {
                completion(nil)
                return
            }
            completion(image)
        }
    }

    // MARK: Private

    private static var pendingNotificationContent: UNMutableNotificationContent?
    private static var triggerData: TriggerData?

    private var userInfo: [AnyHashable: Any]

    private static func showInAppNotification(_ content: UNMutableNotificationContent, _ image: UIImage?) {
        DispatchQueue.main.async {
            let vc = InAppNotification()
            vc.notificationContent = content
            vc.triggerData = CooeeNotificationService.triggerData
            vc.image = image
            vc.modalPresentationStyle = .overCurrentContext

            if let visibleController = UIApplication.shared.topMostViewController() {
                visibleController.present(vc, animated: false, completion: nil)
            }
        }
    }

    /**
     Create  <code>UNNotificationRequest</code> with help of <code>UNMutableNotificationContent</code> and adds that
      request to  <code>UNUserNotificationCenter</code> and sent "CE Notification Viewed" event

     - Parameter content: Instance of <code>UNMutableNotificationContent</code>
     - Parameter image: Image to be shown in Notification
     - Parameter silent: If true, the notification will not be shown in the notification center.
     */
    private static func renderPN(_ content: UNMutableNotificationContent, _ image: UIImage? = nil, silent: Bool = false) {
        let isForeground = CooeeFactory.shared.runtimeData.isInForeground()

        if isForeground {
            showInAppNotification(content, image)
            return
        }

        if silent {
            content.sound = nil
        }

        let trigger = silent ? UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) : UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { data in
            if !silent {
                if data == nil {
                    CooeeNotificationService.sendEvent("CE Notification Viewed", withTriggerData: triggerData!)
                } else {
                    CooeeFactory.shared.sentryHelper.capture(error: data! as NSError)
                }
            }
        }
    }

    /**
     Process <code>userInfo</code> and get <code>triggerData</code> to process PN
     */
    private func processPN() {
        let rawTriggerData = userInfo["triggerData"]

        if rawTriggerData == nil {
            return
        }

        CooeeNotificationService.triggerData = TriggerData.deserialize(from: "\(rawTriggerData!)")

        if CooeeNotificationService.triggerData!.v == nil, CooeeNotificationService.triggerData!.v! >= 4.0, CooeeNotificationService.triggerData!.v! < 5.0 {
            NSLog("Unsupported payload version: v\(CooeeNotificationService.triggerData!.v!)")
            return
        }

        if CooeeNotificationService.triggerData!.getPushNotification() == nil {
            EngagementTriggerHelper().loadLazyData(for: CooeeNotificationService.triggerData!)
            return
        }

        guard let pushNotification = CooeeNotificationService.triggerData?.getPushNotification() else {
            return
        }

        CooeeNotificationService.sendEvent("CE Notification Received", withTriggerData: CooeeNotificationService.triggerData!)

        UNUserNotificationCenter.current().getNotificationSettings { settings in

            guard settings.authorizationStatus == .authorized else {
                return
            }

            let content = UNMutableNotificationContent()
            let title: String = CooeeNotificationService.getTextFromPart(from: pushNotification.getTitle()) ?? ""
            let body: String = CooeeNotificationService.getTextFromPart(from: pushNotification.getBody()) ?? ""

            content.categoryIdentifier = "COOEENOTIFICATION"
            content.title = title
            content.body = body
            content.sound = UNNotificationSound.default
            content.userInfo = self.userInfo

            if pushNotification.getSmallImage() == nil {
                CooeeNotificationService.renderPN(content)
            } else {
                self.getMediaAttachment(for: pushNotification.getSmallImage() ?? "") { image in
                    guard let image = image, let fileURL = self.saveImageAttachment(image: image, forIdentifier: "attachment.png") else {
                        return
                    }

                    let attachment = try? UNNotificationAttachment(identifier: "image", url: fileURL, options: nil)

                    content.attachments = [attachment!]
                    CooeeNotificationService.renderPN(content, image)
                }
            }
        }
    }

    /**
     Saves given UIImage to the temporary folder on device

     - Parameters:
       - image: instance of UIIMage
       - identifier: Name of the file to be used as identifier of file
     - Returns: Path URL of image at storage
     */
    private func saveImageAttachment(image: UIImage, forIdentifier identifier: String) -> URL? {
        let tempDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
        let directoryPath = tempDirectory.appendingPathComponent(
                ProcessInfo.processInfo.globallyUniqueString,
                isDirectory: true)

        do {
            try FileManager.default.createDirectory(
                    at: directoryPath,
                    withIntermediateDirectories: true,
                    attributes: nil)

            let fileURL = directoryPath.appendingPathComponent(identifier)

            guard let imageData = image.pngData() else {
                return nil
            }

            try imageData.write(to: fileURL)
            return fileURL
        } catch {
            return nil
        }
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
            NSLog("Fail to download Attachment: \(error)")
        }

        return nil
    }
}
