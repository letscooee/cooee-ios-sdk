//
//  DateUtil.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 05/10/21.
//

import Foundation
import UIKit

class DateUtils{
    
    static func formatDateToUTCString(date:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        formatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
        return formatter.string(from: date)
    }
}
