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

    public override func getWidth() -> Float {
        super.getWidth() <= 0 ? Constants.STANDARD_RESOLUTION_WIDTH : super.getWidth()
    }

    override func getHeight() -> Float {
        super.getHeight() <= 0 ? Constants.STANDARD_RESOLUTION_HEIGHT : super.getHeight()
    }

    public func getGravity() -> Int? {
        o
    }

    // MARK: Private

    private var o: Int? // Position of the In-App on the container
}
