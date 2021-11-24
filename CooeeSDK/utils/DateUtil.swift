//
//  DateUtil.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 05/10/21.
//

import Foundation
import UIKit

/**
 Utility class for date operation.
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class DateUtils {

    /**
     Converts date to specified format and in UTC format
     - Parameter date: Date
     - Returns: formatted date in String format
     */
    static func formatDateToUTCString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        formatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
        return formatter.string(from: date)
    }
    
    static func getDateDifferenceInSeconds(startDate: Date, endDate: Date) -> Int64 {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.second])
        let dateComponents = calendar.dateComponents(unitFlags, from: startDate, to: endDate)
        let seconds = dateComponents.second
        return Int64(seconds!)
    }
}
