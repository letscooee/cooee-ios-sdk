//
// Created by Ashish Gaikwad on 19/10/21.
//

import Foundation
import HandyJSON

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class GroupElement: BaseElement {
    // MARK: Lifecycle

    required init() {
    }

    // MARK: Internal

    var children: [[String: Any]]?
    var clip: Overflow.Type?
    var fx: FlexProperties?
}
