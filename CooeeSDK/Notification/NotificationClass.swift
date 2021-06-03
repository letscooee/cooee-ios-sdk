//
//  NotificationClass.swift
//  CooeeSDK
//
//  Created by Surbhi Lath on 27/03/21.
//

import UIKit

public class NotificationClass: NSObject{
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    var payloadData: TriggerData?
    private let actionIdentifier = "Read"
    public static let shared = NotificationClass()
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    @objc func notificationReceived(userInfo: [AnyHashable: Any]){
       
        if let stringData = userInfo["triggerData"] as? String {
            guard let data = stringData.data(using: String.Encoding.utf8, allowLossyConversion: false)
            else { return }
            do {
                let decodedResponse = try JSONDecoder().decode(TriggerData.self, from: data)
                callNotificationReceived(ofType: "CE Notification Received", triggerId: decodedResponse.id)
                if let visibleController = UIApplication.shared.topMostViewController(){
                    if !decodedResponse.showAsPN{
                        CustomPopup.instance.updateViewWith(data: decodedResponse, on: visibleController)
                    }else{
                        CustomPopup.instance.updateViewWith(data: decodedResponse, on: visibleController)
                        createLocalNotification(with: decodedResponse)
                    }
                }
            }catch{
                print(error)
            }
        }
    }

    func callNotificationReceived(ofType: String, triggerId: String){
        var eventProps = [String: Any]()
        eventProps["Trigger ID"] = triggerId
        let registerUserInstance = Cooee.shared
        registerUserInstance.sendEvent(withName: ofType, properties: eventProps)
    }
    
    func createLocalNotification(with payload: TriggerData){
       
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = payload.title.notificationText
        notificationContent.body = payload.message.notificationText
        
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        
        var actions = [UNNotificationAction]()
        for action in payload.buttons{
            let temp = UNNotificationAction(identifier: actionIdentifier, title: action.text , options: [])
            actions.append(temp)
        }
        
       // Add action category
        let category = UNNotificationCategory(identifier: "Notification.category", actions: actions, intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        // Add action category identifier to content
        notificationContent.categoryIdentifier = "Notification.category"
        
        if payload.type == .IMAGE{
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
                if let soundURL = payload.sound {
                    self.checkAudioFileExists(withLink: soundURL){ soundFileURL in
                        let stringName = soundFileURL.absoluteString
                        notificationContent.sound = UNNotificationSound(named: UNNotificationSoundName(stringName))
                    }
                }
                // Create Notification Request
                let notificationRequest = UNNotificationRequest(identifier: payload.id, content: notificationContent, trigger: notificationTrigger)
                UNUserNotificationCenter.current().add(notificationRequest) { (error) in
                    if let error = error {
                        print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
                    }
                }
            }
         }
        }else{
            let notificationRequest = UNNotificationRequest(identifier: payload.id, content: notificationContent, trigger: notificationTrigger)
            UNUserNotificationCenter.current().add(notificationRequest) { (error) in
                if let error = error {
                    print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
                }
            }
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
    
    func sendNotificationCloseEvent(){
//        var eventProps = [String: Any]()
//        eventProps["Duration"] = calculateTriggerDuration()
//        eventProps["Close Behaviour"] = closeBehaviour.rawValue
//        eventProps["triggerID"] = layoutaData?.id
//        
//        if layoutaData!.type == .VIDEO {
//            if let player = videoPlayer{
//                eventProps["Video Duration"] = player.duration
//                eventProps["Watched Till"] = player.watchedTill
//                eventProps["Total Watched"] = calculateTimeForVideo()
//                eventProps["Video Unmuted"] = !player.isMute
//            }
//        }
//        
//        print(eventProps)
//        let registerUserInstance = Cooee.shared
//        registerUserInstance.sendEvent(withName: "CE Notification Closed", properties: eventProps)
    }
    
}

extension NotificationClass: UNUserNotificationCenterDelegate{
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let stringData = userInfo["triggerData"] as? String {
            guard let data = stringData.data(using: String.Encoding.utf8, allowLossyConversion: false)
            else { return }
            do {
                let decodedResponse = try JSONDecoder().decode(TriggerData.self, from: data)
                callNotificationReceived(ofType: "CE Notification Viewed", triggerId: decodedResponse.id)
                switch response.actionIdentifier {
                case actionIdentifier:
                    callNotificationReceived(ofType: "CE PN Action Click", triggerId: decodedResponse.id)
                default:
                    print("Other Action")
                }
            }catch{
                print(error)
            }
        }
        completionHandler()
        
        
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("will present framework")
        completionHandler([.badge,.banner,.list, .sound])
    }
}

extension NotificationClass{
    func checkAudioFileExists(withLink link: String, completion: @escaping ((_ filePath: URL)->Void)){
        let urlString = link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if let url  = URL.init(string: urlString ?? ""){
            let fileManager = FileManager.default
            if let documentDirectory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create: false){
                
                let filePath = documentDirectory.appendingPathComponent(url.lastPathComponent, isDirectory: false)
                
                do {
                    if try filePath.checkResourceIsReachable() {
                        print("file exist")
                        completion(filePath)
                        
                    } else {
                        print("file doesnt exist")
                        downloadFile(withUrl: url, andFilePath: filePath, completion: completion)
                    }
                } catch {
                    print("file doesnt exist")
                    downloadFile(withUrl: url, andFilePath: filePath, completion: completion)
                }
            }else{
                print("file doesnt exist")
            }
        }else{
            print("file doesnt exist")
        }
    }
    
    func downloadFile(withUrl url: URL, andFilePath filePath: URL, completion: @escaping ((_ filePath: URL)->Void)){
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data.init(contentsOf: url)
                try data.write(to: filePath, options: .atomic)
                print("saved at \(filePath.absoluteString)")
                DispatchQueue.main.async {
                    completion(filePath)
                }
            } catch {
                print("an error happened while downloading or saving the file")
            }
        }
    }
    
}
