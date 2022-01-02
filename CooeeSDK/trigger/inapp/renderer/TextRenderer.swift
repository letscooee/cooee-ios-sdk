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
        self.children = element.prs!
        self.triggerContext = triggerContext
    }

    // MARK: Internal

    let parentTextElement: TextElement
    let children: [PartElement]
    let triggerContext: TriggerContext

    var body: some View {

        let horizontalAlignment = parentTextElement.getSwiftUIHorizontalAlignment()

        VStack(alignment: horizontalAlignment) {
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
                            .if(parentTextElement.getCalculatedWidth() != nil) {
                                $0.frame(width: parentTextElement.getCalculatedWidth()!, alignment: alignment)
                            }
                            .frame(alignment: alignment)
                }
            }
        }
    }
}
