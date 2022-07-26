//
// Created by Ashish Gaikwad on 26/07/22.
//

import Foundation
import HandyJSON

/**
 Launch mode of the app to determine if app launched Organically or by push clicked.

 - Author: Ashish Gaikwad
 - Since: 1.3.13
 */
enum LaunchType: String, HandyJSONEnum, CaseIterable {
    case ORGANIC, PUSH_CLICK
}
