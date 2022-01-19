//
// Created by Ashish Gaikwad on 21/10/21.
//

import Foundation
import HandyJSON

/**
 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
class InAppTrigger: HandyJSON {
    // MARK: Lifecycle

    required init() {}

    // MARK: Public

    public func getOrientation() -> UIInterfaceOrientation {
        switch o {
        case 1:
            return UIInterfaceOrientation.portrait
        case 2:
            return UIInterfaceOrientation.landscapeLeft

        case .none:
            return UIInterfaceOrientation.portrait
        case .some:
            return UIInterfaceOrientation.portrait
        }
    }

    public func getCanvasWidth() -> Float {
        w ?? 1080
    }

    public func getCanvasHeight() -> Float {
        h ?? 1920
    }

    // MARK: Internal

    var cont: Container?        // Container
    var elems: [[String: Any]]? // Elements

    // MARK: Private

    private var o: Int?         // In-App orientation
    private var w: Float?       // In-App canvas width
    private var h: Float?       // In-App canvas height
}
