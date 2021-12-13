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
        self.children = element.prs!
        self.triggerContext = triggerContext
    }

    // MARK: Internal

    let parentTextElement: ButtonElement
    let children: [PartElement]
    let triggerContext: TriggerContext

    var body: some View {
        ForEach(children) { child in

            let textColour: Color = child.getPartColour() ?? parentTextElement.getColour() ?? Color(hex: "#000000")
            let font = parentTextElement.getFont()

            let temp = child.getPartText().trimmingCharacters(in: .whitespacesAndNewlines)

            if temp.count > 0 {
                Text(child.getPartText())
                        .foregroundColor(textColour)
                        .font(font)
                        .bold(child.isBold())
                        .italic(child.isItalic())
                        .underline(child.addUnderLine())
                        .strikethrough(child.addStrikeThrough())
                        .modifier(AbstractInAppRenderer(elementData: parentTextElement, triggerContext: triggerContext))
            }
        }
    }
}
