//
// Created by Ashish Gaikwad on 19/10/21.
//

import Foundation

/**
 Button element extent is used to provide all base properties to ButtonRenderer. But it uses TextElement as its parent

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
class TextElement: BaseTextElement, Identifiable {
    // MARK: Lifecycle

    required init() {
    }

    // MARK: Internal

    var prs: [PartElement]?
}
