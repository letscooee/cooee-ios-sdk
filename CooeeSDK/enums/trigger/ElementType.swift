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
enum ElementType: Int, HandyJSONEnum,CaseIterable {

    case IMAGE = 1
    case TEXT = 2
    case BUTTON = 3
    case VIDEO = 4
    case SHAPE = 100
}
