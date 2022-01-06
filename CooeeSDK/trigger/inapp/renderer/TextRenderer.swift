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
        self.children = element.getProcessedPartList()
        self.triggerContext = triggerContext
    }

    // MARK: Internal

    let parentTextElement: TextElement
    let children: [[PartElement]]
    let triggerContext: TriggerContext

    var body: some View {
        let horizontalAlignment = parentTextElement.getSwiftUIHorizontalAlignment()

        VStack(alignment: horizontalAlignment) {
            let horizontalAlignment = parentTextElement.getSwiftUIHorizontalAlignment()

            VStack(alignment: horizontalAlignment) {
                let count: Int = children.count
                ForEach(0 ..< count) { index in
                    let hArray = children[index]
                    HStack {
                        ForEach(hArray) { child in
                            let textColour: Color = child.getPartColour() ?? parentTextElement.getColour() ?? Color(hex: "#000000")
                            let font = parentTextElement.getFont(for: child)
                            let alignment = parentTextElement.getSwiftUIAlignment()

                            let newString: String? = child.getPartText()

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
    }
}
