//
//  File.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 23/11/21.
//

import Foundation
import SwiftUI

/**
 Renders all elements according to there type

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct ElementRenderer: View {
    // MARK: Lifecycle

    init(_ elements: [[String: Any]], _ triggerContext: TriggerContext) {
        self.elements = elements
        self.triggerContext = triggerContext
    }

    // MARK: Internal

    var body: some View {
        let count:Int = elements.count
        ForEach(0 ..< count) { index in
            let child = elements[index]
            let baseElement = BaseElement.deserialize(from: child)

            if ElementType.TEXT == baseElement!.getElementType() {
                let textElement = TextElement.deserialize(from: child)

                TextRenderer(textElement!,triggerContext)
            } else if ElementType.BUTTON == baseElement!.getElementType() {
                let buttonElement = ButtonElement.deserialize(from: child)

                ButtonRenderer(buttonElement!,triggerContext)
            } else if ElementType.IMAGE == baseElement!.getElementType() {
                let imageElement = ImageElement.deserialize(from: child)

                // process image
                ImageRenderer(
                    url: URL(string: imageElement!.src!)!,
                    placeholder: {
                        // Image("placeholder").frame(width: 40) // etc.
                    },
                    image: {
                        $0.resizable() // etc.
                    }
                ).modifier(AbstractInAppRenderer(elementData: imageElement!,triggerContext: triggerContext))
            } else if ElementType.SHAPE == baseElement!.getElementType() {
                let shapeElement = ShapeElement.deserialize(from: child)

                ShapeRenderer(shapeElement!, triggerContext)
            }
        }
    }

    // MARK: Private

    private var elements: [[String: Any]]
    private var triggerContext: TriggerContext
}
