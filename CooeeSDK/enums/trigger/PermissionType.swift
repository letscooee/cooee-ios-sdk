//
// Created by Ashish Gaikwad on 10/11/21.
//

import Foundation
import HandyJSON

/**
 Permissions which can be asked via InApp

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
enum PermissionType: String, HandyJSONEnum, CaseIterable {

    case LOCATION
    case CAMERA
    case PHONE_DETAILS
    case STORAGE
    case PUSH
}
