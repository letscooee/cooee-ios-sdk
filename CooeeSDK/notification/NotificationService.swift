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

    init(userInfo: [AnyHashable: Any]) {
        let rawTriggerData = userInfo["triggerData"]

        if rawTriggerData == nil {
            return
        }

        let triggerData = TriggerData.deserialize(from: "\(rawTriggerData!)")

        if triggerData!.v != nil, triggerData!.v! >= 4, triggerData!.v! < 5 {
            print("Unsupported payload version")
        }
        NotificationService.sendEvent("CE Notification Recieved", withTriggerData: triggerData!)
        UNUserNotificationCenter.current().getNotificationSettings { settings in

            guard settings.authorizationStatus == .authorized else {
                return
            }
            let content = UNMutableNotificationContent()

            content.categoryIdentifier = "debitOverdraftNotification"
            content.title = triggerData?.getPushNotification()?.getTitle()?.text ?? ""
            content.body = triggerData?.getPushNotification()?.getBody()?.text ?? ""
            content.sound = UNNotificationSound.default
            content.userInfo = userInfo

            self.getMediaAttachment(for: triggerData?.getPushNotification()?.getSmallImage() ?? "") { image in
                guard let image = image, let fileURL = self.saveImageAttachment(image: image, forIdentifier: "attachment.png") else {
                    return
                }

                let attachement = try? UNNotificationAttachment(identifier: "attachment", url: fileURL, options: nil)

                content.attachments = [attachement!]

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let uuidString = UUID().uuidString
                let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

                UNUserNotificationCenter.current().add(request) { data in
                    if data == nil {
                        NotificationService.sendEvent("CE Notification Viewed", withTriggerData: triggerData!)
                    } else {
                        CooeeFactory.shared.sentryHelper.capture(error: data! as NSError)
                    }
                }
            }
        }
    }

    // MARK: Internal

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

    static func sendEvent(_ eventName: String, withTriggerData triggerData: TriggerData) {
        let event = Event(eventName: eventName, triggerData: triggerData)
        CooeeFactory.shared.safeHttpService.sendEvent(event: event)
    }

    @objc private func createTrigger(_ notification: Notification) {
        if let userData = notification.userInfo {
            print(userData)
        }
    }

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
