//
//  RuntimeData.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 05/10/21.
//

import Foundation

/**
 * A simple data holder class that contains runtime state of the application/SDK.
 *
 * - Author: Ashish Gaikwad
 * - Since: 0.0.1
 */
class RuntimeData {
    // MARK: Public

    public func isInBackground() -> Bool {
        return self.inBackground
    }

    public func setInBackground() {
        print("App went to background")
        self.inBackground = true
        self.lastEnterBackground = Date()
    }

    public func setInForeground() {
        print("App went to foreground")
        self.inBackground = false
        self.lastEnterForeground = Date()
    }

    public func isInForeground() -> Bool {
        return !self.inBackground
    }

    public func getCurrentScreenName() -> String {
        return self.currentScreenName ?? ""
    }

    public func getLastEnterBackground() -> Date? {
        return self.lastEnterBackground
    }

    public func getTimeInForegroundInSeconds() -> Int64 {
        return self.getDateDifferenceInSeconds(startDate: self.lastEnterBackground!, endDate: self.lastEnterForeground!)
    }

    public func getTimeInBackgroundInSeconds() -> Int64 {
        if self.lastEnterBackground == nil {
            return 0
        }
        return self.getDateDifferenceInSeconds(startDate: Date(), endDate: self.lastEnterBackground!)
    }

    public func setCurrentScreenName(name: String) {
        print("Updated screen: " + name)
        self.currentScreenName = name
    }

    /**
     Returns <code>true</code> if the app is just launched and the "on foreground" event is executed.

     - returns:true or false
     */
    public func isFirstForeground() -> Bool {
        return self.lastEnterBackground == nil
    }

    // MARK: Internal

    static let shared = RuntimeData()

    // MARK: Private

    private var inBackground: Bool = true
    private var lastEnterForeground: Date?
    private var lastEnterBackground: Date?
    private var currentScreenName: String?

    private func getDateDifferenceInSeconds(startDate: Date, endDate: Date) -> Int64 {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.second])
        let datecomponents = calendar.dateComponents(unitFlags, from: startDate, to: endDate)
        let seconds = datecomponents.second
        return Int64(seconds!)
    }
}
