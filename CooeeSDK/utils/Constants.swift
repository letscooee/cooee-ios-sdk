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
 - Since:0.1
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
    // endregion
}
