//
//  Constants.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 17/09/21.
//

import Foundation

/**
 The Constants struct contains all the constants required by SDK
 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
struct Constants {

    // region All Shared Preference related keys
    static let STORAGE_FIRST_TIME_LAUNCH = "is_first_launch"
    static let STORAGE_SDK_TOKEN = "sdk_token"
    static let STORAGE_SESSION_NUMBER = "session_number"
    static let STORAGE_USER_ID = "user_id"
    static let STORAGE_ACTIVE_TRIGGERS = "active_triggers"
    static let STORAGE_LAST_TOKEN_ATTEMPT = "last_token_check_attempt"
    static let STORAGE_LAST_FONT_ATTEMPT = "last_font_check_attempt"
    static let STORAGE_CACHED_FONTS = "cached_fonts"
    static let STORAGE_FB_TOKEN = "fb_token"
    static let STORAGE_DEVICE_ID = "cooee_device_id"
    static let STORAGE_DEVICE_UUID = "cooee_device_uuid"
    static let STORAGE_ACTIVATED_TRIGGERS = "activated_triggers"
    static let STORAGE_ACTIVE_TRIGGER = "active_trigger"
    static let STORAGE_SCREENSHOT_SYNC_TIME = "screenshot_sync_time"
    static let STORAGE_ACTIVE_SESSION = "active_session"
    static let STORAGE_LAST_SESSION_USE_TIME = "last_session_use_time"
    static let STORAGE_NOTIFICATION_ID = "cooee_notification_id"
    // endregion

    // KEEP_ALIVE_TIME_IN_MS will be in SECONDS
    static let KEEP_ALIVE_TIME_IN_MS = 5 * 60
    static let IDLE_TIME_IN_SECONDS = 30 * 60
    static let SYSTEM_DATA_PREFIX = "CE"
    static let TAG = "CooeeSDK:"
    static let TIME_TO_WAIT_SECONDS = 6.0;
    static let FONT_REFRESH_INTERVAL_DAYS = 7
    static let SCREENSHOT_SEND_INTERVAL_HOURS = 6
    static let PLATFORM = "iOS"
    static let DEFAULT_RESOLUTION_WIDTH: Float = 1080
    static let DEFAULT_RESOLUTION_HEIGHT: Float = 1920

    // region All Server Endpoint
    static let BASE_URL = "https://api.sdk.letscooee.com"
    static let registerUser = "/v1/device/validate"
    static let trackEvent = "/v1/event/track/"
    static let concludeSession = "/v1/session/conclude"
    static let keepAlive = "/v1/session/keepAlive"
    static let saveFCM = "/v1/device/setPushToken"
    static let updateProfile = "/v1/user/update"
    static let deviceUpdate = "/v1/device/update"
    static let triggerDetails = "/v1/trigger/details/"
    static let appConfig = "/v1/app/config/"
    static let uploadScreenshot = "/v1/app/uploadScreenshot"

    // endregion

    // region Units
    public static let UNIT_PIXEL = "px";
    public static let UNIT_PERCENT = "%";
    public static let UNIT_VIEWPORT_HEIGHT = "vh";
    public static let UNIT_VIEWPORT_WIDTH = "vw";
    // endregion

    // region SDK Info
    static let VERSION_STRING = "1.4.2"
    static let VERSION_CODE = 10402
    // endregion

    // region Event Names
    static let EVENT_SCREEN_VIEW = "CE Screen View"
    static let EVENT_APP_INSTALLED = "CE App Installed"
    static let EVENT_APP_LAUNCHED = "CE App Launched"
    static let EVENT_APP_BACKGROUND = "CE App Background"
    static let EVENT_APP_FOREGROUND = "CE App Foreground"
    static let EVENT_TRIGGER_DISPLAY = "CE Trigger Displayed"
    static let EVENT_TRIGGER_CLOSED = "CE Trigger Closed"
    static let EVENT_NOTIFICATION_RECEIVED = "CE Notification Received"
    static let EVENT_NOTIFICATION_VIEWED = "CE Notification Viewed"
    static let EVENT_NOTIFICATION_CLICKED = "CE Notification Clicked"
    static let EVENT_NOTIFICATION_CANCELLED = "CE Notification Cancelled"
    // endregion
}
