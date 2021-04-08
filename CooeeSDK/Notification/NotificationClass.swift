//
//  NotificationClass.swift
//  CooeeSDK
//
//  Created by Surbhi Lath on 27/03/21.
//

import UIKit

public class NotificationClass: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    var payloadData: TriggerData?
    
    @objc static func notificationReceived(userInfo: [AnyHashable: Any]){
        if let stringData = userInfo["triggerData"] as? String {
            guard let data = stringData.data(using: String.Encoding.utf8, allowLossyConversion: false)
            else { return }
                   do {
                        let decodedResponse = try JSONDecoder().decode(TriggerData.self, from: data)

                        if let visibleController = UIApplication.shared.topMostViewController(){
                            if !decodedResponse.showAsPN{
                                CustomPopup.instance.updateViewWith(data: decodedResponse, on: visibleController)
                            }else{
                                createLocalNotification(with: decodedResponse)
                            }
                        }
                    }catch{
                        print(error)
                    }
           
        }
    }
    
    static func createLocalNotification(with payload: TriggerData){
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = payload.title.text
        notificationContent.body = payload.message.text
        notificationContent.badge = 1
       
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)

        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: payload.id, content: notificationContent, trigger: notificationTrigger)
        
        var actions = [UNNotificationAction]()
        for action in payload.buttons{
            let temp = UNNotificationAction(identifier: action.text, title: action.text, options: [])
            actions.append(temp)
        }
        let category = UNNotificationCategory(identifier: "Random", actions: actions, intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    
        getMediaAttachment(for: payload.imageURL) { image in
            
            guard let image = image, let fileURL = self.saveImageAttachment( image: image, forIdentifier: "attachment.png") else {
               return
            }
            let imageAttachment = try? UNNotificationAttachment(
                identifier: "image",
                url: fileURL,
                options: nil)
            if let imageAttachment = imageAttachment {
                notificationContent.attachments = [imageAttachment]
                notificationContent.categoryIdentifier = "Random"

                UNUserNotificationCenter.current().add(notificationRequest) { (error) in
                    if let error = error {
                        print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
                    }
                }
            }
            
        }
       
    }
    
    public override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified1]"
          if let triggerData = bestAttemptContent.userInfo["data"] {
                if let dictData = triggerData as? [String: Any]{
                    do {
                        let jsonResult =  try JSONSerialization.data(withJSONObject: dictData)
                        do {
                            let decodedResponse = try JSONDecoder().decode(DataClass.self, from: jsonResult)
                            
                            //                            if let visibleController = UIApplication.shared.topMostViewController(){
                            //                                if !decodedResponse.triggerData.showAsPN{
                            //                                    CustomPopup.instance.updateViewWith(data: decodedResponse.triggerData, on: visibleController)
                            //                                }
                            //                            }
                            
                            self.payloadData = decodedResponse.triggerData
                            if let mainData = payloadData{
                                bestAttemptContent.title = mainData.title.text
                                bestAttemptContent.body = mainData.message.text
//                                getMediaAttachment(for: mainData.imageURL) { [weak self] image in
//
//                                    guard let self = self, let image = image, let fileURL = self.saveImageAttachment( image: image, forIdentifier: "attachment.png") else {
//                                        contentHandler(bestAttemptContent)
//                                        return
//                                    }
//                                    let imageAttachment = try? UNNotificationAttachment(
//                                        identifier: "image",
//                                        url: fileURL,
//                                        options: nil)
//                                    if let imageAttachment = imageAttachment {
//                                        bestAttemptContent.attachments = [imageAttachment]
//                                    }
//                                    contentHandler(bestAttemptContent)
//
//                                }
                            }
                            
                        }catch{
                            print(error)
                        }
                    }catch{
                        print (error)
                    }
                }
            }
            contentHandler(bestAttemptContent)
        }
    }
    
    
    static func getMediaAttachment( for urlString: String, completion: @escaping (UIImage?) -> Void) {
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
    
    static private func saveImageAttachment(image: UIImage, forIdentifier identifier: String
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

