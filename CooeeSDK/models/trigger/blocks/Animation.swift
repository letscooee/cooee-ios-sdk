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

    public enum EntranceAnimation: String, HandyJSONEnum {
        case SLIDE_IN_TOP, SLIDE_IN_DOWN, SLIDE_IN_LEFT, SLIDE_IN_RIGHT, SLIDE_IN_TOP_LEFT, SLIDE_IN_TOP_RIGHT,
        SLIDE_IN_BOTTOM_LEFT, SLIDE_IN_BOTTOM_RIGHT
    }

    public enum ExitAnimation: String, HandyJSONEnum {
        case SLIDE_OUT_TOP, SLIDE_OUT_DOWN, SLIDE_OUT_LEFT, SLIDE_OUT_RIGHT, SLIDE_OUT_TOP_LEFT, SLIDE_OUT_TOP_RIGHT,
             SLIDE_OUT_BOTTOM_LEFT, SLIDE_OUT_BOTTOM_RIGHT
    }

    var enter: EntranceAnimation?
    var exit: ExitAnimation?
}
