//
//  SessionManager.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 05/10/21.
//

import BSON
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
        self.getCurrentSessionID()
    }

    // MARK: Public

    public func startNewSession() {
        if !(currentSessionID?.isEmpty ?? true) {
            return
        }

        currentSessionStartTime = Date()
        currentSessionID = ObjectId().hexString

        bumpSessionNumber()
    }

    /**
     Create a new session.
     - parameters:
     - createNew: If a session does not exists and <code>createNew</code> is <true></true>, then create a new session.

     - returns:The current or new session id.
     */
    public func getCurrentSessionID(createNew: Bool) -> String {
        if currentSessionID?.isEmpty ?? true, createNew {
            startNewSession()
        }

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
        requestData["occurred"] = Date()

        CooeeFactory.shared.baseHttpService.sendSessionConcludedEvent(body: requestData)
        destroySession()
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

    // MARK: Internal

    static let shared = SessionManager()

    // MARK: Private

    private let runtimeData: RuntimeData

    private var currentSessionID: String?
    private var currentSessionNumber: Int64?
    private var currentSessionStartTime: Date?

    private func bumpSessionNumber() {
        currentSessionNumber = Int64(LocalStorageHelper.getLong(key: Constants.STORAGE_SESSION_NUMBER, defaultValue: 0))
        currentSessionNumber! += 1

        LocalStorageHelper.putLong(key: Constants.STORAGE_SESSION_NUMBER, value: currentSessionNumber)
    }
}
