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
        
        print("\(rawTriggerData!)")
        let triggerData = TriggerData.deserialize(from: "\(rawTriggerData!)")
        print("\(triggerData?.toJSON())")
        
        if triggerData!.v != nil, triggerData!.v! >= 4, triggerData!.v! < 5 {
            print("Unsupported payload version")
        }
        sendEvent("CE Notification Recieved", withTriggerData: triggerData!)
        UNUserNotificationCenter.current().getNotificationSettings { settings in
         
            // we're only going to create and schedule a notification
            // if the user has kept notifications authorized for this app
            guard settings.authorizationStatus == .authorized else { return }
                    
            // create the content and style for the local notification
            let content = UNMutableNotificationContent()
                    
            // #2.1 - "Assign a value to this property that matches the identifier
            // property of one of the UNNotificationCategory objects you
            // previously registered with your app."
            content.categoryIdentifier = "debitOverdraftNotification"
                    
            // create the notification's content to be presented
            // to the user
            content.title = triggerData?.getPushNotification()?.getTitle()?.text ?? ""
            //content.subtitle = triggerData?.getPushNotification()?.getBody()?.text ?? ""
            content.body = triggerData?.getPushNotification()?.getBody()?.text ?? ""
            content.sound = UNNotificationSound.default
            
            
            self.getMediaAttachment(for: triggerData?.getPushNotification()?.getSmallImage() ?? ""){ image in
                guard let image = image, let fileURL = self.saveImageAttachment( image: image, forIdentifier: "attachment.png") else {
                       return
                   }
                
                

                let attachement = try? UNNotificationAttachment(identifier: "attachment", url: fileURL, options: nil)
            
                content.attachments = [attachement!]
                        
                // #2.2 - create a "trigger condition that causes a notification
                // to be delivered after the specified amount of time elapses";
                // deliver after 10 seconds
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                        
                // create a "request to schedule a local notification, which
                // includes the content of the notification and the trigger conditions for delivery"
                let uuidString = UUID().uuidString
                let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                        
                // "Upon calling this method, the system begins tracking the
                // trigger conditions associated with your request. When the
                // trigger condition is met, the system delivers your notification."
                UNUserNotificationCenter.current().add(request){data in
                    print("***************\(data)")
                    self.sendEvent("CE Notification Viewed", withTriggerData: triggerData!)
                }
            }
            
        }
    }

    // MARK: Private

    private func sendEvent(_ eventName:String, withTriggerData triggerData: TriggerData){
            let event = Event(eventName: eventName, triggerData: triggerData)
        CooeeFactory.shared.safeHttpService.sendEvent(event: event)
    }
    
    @objc private func createTrigger(_ notification: Notification) {
        if let userData = notification.userInfo {
            print(userData)
        }
    }
    
    func getMediaAttachment( for urlString: String, completion: @escaping (UIImage?) -> Void) {
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
    
    private func saveImageAttachment(image: UIImage, forIdentifier identifier: String
    ) -> URL? {
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
