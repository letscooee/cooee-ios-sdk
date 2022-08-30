//
//  SessionManager.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 05/10/21.
//

import Foundation

/**
 Manages the user's current session in the app.

 - Author: Ashish Gaikwad
 - Since: 0.1.0
  */
class SessionManager {
    // MARK: Lifecycle

    init() {
        runtimeData = RuntimeData.shared
    }

    // MARK: Public


    /**
     Creates a new session if ``currentSessionID`` is empty or null.
     */
    private func startNewSession() {
        if !(currentSessionID?.isEmpty ?? true) {
            return
        }

        currentSessionStartTime = Date()
        currentSessionID = ObjectID().hexString
        LocalStorageHelper.putString(key: Constants.STORAGE_ACTIVE_SESSION, value: currentSessionID!)

        bumpSessionNumber()
    }

    /**
     Create a new session.
     - parameters:
     - createNew: If a session does not exists and <code>createNew</code> is <true></true>, then create a new session.

     - returns:The current or new session id.
     */
    public func getCurrentSessionID(createNew: Bool) -> String {
        currentSessionID = LocalStorageHelper.getString(key: Constants.STORAGE_ACTIVE_SESSION)
        currentSessionNumber = Int64(LocalStorageHelper.getLong(key: Constants.STORAGE_SESSION_NUMBER, defaultValue: 0))

        if createNew {
            startNewSession()
        }

        LocalStorageHelper.putDate(key: Constants.STORAGE_LAST_SESSION_USE_TIME, value: Date())

        return currentSessionID!
    }

    /**
     Create a new session and always make sure that a session is created if not already started.

     - returns:The current session id.
     */
    public func getCurrentSessionID() -> String {
        return getCurrentSessionID(createNew: true)
    }

    /**
     * Conclude the current session by sending an event to the server followed by
     * destroying it.
     */
    public func conclude() {
        var requestData = [String: Any]()
        requestData["sessionID"] = getCurrentSessionID()
        requestData["occurred"] = DateUtils.formatDateToUTCString(date: Date())

        // Remove Active trigger from the session
        LocalStorageHelper.remove(key: Constants.STORAGE_ACTIVE_TRIGGER)
        LocalStorageHelper.remove(key: Constants.STORAGE_LAST_SESSION_USE_TIME)
        LocalStorageHelper.remove(key: Constants.STORAGE_ACTIVE_SESSION)
        destroySession()

        CooeeFactory.shared.safeHttpService.sendSessionConcludedEvent(requestData: requestData)
    }

    public func destroySession() {
        currentSessionID = nil
        currentSessionNumber = nil
        currentSessionStartTime = nil
    }

    public func getCurrentSessionNumber() -> Int64 {
        return currentSessionNumber!
    }

    /**
     * Send a beacon to backend server for keeping the session alive.
     */
    public func pingServerToKeepAlive() {
        var requestData = [String: String]()
        requestData["sessionID"] = getCurrentSessionID()

        CooeeFactory.shared.baseHttpService.keepAliveSession(body: requestData)
    }

    /**
     Checks if the session is valid. If the session is not valid, then conclude that session.

     - Returns: <code>true</code> if the session is valid.
     */
    public func checkSessionValidity() -> Bool {
        if getLastSessionUsed() > Constants.IDLE_TIME_IN_SECONDS {
            conclude()
            return true
        }

        return false
    }

    /**
     Send server check message every 5 min that session is still alive
     */
    public func keepSessionAlive() {
        // send server check message every 5 min that session is still alive
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(Constants.KEEP_ALIVE_TIME_IN_MS), target: self,
                selector: #selector(keepAlive), userInfo: nil, repeats: true)
    }

    /**
     Stop the timer that keeps the session alive.
     */
    public func stopSessionAlive() {
        timer?.invalidate()
    }

    // MARK: Internal

    static let shared = SessionManager()

    // MARK: Private

    private let runtimeData: RuntimeData
    private var currentSessionID: String?
    private var currentSessionNumber: Int64?
    private var currentSessionStartTime: Date?
    private var timer: Timer?

    private func bumpSessionNumber() {
        currentSessionNumber = Int64(LocalStorageHelper.getLong(key: Constants.STORAGE_SESSION_NUMBER, defaultValue: 0))
        currentSessionNumber! += 1

        LocalStorageHelper.putLong(key: Constants.STORAGE_SESSION_NUMBER, value: currentSessionNumber)
    }

    /**
     Returns the time in seconds since the last time the session was used.

     - Returns: The time in seconds since the last time the session was used.
     */
    private func getLastSessionUsed() -> Int {
        let date = LocalStorageHelper.getDate(key: Constants.STORAGE_LAST_SESSION_USE_TIME, defaultValue: Date())!

        return Int(Date().timeIntervalSince(date))
    }

    @objc private func keepAlive() {
        pingServerToKeepAlive()
    }
}
