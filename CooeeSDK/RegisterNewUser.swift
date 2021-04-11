//
//  RegisterUser.swift
//  CooeeiOSSDK
//
//  Created by Surbhi Lath on 25/01/21.
//

import UIKit
import CoreBluetooth
import CoreLocation
//import FirebaseMessaging

public protocol InAppButtonClickDelegate {
    func getPayload(info: [String:String]?)
}

public class Cooee: NSObject{
    
    public static let shared = Cooee()
    
    let app = UserDefaults.standard
    let backgroundTimer = "backgroundTimer"
    let foregroundTimer = "foregroundTimer"
    let sessionNumberString = "sessionNumber"
    let sessionIDString = "sessionID"
    let appLaunched = "isAppLaunched"
    let sdkTokenString = "sdkToken"
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    let sdkVersion = CooeeSDKVersionNumber
    let osVersion = String(ProcessInfo().operatingSystemVersion.majorVersion) + "." + String(ProcessInfo().operatingSystemVersion.minorVersion) + "." + String(ProcessInfo().operatingSystemVersion.patchVersion)
    var keepAliveTimer = Timer()
    var buttonClickDelegate: InAppButtonClickDelegate?
    var isBTTurnedOn = "N"
    var locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var queue = OperationQueue()
    
   let operationRegisterUser = RegisterUser()

    public var screenName: String?

    private override init() {
        super.init()
//        NotificationCenter.default.addObserver(self, selector: #selector(self.updateFirebaseToken(_:)), name: NSNotification.Name(rawValue: "updateToken"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.createTrigger(_:)), name: NSNotification.Name(rawValue: "cooeeNotification"), object: nil)
        observeAppStateChanges()
        
    }

    @objc public func updateFirebaseToken(_ notification: Notification){
        if let token = notification.userInfo?["token"] as? String{
            HttpCalls.callFirebaseToken(fToken: token)
        }
    }
    
    public func fetchUDID()->String?{
        if let UDID = UserSession.getudid(){
            return UDID
        }else{
            return nil
        }
    }
    
    func fetchSessionID(){
        if UserSession.getSessionID() == nil {
            operationRegisterUser.appVersion = appVersion
            operationRegisterUser.osVersion = osVersion
            operationRegisterUser.sdkVersion = sdkVersion
            
            if !operationRegisterUser.isExecuting && !operationRegisterUser.isFinished && !queue.operations.contains(operationRegisterUser){
                queue.maxConcurrentOperationCount = 1
                queue.addOperations([operationRegisterUser], waitUntilFinished: false)
                operationRegisterUser.completionBlock = {
                    self.appIslaunched()
                    self.updateProfile(withProperties: nil, andData: nil)
                }
           }
        }
    }
    
    @objc func createTrigger(_ notification: Notification){
        if let userData = notification.userInfo{
            NotificationClass.notificationReceived(userInfo: userData)
        }
    }
    
    func observeAppStateChanges(){
        let centralManager = CBCentralManager()
        if centralManager.state == .poweredOn { isBTTurnedOn = "Y" }
       locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        UIDevice.current.isBatteryMonitoringEnabled = true
        keepAliveTimer = Timer.scheduledTimer(timeInterval: 300.0, target: self, selector: #selector(self.callKeepAlive), userInfo: nil, repeats: true)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppStateChange(notification:)), name: UIApplication.didFinishLaunchingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppStateChange(notification:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppStateChange(notification:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppStateChange(notification:)), name: UIApplication.willTerminateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppStateChange(notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func callKeepAlive(){
        let keepAliveOperation = KeepAlive()
        fetchSessionID()
        queue.addOperations([keepAliveOperation], waitUntilFinished: false)
    }
    
    func registerUser(){
        var nsDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            nsDictionary = NSDictionary(contentsOfFile: path)
            let applicationID = nsDictionary?["CooeeAppID"] as? String ?? ""
            let applicationSecretKey = nsDictionary?["CooeeSecretKey"] as? String ?? ""
            let deviceIOSData = DeviceData(os: "IOS", cooeeSdkVersion: "\(sdkVersion)", appVersion: appVersion, osVersion: osVersion)
            let registerUserData = RegisterUserDataModel(id: applicationID, secretKey: applicationSecretKey, deviceData: deviceIOSData)
            
            WService.shared.getResponse(fromURL: URLS.registerUser, method: .POST, params: registerUserData.dictionary, header: [:]) { (result: RegisterUserResponse) in
                if let token = result.sdkToken{
                    UserSession.save(userToken: token)
                }
                if let sessionID = result.sessionID{
                    UserSession.save(sessionID: sessionID)
                }
                
                if let udid = result.id{
                    UserSession.save(udid: udid)
                }
                self.appIslaunched()
                self.updateProfile(withProperties: nil, andData: nil)
                HttpCalls.callFirebaseToken(fToken: "")
            }
        }
    }
    
