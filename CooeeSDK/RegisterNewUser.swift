//
//  RegisterUser.swift
//  CooeeiOSSDK
//
//  Created by Surbhi Lath on 25/01/21.
//

import UIKit
import CoreBluetooth
import CoreLocation
import Firebase
import Sentry
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
    let sdkVersion = Bundle(identifier: "com.Wizpanda.CooeeSDK")?.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    let osVersion = String(ProcessInfo().operatingSystemVersion.majorVersion) + "." + String(ProcessInfo().operatingSystemVersion.minorVersion) + "." + String(ProcessInfo().operatingSystemVersion.patchVersion)
    var keepAliveTimer = Timer()
    var buttonClickDelegate: InAppButtonClickDelegate?
    var isBTTurnedOn = false
    var locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var queue = OperationQueue()
    let operationRegisterUser = RegisterUser()
    public var delegate: GetTriggerData?
    public var screenName: String?
    public var appDelegateInstance: UIApplicationDelegate?
    private override init() {
        super.init()
        NetworkMonitor.shared.startMonitoring()
        Messaging.messaging().delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.triggerDataReceived(_:)), name: NSNotification.Name(rawValue: "buttonClickListener"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.createTrigger(_:)), name: NSNotification.Name(rawValue: "cooeeNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkConnected(_:)), name: NSNotification.Name(rawValue: "networkConnected"), object: nil)
        if UIApplication.shared.delegate != nil {
              
        }
        observeAppStateChanges()
    }
    
    @objc func triggerDataReceived(_ notification: Notification){
        if let data = notification.userInfo as? [String: Any]{
            delegate?.tiggerData(data: data)
        }
    }
    
    @objc public func updateFirebaseToken(_ notification: Notification){
        if let token = notification.userInfo?["token"] as? String{
            HttpCalls.callFirebaseToken(fToken: token)
        }
    }
    
    @objc public func networkConnected(_ notification: Notification){
        if NetworkMonitor.shared.isConnected{
            WService.shared.retry()
        }
    }
    
    public func fetchUDID()->String?{
        if let UDID = UserSession.getudid(){
            return UDID
        }else{
            return nil
        }
    }
    
    func fetchSessionID(nextOperation: AbstractOperation?){
        if UserSession.getSessionID() == nil {
            operationRegisterUser.appVersion = appVersion
            operationRegisterUser.osVersion = osVersion
            operationRegisterUser.sdkVersion = sdkVersion
            if let op2 = nextOperation{
                op2.addDependency(operationRegisterUser)
            }
            if !operationRegisterUser.isExecuting && !operationRegisterUser.isFinished && !queue.operations.contains(operationRegisterUser){
                 queue.addOperations([operationRegisterUser], waitUntilFinished: false)
                
                self.appIslaunched()
            }
        }
    }
    
    @objc func createTrigger(_ notification: Notification){
        if let userData = notification.userInfo{
            let instance = NotificationClass.shared
            instance.notificationReceived(userInfo: userData)
        }
    }
    
    func observeAppStateChanges(){
        let centralManager = CBCentralManager()
        if centralManager.state == .poweredOn { isBTTurnedOn = true }
        getLocation()
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
        fetchSessionID(nextOperation: keepAliveOperation)
        queue.addOperations([keepAliveOperation], waitUntilFinished: false)
    }
    
    @objc func handleAppStateChange(notification: NSNotification){
        switch notification.name {
        case UIApplication.didFinishLaunchingNotification:
            print("launched")
            appIslaunched()
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
        let arrayTrigger = getActiveTriggers()
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
        fetchSessionID(nextOperation: sendEventOperation)
        queue.addOperations([sendEventOperation], waitUntilFinished: false)
    }
    
    
    public func updateProfile(withProperties: [String: Any]?,  andData: [String:Any]?){
        updateSentryUser(userData: andData)
        let sendPropertiesOperation = SendUserProperties()
        sendPropertiesOperation.propeties = withProperties
        sendPropertiesOperation.data = andData
        fetchSessionID(nextOperation: sendPropertiesOperation)
        queue.addOperations([sendPropertiesOperation], waitUntilFinished: false)
    }
    
    func getActiveTriggers()->[[String: String]]{
        let list = UserSession.getTriggerData()
        var arrayTrigger = [[String: String]]()
        if list.count>0{
            for triggerdata in list{
                let calendar = Calendar.current
                let date = calendar.date(byAdding: .second, value: Int(triggerdata.triggerDuration) ?? 0, to: triggerdata.receivedOn ?? Date()) ?? Date()
                if date >= Date(){
                    let tempDict = ["triggerID": triggerdata.triggerId, "duration": triggerdata.triggerDuration]
                    arrayTrigger.append(tempDict)
                }
                
            }
        }
        return arrayTrigger
    }
    
    func getLocation(){
        if CLLocationManager.locationServicesEnabled() {
          switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                   print("No access")
            case .authorizedAlways, .authorizedWhenInUse :
                currentLocation = locationManager.location?.coordinate
            @unknown default:
                print("No access")
            }
        }
    }
    
    func userProperties()->[String: Any]{
        let pointsPerInch = UIScreen.pointsPerInch ?? 0.0
        var properties = [String: Any]()
        properties["CE Device Orientation"] = UIDevice.current.orientation.isLandscape ? "Landscape" : "Potrait"
        properties["CE Device Model"] = UIDevice.modelName
        properties["CE Device Manufacture"] = "Apple"
        if let locations = currentLocation{
            properties["CE Latitude"] = locations.latitude
            properties["CE Longitude"] = locations.longitude
        }else{
            properties["CE Latitude"] = "Unknown"
            properties["CE Longitude"] = "Unknown"
        }
        properties["CE Available Internal Memory"] = UIDevice.current.freeDiskSpaceInBytes()
        properties["CE Total Internal Memory"] = UIDevice.current.totalDiskSpaceInBytes()
        properties["CE Device Battery"] = UIDevice.current.batteryLevel*100
        properties["CE Network Provider"] = NetworkData.shared.getCarrierName()
        properties["CE Network Type"] = NetworkData.shared.getNetworkType()
        properties["CE Bluetooth On"] = isBTTurnedOn
        properties["CE Wifi Connected"] = (NetworkData.shared.getNetworkType() == "WIFI") ? true : false
        properties["CE OS"] = "IOS"
        properties["CE OS Version"] = osVersion
        properties["CE SDK Version"] = sdkVersion
        properties["CE App Version"] = appVersion
        properties["CE Screen Resolution"] = "\(UIScreen.main.bounds.width)x\(UIScreen.main.bounds.height)"
        properties["CE Package Name"] = "\(Bundle.main.bundleIdentifier ?? "")"
        properties["CE Total RAM"] = ProcessInfo.processInfo.physicalMemory/1024/1024
        properties["CE Available RAM"] = UIDevice.current.freeRAM()
        properties["CE DPI"] = pointsPerInch
        return properties
    }
    
    func appIslaunched(){
        configureSentry()
        var properties = ["CE Source":"IOS","CE App Version": appVersion] as [String: Any]
        
        if let _ = app.object(forKey: appLaunched) {
            sendEvent(withName: "CE App Launched", properties: properties)
            self.updateProfile(withProperties: userProperties(), andData: nil)
        }else{
            properties["CE SDK Version"] = sdkVersion
            properties["CE OS Version"] = osVersion
            properties["CE Network Provider"] = NetworkData.shared.getCarrierName()
            properties["CE Network Type"] = NetworkData.shared.getNetworkType()
            properties["CE Bluetooth On"] = isBTTurnedOn
            properties["CE Wifi Connected"] = (NetworkData.shared.getNetworkType() == "WIFI") ? true : false
            properties["CE Device Battery"] = UIDevice.current.batteryLevel*100
            
            sendEvent(withName: "CE App Installed", properties: properties)
            app.set("true", forKey: appLaunched)
        }
        
    }
    
    func configureSentry(){
        SentrySDK.start { options in
               options.dsn = "https://93ac02d69b4043c59fe6fd088ea93d53@o559187.ingest.sentry.io/5698931"
               options.debug = true // Enabled debug when first installing is always helpful
           }
        SentrySDK.configureScope { scope in
            var  applicationID = ""
            if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
                let nsDictionary = NSDictionary(contentsOfFile: path)
                applicationID = nsDictionary?["CooeeAppID"] as? String ?? ""
            }
            scope.setTag(value:Bundle.main.bundleIdentifier ?? "", key:"client.appPackage")
            scope.setTag(value: self.appVersion, key: "client.appVersion")
            scope.setTag(value: Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "" , key: "client.appName")
            scope.setTag(value: applicationID, key: "client.appId")
            let user = User()
            user.userId = self.fetchUDID() ?? ""
            #if DEBUG
            scope.setTag(value: "debug", key:  "buildType")
            #else
            scope.setTag(value: "release", key: "buildType")
            #endif
        }
    }
    
    func updateSentryUser(userData:[String: Any]?){
        if let data = userData{
            SentrySDK.configureScope { scope in
                let user = User()
                user.userId = self.fetchUDID() ?? ""
                if let name = data["name"] as? String{
                    user.username = name
                }
                
                if let email = data["email"] as? String{
                    user.email = email
                }
                
                if let mobile = data["mobile"]{
                    user.data = ["mobile": mobile]
                }
            }
        }
    }
    
    func appEnterdBackground(){
        let date = Date()
        app.set(date, forKey: backgroundTimer)
        
        if let date2 = app.object(forKey: foregroundTimer) as? Date{
            let difference = getTimeDifference(from: date2)
            let properties = ["CE Duration": difference]
            sendEvent(withName: "CE App Background", properties: properties)
        }else{
            let properties = ["CE Duration": 0]
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
                let properties = ["CE Duration": difference]
                sendEvent(withName: "CE App Foreground", properties: properties)
            }
        }else{
            let properties = ["CE Duration": 0]
            sendEvent(withName: "CE App Foreground", properties: properties)
        }
    }
    
    func concludeSession(with duration: Int){
        let operationConcludeSession = ConcludeSession()
        operationConcludeSession.duration = duration
        fetchSessionID(nextOperation: operationConcludeSession)
        queue.addOperations([operationConcludeSession], waitUntilFinished: false)
    }
    
    func getTimeDifference(from time: Date)-> Int{
        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        let nowComponents = calendar.dateComponents([.hour, .minute], from: Date())
        let difference = calendar.dateComponents([.minute], from: timeComponents, to: nowComponents).minute!
        return difference
    }
    
    func saveOpertaion(){
        
    }
}


enum AppStates: String{
    case launched = "CE App Launched"
    case installed = "CE App Installed"
    case foreground = "CE App Foreground"
    case background = "CE App Background"
    case terminated = "CE Session Concluded"
}


extension Cooee: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
    }
}

extension Cooee: MessagingDelegate{
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token framework: \(fcmToken ?? "" )")
        let operationFirebaseToken = UpdateFirebaseToken()
        operationFirebaseToken.fcmToken = fcmToken ?? ""
        fetchSessionID(nextOperation: operationFirebaseToken)
        queue.addOperations([operationFirebaseToken], waitUntilFinished: false)
    }

}

public protocol GetTriggerData{
    func tiggerData(data: [String: Any])
}

extension Cooee: UIApplicationDelegate{
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("didReceiveRemoteNotification")
    }
}
