//
//  DeviceInfo.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 16/09/21.
//

import Foundation
import UIKit
class DeviceInfo{
    
    static let shared=DeviceInfo()
    let cachedInfo=CashedInfo()
    
    struct CashedInfo {
        
        var name:String{
            return UIDevice.current.name
        }
        
        var width: CGFloat {
            return UIScreen.main.bounds.width
        }
        
        public var height: CGFloat {
            return UIScreen.main.bounds.height
        }
        
        
    }
}
