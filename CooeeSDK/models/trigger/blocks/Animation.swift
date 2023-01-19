//
// Created by Ashish Gaikwad on 21/10/21.
//

import Foundation
import HandyJSON

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct Animation: HandyJSON {

    public enum EntranceAnimation: Int, HandyJSONEnum {
        case NONE = 1
        case SLIDE_IN_TOP = 2
        case SLIDE_IN_DOWN = 3
        case SLIDE_IN_LEFT = 4
        case SLIDE_IN_RIGHT = 5
        case SLIDE_IN_TOP_LEFT = 6
        case SLIDE_IN_TOP_RIGHT = 7
        case SLIDE_IN_BOTTOM_LEFT = 8
        case SLIDE_IN_BOTTOM_RIGHT = 9
    }

    public enum ExitAnimation: Int, HandyJSONEnum {
        case  NONE = 1
        case  SLIDE_OUT_TOP = 2
        case  SLIDE_OUT_DOWN = 3
        case  SLIDE_OUT_LEFT = 4
        case  SLIDE_OUT_RIGHT = 5
        case  SLIDE_OUT_TOP_LEFT = 6
        case  SLIDE_OUT_TOP_RIGHT = 7
        case  SLIDE_OUT_BOTTOM_LEFT = 8
        case  SLIDE_OUT_BOTTOM_RIGHT = 9
    }

    var en: EntranceAnimation?
    var ex: ExitAnimation?
}
