//
//  DeviceInfo.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 16/09/21.
//

import Foundation
import UIKit

/**
 A utility helper class to provide some information of the device.
 
 - Author: Ashish Gaikwad
 - Since:0.1
 */
class DeviceInfo {
    static let shared = DeviceInfo()
    let cachedInfo = CashedInfo()
    
    struct CashedInfo {
        var name: String {
            return UIDevice.current.name
        }
        
        var width: CGFloat {
            return UIScreen.main.bounds.width
        }
        
        public var height: CGFloat {
            return UIScreen.main.bounds.height
        }
    }

    /**
      Get the name of the device.
     
      - returns: Device name in `String`
     */
    func getDeviceName() -> String {
        return cachedInfo.name
    }
    
    /**
     Provide device screen's width
     
     - returns: `CGFloat` Value
     */
    func getDeviceWidth() -> CGFloat {
        return cachedInfo.width
    }
    
    /**
     Provide device screen's height
     
     - returns: `CGFloat` Value
     */
    func getDeviceHeight() -> CGFloat {
        return cachedInfo.height
    }
}
