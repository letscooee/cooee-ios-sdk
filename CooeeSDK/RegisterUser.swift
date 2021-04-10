//
//  RegisterUser.swift
//  CooeeiOSSDK
//
//  Created by Surbhi Lath on 25/01/21.
//

import UIKit
import CoreBluetooth
import CoreLocation

public class RegisterNewUser: NSObject{
    
    public override init() {}
    public static let shared = RegisterNewUser()
    
    let app = UserDefaults.standard
    let backgroundTimer = "backgroundTimer"
    let foregroundTimer = "foregroundTimer"
    let sessionNumberString = "sessionNumber"
    let sessionIDString = "sessionID"
    let appLaunched = "isAppLaunched"
    let sdkTokenString = "sdkToken"
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    let sdkVersion = "1"
    let osVersion = String(ProcessInfo().operatingSystemVersion.majorVersion) + "." + String(ProcessInfo().operatingSystemVersion.minorVersion) + "." + String(ProcessInfo().operatingSystemVersion.patchVersion)
    var keepAliveTimer = Timer()
    var fToken = ""
    var isBTTurnedOn = "Off"
    var locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    public func setup(firebaseToken: String){
        fToken = firebaseToken
        getConfigData()
        observeAppStateChanges()
    }
    
    public func observeAppStateChanges(){
        let centralManager = CBCentralManager(delegate: self, queue: nil)
        if centralManager.state == .poweredOn { isBTTurnedOn = "On" }
       locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        UIDevice.current.isBatteryMonitoringEnabled = true
        keepAliveTimer = Timer.scheduledTimer(timeInterval: 300.0, target: self, selector: #selector(callKeepAlive), userInfo: nil, repeats: true)
        NotificationCenter.default.addObserver(forName: UIApplication.didFinishLaunchingNotification, object: nil, queue: nil, using: handleAppStateChange)
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil, using: handleAppStateChange)
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil, using: handleAppStateChange)
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: nil, using: handleAppStateChange)
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil, using: handleAppStateChange)
    }
    
    
    public func getConfigData(){
        var nsDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            nsDictionary = NSDictionary(contentsOfFile: path)
            let applicationID = nsDictionary?["CooeeAppID"] as? String ?? ""
            let applicationSecretKey = nsDictionary?["CooeeSecretKey"] as? String ?? ""
            let deviceIOSData = DeviceData(os: "IOS", cooeeSdkVersion: "\(1)", appVersion: appVersion, osVersion: osVersion)
            let registerUserData = RegisterUserDataModel(id: applicationID, secretKey: applicationSecretKey, deviceData: deviceIOSData)
            
            WService.shared.getResponse(fromURL: URLS.registerUser, method: .POST, params: registerUserData.dictionary, header: [:]) { (result: RegisterUserResponse) in
                if let token = result.sdkToken{
                    UserSession.save(userToken: token)
                }
                if let sessionID = result.sessionID{
                    UserSession.save(sessionID: sessionID)
                }
                self.appIslaunched()
                self.callUpdateProfile()
                self.callFirebaseToken()
            }
        }
    }
    
    public func handleAppStateChange(notification: Notification){
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
    
    
    @objc func manageForEventTrack(with eventName: String, properties: [String: String]){
        var sessionNumber = 1
        if let temp = app.object(forKey: sessionNumberString) as? Int{
            sessionNumber = temp + 1
            app.set(sessionNumber, forKey: sessionNumberString)
        }else{
            app.set(sessionNumber, forKey: sessionNumberString)
        }
        var screenName = ""
        if let visibleController = UIApplication.shared.topMostViewController(){
            screenName = NSStringFromClass(visibleController.classForCoder).components(separatedBy: ".").last ?? ""
        }
        let sessionID = UserSession.getSessionID() ?? ""
            let params = ["name": eventName, "screen": screenName, "sessionNumber": sessionNumber, "sessionID": sessionID, "properties":properties] as [String : Any]
            callEventTrack(with: params)
    }
    
    public func callEventTrack(with params: Dictionary<String, Any>){
        let token = UserSession.getUserToken() ?? ""

        WService.shared.getResponse(fromURL: URLS.trackEvent, method: .POST, params: params, header: ["x-sdk-token":token]) { (result: TrackEventResponse) in
            
        }
    }
    
    public func callConcludeSession(with duration: Int){
        let sessionID = UserSession.getSessionID() ?? ""
        let token = UserSession.getUserToken() ?? ""
        let params = ["duration": duration, "sessionID": sessionID] as [String : Any]

        WService.shared.getResponse(fromURL: URLS.concludeSession, method: .POST, params: params, header: ["x-sdk-token":token]) { (result: TrackEventResponse) in
            
        }
    }
    
    @objc func callKeepAlive(){
        let sessionID = UserSession.getSessionID() ?? ""
        let token = UserSession.getUserToken() ?? ""
        let params = ["sessionID": sessionID] as [String : Any]

        WService.shared.getResponse(fromURL: URLS.keepAlive, method: .POST, params: params, header: ["x-sdk-token":token]) { (result: DefaultRespoonse) in
            
        }
    }
    
    public func callFirebaseToken(){
        let params = ["firebaseToken": fToken] as [String : Any]
        let token = UserSession.getUserToken() ?? ""

        WService.shared.getResponse(fromURL: URLS.saveFCM, method: .POST, params: params, header: ["x-sdk-token":token]) { (result: DefaultRespoonse) in
            
        }
    }
    
    public func callUpdateProfile(){
        let sessionID = UserSession.getSessionID() ?? ""
        let token = UserSession.getUserToken() ?? ""
        let params = ["sessionID": sessionID, "userProperties": userProperties(), "userData":["name":"Surbhi"]] as [String : Any]
        
        WService.shared.getResponse(fromURL: URLS.updateProfile, method: .PUT, params: params, header: ["x-sdk-token":token]) { (result: DefaultRespoonse) in
        }
    }
    
    public func getLocation(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    public func userProperties()->[String: String]{
        let pointsPerInch = UIScreen.pointsPerInch ?? 0.0
        var properties = [String: String]()
        properties["CE Device Orientation"] = UIDevice.current.orientation.isLandscape ? "Landscape" : "Potrait"
        properties["CE Device Model"] = UIDevice.current.model
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
        properties["CE Wifi Connected"] = (NetworkData.shared.getNetworkType() == "WIFI") ? ("YES") : ("NO")
        properties["CE OS"] = "IOS"
        properties["CE OS Version"] = osVersion
        properties["CE SDK Version"] = sdkVersion
        properties["CE App Version"] = appVersion
        properties["CE Screen Resolution"] = "\(UIScreen.main.bounds.width)x\(UIScreen.main.bounds.height)"
        properties["CE Package Name"] = "\(Bundle.main.bundleIdentifier ?? "")"
        properties["CE Total RAM"] = "\(ProcessInfo.processInfo.physicalMemory/1024/1024)"
        properties["CE Available RAM"] = "\(UIDevice.current.freeRAM())"
        properties["CE DPI"] = "\(pointsPerInch)"
        
        return properties
    }
    
    public func appIslaunched(){
        var properties = ["CE Source":"IOS","CE App Version": appVersion]
        
        if let _ = app.object(forKey: appLaunched) {
            manageForEventTrack(with: "CE App Launched", properties: properties)
        }else{
            properties["CE SDK Version"] = sdkVersion
            properties["CE OS Version"] = osVersion
            properties["CE Network Provider"] = NetworkData.shared.getCarrierName()
            properties["CE Network Type"] = NetworkData.shared.getNetworkType()
            properties["CE Bluetooth On"] = isBTTurnedOn
            properties["CE Wifi Connected"] = (NetworkData.shared.getNetworkType() == "WIFI") ? ("YES") : ("NO")
            properties["CE Device Battery"] = "\(UIDevice.current.batteryLevel*100)"
            
            manageForEventTrack(with: "CE App Installed", properties: properties)
            app.set("true", forKey: appLaunched)
        }
    }
    
    public func appEnterdBackground(){
        let date = Date()
        app.set(date, forKey: backgroundTimer)
        
        if let date2 = app.object(forKey: foregroundTimer) as? Date{
            let difference = getTimeDifference(from: date2)
            let properties = ["CE Duration": "\(difference)"]
            manageForEventTrack(with: "CE App Background", properties: properties)
        }else{
            let properties = ["CE Duration": "0"]
            manageForEventTrack(with: "CE App Background", properties: properties)
        }
    }
    
    public func appMovedToForeground() {
        let date = Date()
        app.set(date, forKey: foregroundTimer)
        
        if let date2 = app.object(forKey: backgroundTimer) as? Date{
            let difference = getTimeDifference(from: date2)
            if difference>=30{
                callConcludeSession(with: difference)
            }else{
                let properties = ["CE Duration": "\(difference)"]
                manageForEventTrack(with: "CE App Foreground", properties: properties)
            }
        }else{
            let properties = ["CE Duration": "0"]
            manageForEventTrack(with: "CE App Foreground", properties: properties)
        }
    }
    
    public func getTimeDifference(from time: Date)-> Int{
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

extension RegisterNewUser: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {

    }
}
extension RegisterNewUser: CLLocationManagerDelegate{
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate
        else { return }
        currentLocation = locValue
    }
}