    @objc func handleAppStateChange(notification: NSNotification){
        switch notification.name {
        case UIApplication.didFinishLaunchingNotification:
            print("launched")
        case UIApplication.didEnterBackgroundNotification:
            print("background")
            appEnterdBackground()
        case UIApplication.willEnterForegroundNotification:
            print("foreground")
            appMovedToForeground()
        case UIApplication.willTerminateNotification:
            print("concluded")
        default:
            print("default")
        }
    }
    
    
    @objc public func sendEvent(withName: String, properties: [String: Any]){
        var sessionNumber = 1
        let list = UserSession.getTriggerData()
        var arrayTrigger = [Dictionary<String, String>]()
        if list.count>0{
            for triggerdata in list{
                let tempDict = ["triggerID": triggerdata.triggerId, "duration": triggerdata.triggerDuration]
                arrayTrigger.append(tempDict)
            }
        }
        if let temp = app.object(forKey: sessionNumberString) as? Int{
            sessionNumber = temp + 1
            app.set(sessionNumber, forKey: sessionNumberString)
        }else{
            app.set(sessionNumber, forKey: sessionNumberString)
        }
        
        var localScreenName = ""
        if let screenNameKnown = screenName{
            localScreenName = screenNameKnown
        }else if let visibleController = UIApplication.shared.topMostViewController(){
            localScreenName = NSStringFromClass(visibleController.classForCoder).components(separatedBy: ".").last ?? ""
        }
        let sessionID = UserSession.getSessionID() ?? ""
        let params = ["name": withName, "screen": localScreenName, "sessionNumber": sessionNumber, "sessionID": sessionID, "properties":properties, "activeTriggers": arrayTrigger] as [String : Any]
        let sendEventOperation = SendEvent()
        sendEventOperation.params = params
        fetchSessionID()
       queue.addOperations([sendEventOperation], waitUntilFinished: false)
    }
    
    
    public func updateProfile(withProperties: [String: Any]?,  andData: [String:Any]?){
        var propeties = [String: Any]()
        if let userProperties = withProperties{
            propeties = userProperties
        }else{
            propeties = userProperties()
        }
        
        let sendPropertiesOperation = SendUserProperties()
        sendPropertiesOperation.propeties = propeties
        sendPropertiesOperation.data = andData
        fetchSessionID()
        queue.addOperations([sendPropertiesOperation], waitUntilFinished: false)

    }
    
