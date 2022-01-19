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

    public func getGravity() -> SwiftUI.Alignment {
        switch o {
            case 1:
                return SwiftUI.Alignment.topLeading
            case 2:
                return SwiftUI.Alignment.top
            case 3:
                return SwiftUI.Alignment.topTrailing
            case 4:
                return SwiftUI.Alignment.leading
            case 6:
                return SwiftUI.Alignment.trailing
            case 7:
                return SwiftUI.Alignment.bottomLeading
            case 8:
                return SwiftUI.Alignment.bottom
            case 9:
                return SwiftUI.Alignment.bottomTrailing
            case .none:
                return SwiftUI.Alignment.center
            case .some:
                return SwiftUI.Alignment.center
        }
    }

    // MARK: Internal

    var animation: Animation?

    // MARK: Private

    private var o: Int? // Position of the In-App on the container
}
