//
//  NotificationService.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 01/12/21.
//

import Foundation
import NotificationCenter

class NotificationService {
    // MARK: Lifecycle

    private var userInfo: [AnyHashable: Any]
    private var triggerData: TriggerData?

    init(userInfo: [AnyHashable: Any]) {
        self.userInfo = userInfo
        processPN()
    }

    // MARK: Internal

    /**
     Process <code>userInfo</code> and get <code>triggerData</code> to process PN
     */
    private func processPN() {
        let rawTriggerData = userInfo["triggerData"]

        if rawTriggerData == nil {
            return
        }

        self.triggerData = TriggerData.deserialize(from: "\(rawTriggerData!)")

        if triggerData!.v != nil, triggerData!.v! >= 4, triggerData!.v! < 5 {
            print("Unsupported payload version")
            return
        }

        let pushNotification = triggerData?.getPushNotification()

        if pushNotification == nil {
            return
        }

        NotificationService.sendEvent("CE Notification Received", withTriggerData: triggerData!)
        UNUserNotificationCenter.current().getNotificationSettings { settings in

            guard settings.authorizationStatus == .authorized else {
                return
            }
            let content = UNMutableNotificationContent()
            let title: String = self.getTextFromPart(from: pushNotification!.getTitle()?.prs ?? [PartElement]())
            let body: String = self.getTextFromPart(from: pushNotification!.getBody()?.prs ?? [PartElement]())

            content.categoryIdentifier = "debitOverdraftNotification"
            content.title = title
            content.body = body
            content.sound = UNNotificationSound.default
            content.userInfo = self.userInfo

            if pushNotification?.getSmallImage() == nil {
                self.renderPN(content)
            } else {
                self.getMediaAttachment(for: pushNotification!.getSmallImage() ?? "") { image in
                    guard let image = image, let fileURL = self.saveImageAttachment(image: image, forIdentifier: "attachment.png") else {
                        return
                    }

                    let attachment = try? UNNotificationAttachment(identifier: "image", url: fileURL, options: nil)

                    content.attachments = [attachment!]
                    self.renderPN(content)
                }
            }

        }
    }

    /**
     Create  <code>UNNotificationRequest</code> with help of <code>UNMutableNotificationContent</code> and adds that
      request to  <code>UNUserNotificationCenter</code> and sent "CE Notification Viewed" event

     - Parameter content: Instance of <code>UNMutableNotificationContent</code>
     */
    private func renderPN(_ content: UNMutableNotificationContent) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { data in
            if data == nil {
                NotificationService.sendEvent("CE Notification Viewed", withTriggerData: self.triggerData!)
            } else {
                CooeeFactory.shared.sentryHelper.capture(error: data! as NSError)
            }
        }
    }

    /**
     Create and send the event to the server
     - Parameters:
       - eventName: Name of event
       - triggerData: trigger information of event
     */
    static func sendEvent(_ eventName: String, withTriggerData triggerData: TriggerData) {
        let event = Event(eventName: eventName, triggerData: triggerData)
        CooeeFactory.shared.safeHttpService.sendEvent(event: event)
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

    /**
     Process all parts and create one string to show in PN

     - Parameter parts: list of <code>PartElement</code>
     - Returns: String
     */
    func getTextFromPart(from parts: [PartElement]) -> String {
        var string = ""
        let count = parts.count - 1

        for index in 0...count {
            string += parts[index].getPartText().trimmingCharacters(in: .newlines)
        }

        return string
    }

    // MARK: Private

    @objc private func createTrigger(_ notification: Notification) {
        if let userData = notification.userInfo {
            print(userData)
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
