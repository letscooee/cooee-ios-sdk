//
// Created by Ashish Gaikwad on 27/10/21.
//

import Foundation
import SwiftUI
import UIKit

/**
 Renders a ButtonElement with its all base property and text properties

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
struct ButtonRenderer: View {
    // MARK: Lifecycle

    init(_ element: ButtonElement, _ triggerContext: TriggerContext) {
        self.parentTextElement = element
        self.triggerContext = triggerContext
    }

    // MARK: Internal

    let parentTextElement: ButtonElement
    let triggerContext: TriggerContext

    var body: some View {
        TextRenderer(parentTextElement, triggerContext)
    }
}
