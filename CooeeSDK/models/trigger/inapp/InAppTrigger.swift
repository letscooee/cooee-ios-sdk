//
// Created by Ashish Gaikwad on 21/10/21.
//

import Foundation
import HandyJSON
import SwiftUI

/**
 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
class InAppTrigger: HandyJSON {
    // MARK: Lifecycle

    required init() {}

    // MARK: Public

    public func getCanvasWidth() -> Float {
        w ?? 1080
    }

    public func getCanvasHeight() -> Float {
        h ?? 1920
    }

    public func getGravity() -> SwiftUI.Alignment? {
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
                return nil
            case .some:
                return nil
        }
    }

    public func getBackground() -> Background? {
        bg
    }

    // MARK: Internal

    var cont: Container?        // Container
    var elems: [[String: Any]]? // Elements

    // MARK: Private

    private var o: Int?         // In-App contaoner gravity
    private var w: Float?       // In-App canvas width
    private var h: Float?       // In-App canvas height
    private var bg: Background? // Full screen background
}
