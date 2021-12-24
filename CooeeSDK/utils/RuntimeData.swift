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
 * - Since: 0.1.0
 */
class RuntimeData {
    // MARK: Public

    /**
     Check if app is in background
     - Returns: true if app is in background otherwise false
     */
    public func isInBackground() -> Bool {
        return self.inBackground
    }

    /**
     Update app went to background
     */
    public func setInBackground() {
        print("App went to background")
        self.inBackground = true
        self.lastEnterBackground = Date()
    }

    /**
     Update app came to foreground
     */
    public func setInForeground() {
        print("App went to foreground")
        self.inBackground = false
        self.lastEnterForeground = Date()
    }

    /**
     Check if app is in foreground
     - Returns: true if app is in foreground otherwise false
     */
    public func isInForeground() -> Bool {
        return !self.inBackground
    }

    /**
     Check the current active screen variable
     - Returns: current active string or empty string
     */
    public func getCurrentScreenName() -> String {
        return self.currentScreenName ?? ""
    }

    public func getLastEnterBackground() -> Date? {
        return self.lastEnterBackground
    }

    public func getTimeInForegroundInSeconds() -> Int64 {
        return DateUtils.getDateDifferenceInSeconds(startDate: self.lastEnterForeground!, endDate: self.lastEnterBackground!)
    }

    public func getTimeInBackgroundInSeconds() -> Int64 {
        if self.lastEnterBackground == nil {
            return 0
        }
        return DateUtils.getDateDifferenceInSeconds(startDate: self.lastEnterBackground!, endDate: Date())
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

}
