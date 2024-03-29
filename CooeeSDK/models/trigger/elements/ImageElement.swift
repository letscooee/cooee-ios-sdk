//
// Created by Ashish Gaikwad on 19/10/21.
//

import Foundation

/**
 ImageElement is a class which holds image src and all its base properties

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
class ImageElement: BaseElement {
    // MARK: Lifecycle


    // MARK: Internal

    var src: String?

    override func hasValidImageResource() throws -> Bool {
        if src?.isEmpty ?? true {
            throw InvalidTriggerDataException(message: "ImageElement has no/empty src")
        }
        return true
    }
}
