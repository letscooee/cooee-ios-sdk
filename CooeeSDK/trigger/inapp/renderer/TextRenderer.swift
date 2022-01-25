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
    @State var childSize: CGSize = .zero

    var body: some View {
        let alignment = parentTextElement.getSwiftUIAlignment()
        let textAlignment = parentTextElement.getTextAlignment()

        // Reference to add GeometryReader & onPreferenceChange which will help to keep watch on height of element
        // https://stackoverflow.com/a/56782264/9256497

        parentTextElement.getSinglePart()
                .background(
                        GeometryReader { proxy in
                            Color.clear
                                    .preference(
                                    key: SizePreferenceKey.self,
                                    value: proxy.size
                            )
                        }
                )
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(textAlignment)
                .if(parentTextElement.getCalculatedWidth() != nil) {
                    $0.frame(width: parentTextElement.getCalculatedWidth()!, height: childSize.height, alignment: alignment)
                }
                .frame(alignment: alignment)
                .onPreferenceChange(SizePreferenceKey.self) { preferences in
                    //let _ = print("height: \(preferences.height) width: \(preferences.width)")
                    self.childSize = preferences
                }
    }
    
    

}

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: Value = .zero

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
