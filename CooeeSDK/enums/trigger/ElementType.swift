//
// Created by Ashish Gaikwad on 26/10/21.
//

import Foundation
import HandyJSON

/**
 Types of elements possible in a engagement trigger.

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
enum ElementType: String, HandyJSONEnum {
    case TEXT
    case BUTTON
    case IMAGE
    case VIDEO
    case GROUP
}