    func getLocation(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func userProperties()->[String: String]{
        let pointsPerInch = UIScreen.pointsPerInch ?? 0.0
        var properties = [String: String]()
        properties["CE Device Orientation"] = UIDevice.current.orientation.isLandscape ? "Landscape" : "Potrait"
        properties["CE Device Model"] = UIDevice.modelName
        properties["CE Device Manufacture"] = "Apple"
        if let locations = currentLocation{
            properties["CE Latitude"] = "\(locations.latitude)"
            properties["CE Longitude"] = "\(locations.longitude)"
        }else{
            properties["CE Latitude"] = "Unknown"
            properties["CE Longitude"] = "Unknown"
        }
        properties["CE Available Internal Memory"] = "\(UIDevice.current.freeDiskSpaceInBytes())"
        properties["CE Total Internal Memory"] = "\(UIDevice.current.totalDiskSpaceInBytes())"
        properties["CE Device Battery"] = "\(UIDevice.current.batteryLevel*100)"
        properties["CE Network Provider"] = NetworkData.shared.getCarrierName()
        properties["CE Network Type"] = NetworkData.shared.getNetworkType()
        properties["CE Bluetooth On"] = isBTTurnedOn
        properties["CE Wifi Connected"] = (NetworkData.shared.getNetworkType() == "WIFI") ? ("Y") : ("N")
        properties["CE OS"] = "IOS"
        properties["CE OS Version"] = osVersion
        properties["CE SDK Version"] = "\(sdkVersion)"
        properties["CE App Version"] = appVersion
        properties["CE Screen Resolution"] = "\(UIScreen.main.bounds.width)x\(UIScreen.main.bounds.height)"
        properties["CE Package Name"] = "\(Bundle.main.bundleIdentifier ?? "")"
        properties["CE Total RAM"] = "\(ProcessInfo.processInfo.physicalMemory/1024/1024)"
        properties["CE Available RAM"] = "\(UIDevice.current.freeRAM())"
        properties["CE DPI"] = "\(pointsPerInch)"
        
        return properties
    }
    
    func appIslaunched(){
        var properties = ["CE Source":"IOS","CE App Version": appVersion]
        
        if let _ = app.object(forKey: appLaunched) {
            sendEvent(withName: "CE App Launched", properties: properties)
        }else{
            properties["CE SDK Version"] = "\(sdkVersion)"
            properties["CE OS Version"] = osVersion
            properties["CE Network Provider"] = NetworkData.shared.getCarrierName()
            properties["CE Network Type"] = NetworkData.shared.getNetworkType()
            properties["CE Bluetooth On"] = isBTTurnedOn
            properties["CE Wifi Connected"] = (NetworkData.shared.getNetworkType() == "WIFI") ? ("Y") : ("N")
            properties["CE Device Battery"] = "\(UIDevice.current.batteryLevel*100)"
            
            sendEvent(withName: "CE App Installed", properties: properties)
            app.set("true", forKey: appLaunched)
        }
    }
    
    func appEnterdBackground(){
        let date = Date()
        app.set(date, forKey: backgroundTimer)
        
        if let date2 = app.object(forKey: foregroundTimer) as? Date{
            let difference = getTimeDifference(from: date2)
            let properties = ["CE Duration": "\(difference)"]
            sendEvent(withName: "CE App Background", properties: properties)
        }else{
            let properties = ["CE Duration": "0"]
            sendEvent(withName: "CE App Background", properties: properties)
        }
    }
    
   func appMovedToForeground() {
        let date = Date()
        app.set(date, forKey: foregroundTimer)
        
        if let date2 = app.object(forKey: backgroundTimer) as? Date{
            let difference = getTimeDifference(from: date2)
            if difference>=30{
                concludeSession(with: difference)
            }else{
                let properties = ["CE Duration": "\(difference)"]
                sendEvent(withName: "CE App Foreground", properties: properties)
            }
        }else{
            let properties = ["CE Duration": "0"]
            sendEvent(withName: "CE App Foreground", properties: properties)
        }
    }
    
    func concludeSession(with duration: Int){
        let operationConcludeSession = ConcludeSession()
        operationConcludeSession.duration = duration
        fetchSessionID()
        queue.addOperations([operationConcludeSession], waitUntilFinished: false)
  }
    
    func getTimeDifference(from time: Date)-> Int{
        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        let nowComponents = calendar.dateComponents([.hour, .minute], from: Date())
        let difference = calendar.dateComponents([.minute], from: timeComponents, to: nowComponents).minute!
        return difference
    }
}


enum AppStates: String{
    case launched = "CE App Launched"
    case installed = "CE App Installed"
    case foreground = "CE App Foreground"
    case background = "CE App Background"
    case terminated = "CE Session Concluded"
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController?.topMostViewController()
    }
}

extension UIViewController {
    func topMostViewController() -> UIViewController? {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? nil
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}

extension Cooee: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {

    }
}
extension Cooee: CLLocationManagerDelegate{
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate
        else { return }
        currentLocation = locValue
    }
}

//extension RegisterUser: MessagingDelegate{
//    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        print("Firebase registration token: \(fcmToken ?? "")")
//        HttpCalls.callFirebaseToken(fToken: fcmToken ?? "")
//    }
//}
class RegisterUser: AbstractOperation{
    var sdkVersion = 0.0
    var osVersion = ""
    var appVersion = ""
   
    override open func main() {
            if isCancelled {
                finish()
                return
            }
            
        var nsDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            nsDictionary = NSDictionary(contentsOfFile: path)
            let applicationID = nsDictionary?["CooeeAppID"] as? String ?? ""
            let applicationSecretKey = nsDictionary?["CooeeSecretKey"] as? String ?? ""
            let deviceIOSData = DeviceData(os: "IOS", cooeeSdkVersion: "\(sdkVersion)", appVersion: appVersion, osVersion: osVersion)
            let registerUserData = RegisterUserDataModel(id: applicationID, secretKey: applicationSecretKey, deviceData: deviceIOSData)
            
            WService.shared.getResponse(fromURL: URLS.registerUser, method: .POST, params: registerUserData.dictionary, header: [:]) { (result: RegisterUserResponse) in
                if let token = result.sdkToken{
                    UserSession.save(userToken: token)
                }
                if let sessionID = result.sessionID{
                    UserSession.save(sessionID: sessionID)
                }
                
                if let udid = result.id{
                    UserSession.save(udid: udid)
                }
                self.finish()
               
            }
        }
        
        }
    
}
