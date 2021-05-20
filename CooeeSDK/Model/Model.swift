//
//  Model.swift
//  CooeeiOSSDK
//
//  Created by Surbhi Lath on 28/01/21.
//

import Foundation

struct RegisterUserDataModel: Codable {
    var id: String
    var secretKey: String
    var deviceData: DeviceData
    
    var dictionary: [String: Any] {
        return ["appID": id  ,
                    "appSecret": secretKey,
                    "deviceData": deviceData.dictionary ]
        }
}


struct DeviceData: Codable {
    var os: String
    var cooeeSdkVersion: String
    var appVersion: String
    var osVersion: String
    
    var dictionary: [String: Any] {
        return ["os":os,
                "cooeeSdkVersion": cooeeSdkVersion,
                "appVersion": appVersion,
                "osVersion": osVersion]
    }
}

struct RegisterUserResponse: Decodable {
    var id: String?
    var sdkToken: String?
    var sessionID: String?
    var code: String?
    var message: String?
}

struct TrackEventResponse: Decodable {
    var code: String?
    var message: String?
    var eventID: String?
    var sessionID: String?
    var triggerData: DataTriggered?
}

struct DefaultRespoonse: Decodable {
    
}

struct DataTriggered: Decodable {
    let data: DataClass
}

struct DataClass: Decodable {
    let triggerData: TriggerData
}

struct TriggerData: Decodable {
    let id: String
    let triggerBackground: TriggerBackground
    let background: Background
    let imageURL: String
    let videoURL: String
    let showAsPN: Bool
    let entranceAnimation: EntryAnimations
    let exitAnimation: ExitAnimations
    let type: LayoutType
    let fill: LayoutFill
    let title, message: Message
    let closeBehaviour: CloseBehaviour
    let duration: Int?
    let buttons: [Button]
    let sound: String?
    
    enum CodingKeys: String, CodingKey {
        case id, triggerBackground, background
        case imageURL = "imageUrl"
        case videoURL = "videoUrl"
        case showAsPN, entranceAnimation, exitAnimation, type, fill, title, message, closeBehaviour, buttons, duration
        case sound = "notificationSoundUrl"
    }
}

// MARK: - Background
struct Background: Decodable {
    let type: BackgroundType
    let color: String
    let image: String
    let opacity, radius: Int
}

// MARK: - Button
struct Button: Decodable {
    let text: String
    let showInPN, launchApp: Bool
    let notificationText, background, color, radius: String
    let action: Action
}

// MARK: - Action
struct Action: Decodable {
    let userProperty: [String: String]
    let kv: [String: String]
}


// MARK: - CloseBehaviour
struct CloseBehaviour: Decodable {
    let auto: Bool
    let timeToClose: Int
    let position: CloseButtonPosition
}

// MARK: - Message
struct Message: Decodable {
    let text, notificationText, color: String
    let size: Int
    let position: TextPosition
}

// MARK: - TriggerBackground
struct TriggerBackground: Decodable {
    let type: BackgroundType
    let blur: Int
    let color: String
}

enum BackgroundType: String, Decodable {
    case BLURRED = "BLURRED"
    case SOLID_COLOR = "SOLID_COLOR"
    case IMAGE = "IMAGE"
}

enum EntryAnimations: String, Decodable {
    case SLIDE_IN_TOP
    case SLIDE_IN_DOWN
    case SLIDE_IN_LEFT
    case SLIDE_IN_RIGHT
}

enum ExitAnimations: String, Decodable {
    case SLIDE_OUT_LEFT
    case SLIDE_OUT_TOP
    case SLIDE_OUT_BOTTOM
    case SLIDE_OUT_RIGHT
}

enum LayoutType: String, Decodable{
    case IMAGE
    case VIDEO
}

enum LayoutFill:String, Decodable {
    case COVER
    case INTERSTITIAL
    case HALF_INTERSTITIAL

}

enum CloseButtonPosition:String, Decodable {
    case TOP_RIGHT
    case TOP_LEFT
    case DOWN_RIGHT
    case DOWN_LEFT

}

enum TextPosition: String, Decodable {
    case TOP
    case DOWN
    case LEFT
    case RIGHT
}

struct TriggerDataModel: Codable {
    var triggerId: String
    var triggerDuration: String
    var receivedOn: Date?
    enum CodingKeys: String, CodingKey {
        case triggerId = "triggerID"
        case triggerDuration = "duration"
        case receivedOn = "receivedOn"
    }
}

enum CloseType: String, Decodable{
    case CloseButton = "Close Button"
    case ActionButton = "Action Button"
    case Auto = "Auto"
    case TriggerTouch = "Trigger Touch"
}


struct RequestData: Codable, Equatable{
    var url: String
    var header: [String: String]
    var method: String
}
