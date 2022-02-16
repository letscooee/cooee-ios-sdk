//
// Created by Ashish Gaikwad on 21/10/21.
//

import Foundation
import SwiftUI

/**
 Holds the Container information
 
 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
class Container: BaseElement {
    // MARK: Public

    public func getGravity() -> Int? {
        o
    }

    // MARK: Internal

    var animation: Animation?

    // MARK: Private

    private var o: Int? // Position of the In-App on the container
}
