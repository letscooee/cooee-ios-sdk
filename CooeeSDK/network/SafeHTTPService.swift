//
// Created by Ashish Gaikwad on 11/10/21.
//

import Foundation

/**
 A safe HTTP service which saves the data in {@link com.letscooee.room.CooeeDatabase} before attempting
 via {@link BaseHTTPService}. If the network call fails because of any reason, the {@link com.letscooee.scheduler.job.PendingTaskJob}
 will reattempt sending the data to the API.

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class SafeHTTPService {
    // MARK: Lifecycle

    init(pendingTaskService: PendingTaskService, sessionManager: SessionManager, runtimeData: RuntimeData) {
        self.pendingTaskService = pendingTaskService
        self.sessionManager = sessionManager
        self.runtimeData = runtimeData
    }

    // MARK: Public

    /**
     Send a new event and make sure that a session always exists.

     - Parameter event: The new event to be posted to the server safely.
     */
    public func sendEvent(event: Event) {
        sendEvent(event: event, createSession: true)
    }

    /**
     Send a new event and make sure if the session is not already created then do not create a new session (skip session creation).
     - Parameter event: The new event to be posted to the server safely.
     */
    public func sendEventWithoutNewSession(event: Event) {
        sendEvent(event: event, createSession: false)
    }


    public func updateUserProfile(userData: [String: Any]) {
        var requestData = userData
        requestData["sessionID"] = sessionManager.getCurrentSessionID()
        let pendingTask = pendingTaskService.newTask(data: requestData, pendingTaskType: PendingTaskType.API_UPDATE_PROFILE)
        attemptTaskImmediately(pendingTask)
    }

    public func sendSessionConcludedEvent(requestData: [String: Any]) {
        let pendingTask = pendingTaskService.newTask(data: requestData, pendingTaskType: PendingTaskType.API_SESSION_CONCLUDE)
        attemptTaskImmediately(pendingTask)
    }

    public func updatePushToken(requestData: [String: Any]) {
        let pendingTask = pendingTaskService.newTask(data: requestData, pendingTaskType: PendingTaskType.API_UPDATE_PUSH_TOKEN);
        attemptTaskImmediately(pendingTask);
    }

    func updateDeviceProperty(deviceProp: DeviceDetails) {
        let pendingTask = pendingTaskService.newTask(data: deviceProp.toDictionary(), pendingTaskType: PendingTaskType.API_DEVICE_PROFILE)
        attemptTaskImmediately(pendingTask)
    }

    // MARK: Private

    private let pendingTaskService: PendingTaskService
    private let sessionManager: SessionManager
    private let runtimeData: RuntimeData

    private func sendEvent(event: Event, createSession: Bool) {
        var event = event
        let sessionID = sessionManager.getCurrentSessionID(createNew: createSession)

        if event.trigger == nil {
            /*
             *There is a possibility that the trigger can get expire in the same session or while the app is running. So, update
             * "trigger.expired" before sending any event as the last active trigger will be tracked till the session is not expired.
             */
            if let trigger = LocalStorageHelper.getTypedClass(key: Constants.STORAGE_ACTIVE_TRIGGER, clazz: EmbeddedTrigger.self) {
                trigger.updateExpired()
                event.trigger = trigger
            }
        }

        if !(sessionID.isEmpty) && createSession {
            event.sessionID = sessionID
            event.sessionNumber = Int(sessionManager.getCurrentSessionNumber())
        }

        event.activeTriggers = EngagementTriggerHelper.getActiveTriggers()
        event.screenName = runtimeData.getCurrentScreenName()

        let pendingTask = pendingTaskService.newTask(event)

        attemptTaskImmediately(pendingTask)
    }

    /**
     Executes the newly created {@code pendingTask} immediately. This newly task will be processed in a new thread (outside the main thread) as the network calls are synchronous in {@link BaseHTTPService}.
     - Parameter task: Task to attempt execution.
     */
    private func attemptTaskImmediately(_ task: PendingTasks) {
        pendingTaskService.processTask(pendingTask: task)
    }
}
