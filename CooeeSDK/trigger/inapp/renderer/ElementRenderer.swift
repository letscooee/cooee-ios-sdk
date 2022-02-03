//
//  File.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 23/11/21.
//

import Foundation
import SwiftUI

/**
 Process and render all elements present in payload

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
struct ElementRenderer: View {
    // MARK: Lifecycle

    init(_ elements: [[String: Any]], _ triggerContext: TriggerContext) {
        self.elements = elements
        self.triggerContext = triggerContext
    }

    // MARK: Internal

    @State var childSize: CGSize = .zero

    var body: some View {
        let count: Int = elements.count
        ForEach(0..<count, id:\.self) { index in
            let child = elements[index]
            let baseElement = BaseElement.deserialize(from: child)

            if ElementType.TEXT == baseElement!.getElementType() {
                let textElement = TextElement.deserialize(from: child)

                // TODO: Solution is working good but not a good approach to pace element in background of view; Need to rework
                if textElement!.getCalculatedWidth() ?? 0 <= deviceWidth {
                    TextRenderer(textElement!, triggerContext)
                            .modifier(AbstractInAppRenderer(elementData: textElement!, triggerContext: triggerContext, isText: true))
                } else {
                    ZStack {
                    }.background(
                            TextRenderer(textElement!, triggerContext)
                                    .modifier(AbstractInAppRenderer(elementData: textElement!, triggerContext: triggerContext, isText: true))

                                    // Reference to add GeometryReader & onPreferenceChange which will help to keep watch on height of element
                                    // https://stackoverflow.com/a/56782264/9256497

                                    .height(childSize.height)
                                    .background(
                                            GeometryReader { proxy in
                                                Color.clear
                                                        .preference(
                                                        key: SizePreferenceKey.self,
                                                        value: proxy.size
                                                )
                                            }
                                    )

                                    .onPreferenceChange(SizePreferenceKey.self) { preferences in
                                        self.childSize = preferences
                                    }

                    ).if(textElement!.getCalculatedWidth()! > deviceWidth) {
                        $0.frame(maxWidth: deviceWidth, maxHeight: childSize.height)
                    }
                }
            } else if ElementType.BUTTON == baseElement!.getElementType() {
                let buttonElement = ButtonElement.deserialize(from: child)

                if buttonElement!.getCalculatedWidth() ?? 0 <= deviceWidth {
                    ButtonRenderer(buttonElement!, triggerContext)
                            .modifier(AbstractInAppRenderer(elementData: buttonElement!, triggerContext: triggerContext, isText: true))
                } else {
                    ZStack {
                    }.background(
                            ButtonRenderer(buttonElement!, triggerContext)
                                    .modifier(AbstractInAppRenderer(elementData: buttonElement!, triggerContext: triggerContext, isText: true))

                                    // Reference to add GeometryReader & onPreferenceChange which will help to keep watch on height of element
                                    // https://stackoverflow.com/a/56782264/9256497

                                    .height(childSize.height)
                                    .background(
                                            GeometryReader { proxy in
                                                Color.clear
                                                        .preference(
                                                        key: SizePreferenceKey.self,
                                                        value: proxy.size
                                                )
                                            }
                                    )

                                    .onPreferenceChange(SizePreferenceKey.self) { preferences in
                                        self.childSize = preferences
                                    }

                    ).if(buttonElement!.getCalculatedWidth()! > deviceWidth) {
                        $0.frame(maxWidth: deviceWidth, maxHeight: childSize.height)
                    }
                }
            } else if ElementType.IMAGE == baseElement!.getElementType() {
                let imageElement = ImageElement.deserialize(from: child)

                if imageElement!.getCalculatedWidth()! <= deviceWidth && imageElement!.getCalculatedHeight()! <= deviceHeight {
                    ImageRenderer(
                            url: URL(string: imageElement!.src!)!,
                            placeholder: {
                                // Image("placeholder").frame(width: 40) // etc.
                            },
                            image: {
                                $0.frame(width: imageElement!.getCalculatedWidth() ?? 0, height: imageElement!.getCalculatedHeight() ?? 0)
                            },
                            data: imageElement as! BaseElement
                    ).modifier(AbstractInAppRenderer(elementData: imageElement!, triggerContext: triggerContext, isContainer: false))
                } else {
                    ZStack {
                    }.background(
                            ImageRenderer(
                                    url: URL(string: imageElement!.src!)!,
                                    placeholder: {
                                        // Image("placeholder").frame(width: 40) // etc.
                                    },
                                    image: {
                                        $0.frame(width: imageElement!.getCalculatedWidth()!, height: imageElement!.getCalculatedHeight()!)
                                    },
                                    data: imageElement as! BaseElement
                            ).modifier(AbstractInAppRenderer(elementData: imageElement!, triggerContext: triggerContext, isContainer: false))
                    ).if(imageElement!.getCalculatedWidth()! > deviceWidth && imageElement!.getCalculatedHeight()! > deviceHeight) {
                        $0.frame(maxWidth: deviceWidth, maxHeight: deviceHeight)
                    }.if(imageElement!.getCalculatedWidth()! > deviceWidth && imageElement!.getCalculatedHeight()! < deviceHeight) {
                        $0.frame(maxWidth: deviceWidth, maxHeight: imageElement!.getCalculatedHeight()!)
                    }.if(imageElement!.getCalculatedWidth()! < deviceWidth && imageElement!.getCalculatedHeight()! > deviceHeight) {
                        $0.frame(maxWidth: imageElement!.getCalculatedWidth()!, maxHeight: deviceHeight)
                    }
                }

            } else if ElementType.SHAPE == baseElement!.getElementType() {
                let shapeElement = ShapeElement.deserialize(from: child)

                if shapeElement!.getCalculatedWidth()! <= deviceWidth && shapeElement!.getCalculatedHeight()! <= deviceHeight {
                    ShapeRenderer(shapeElement!, triggerContext)
                            .modifier(AbstractInAppRenderer(elementData: shapeElement!, triggerContext: triggerContext, isContainer: false))
                } else {
                    ZStack {
                    }.background(
                            ShapeRenderer(shapeElement!, triggerContext)
                                    .modifier(AbstractInAppRenderer(elementData: shapeElement!, triggerContext: triggerContext, isContainer: false))
                    ).if(shapeElement!.getCalculatedWidth()! > deviceWidth && shapeElement!.getCalculatedHeight()! > deviceHeight) {
                        $0.frame(maxWidth: deviceWidth, maxHeight: deviceHeight)
                    }.if(shapeElement!.getCalculatedWidth()! > deviceWidth && shapeElement!.getCalculatedHeight()! < deviceHeight) {
                        $0.frame(maxWidth: deviceWidth, maxHeight: shapeElement!.getCalculatedHeight()!)
                    }.if(shapeElement!.getCalculatedWidth()! < deviceWidth && shapeElement!.getCalculatedHeight()! > deviceHeight) {
                        $0.frame(maxWidth: shapeElement!.getCalculatedWidth()!, maxHeight: deviceHeight)
                    }
                }
            } else {
                ZStack {
                }
            }
        }
    }

    // MARK: Private

    private var elements: [[String: Any]]
    private var triggerContext: TriggerContext
    private let deviceWidth = UIScreen.main.bounds.width
    private let deviceHeight = UIScreen.main.bounds.height
}
