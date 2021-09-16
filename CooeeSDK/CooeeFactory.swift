//
//  CooeeFactory.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 16/09/21.
//

import Foundation

class CooeeFactory{
    static let shared=CooeeFactory()
    
    let appInfo:AppInfo
    let deviceInfo:DeviceInfo
    
    init() {
        appInfo=AppInfo.shared
        deviceInfo=DeviceInfo.shared
        
    }
}
