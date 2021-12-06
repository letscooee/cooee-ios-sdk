//
// Created by Ashish Gaikwad on 27/10/21.
//

import Foundation
import SwiftUI
import UIKit

/**
 Renders a ButtonElement

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct ButtonRenderer: View {
    // MARK: Lifecycle

    init(_ element: ButtonElement, _ triggerContext: TriggerContext) {
        self.parentTextElement = element
        self.childrens = element.prs!
        self.triggerContext = triggerContext
    }

    // MARK: Internal

    let parentTextElement: ButtonElement
    let childrens: [PartElement]
    let triggerContext: TriggerContext

    var body: some View {
        ForEach(childrens) { child in

            let textColour: Color = child.getPartColour() ?? parentTextElement.getColour() ?? Color(hex: "#000000")
            let font = parentTextElement.getFont()
            let _: CGFloat? = parentTextElement.f?.getLineHeight()

            let temp = child.getPartText().trimmingCharacters(in: .whitespacesAndNewlines)
            if temp.count > 0 {
                Text(child.getPartText())
                        .foregroundColor(textColour)
                        .font(font)
                        .bold(child.isBold())
                        .italic(child.isItalic())
                        .underline(child.addUnderLine())
                        .strikethrough(child.addStrickThrough())
//                    .if(lineHeight != nil) {
//                        $0.fontWithLineHeight(font: font, lineHeight: lineHeight!)
//                    }
                //.modifier(AbstractInAppRenderer(elementData: parentTextElement, triggerContext: triggerContext, isContainer: false))
            }
        }
    }
}
