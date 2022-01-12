//
// Created by Ashish Gaikwad on 27/10/21.
//

import Foundation
import SwiftUI
import UIKit

/**
 Renders a TextElement with its all base property and text properties

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
struct TextRenderer: View {
    // MARK: Lifecycle

    init(_ element: TextElement, _ triggerContext: TriggerContext) {
        self.parentTextElement = element
        self.triggerContext = triggerContext
    }

    // MARK: Internal

    let parentTextElement: TextElement
    let triggerContext: TriggerContext

    var body: some View {

        let alignment = parentTextElement.getSwiftUIAlignment()
        let textAlignment = parentTextElement.getTextAlignment()

        parentTextElement.getSinglePart()
                .multilineTextAlignment(textAlignment)
                .if(parentTextElement.getCalculatedWidth() != nil) {
                    $0.frame(width: parentTextElement.getCalculatedWidth()!, alignment: alignment)
                }
                .frame(alignment: alignment)
    }
}
