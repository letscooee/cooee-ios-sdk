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
            let alignment = parentTextElement.getSwiftUIAlignment()

            let last1 = Array(child.getPartText())
            let newString: String? = Character(extendedGraphemeClusterLiteral: Array(last1)[last1.count - 1]).isNewline ?
                    String(child.getPartText().dropLast(1))
                    :
                    child.getPartText()

            let temp = newString!.trimmingCharacters(in: .whitespacesAndNewlines)

            if temp.count > 0 {
                Text(newString!)
                        .foregroundColor(textColour)
                        .font(font)
                        .bold(child.isBold())
                        .italic(child.isItalic())
                        .underline(child.addUnderLine())
                        .strikethrough(child.addStrikeThrough())
                        .frame(alignment: alignment)
                //TODO: need to work on line height
            }
        }
    }
}
