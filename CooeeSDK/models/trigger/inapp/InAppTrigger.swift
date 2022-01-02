//
// Created by Ashish Gaikwad on 21/10/21.
//

import Foundation
import HandyJSON

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
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

    // MARK: Internal

    var cont: Container?
    var elems: [[String: Any]]?
    private var o: Int?
}
