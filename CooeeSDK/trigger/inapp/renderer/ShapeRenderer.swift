//
//  ShapeRenderer.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 23/11/21.
//

import Foundation
import SwiftUI

/**
 Renders Shape Element

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct ShapeRenderer: View {
    // MARK: Lifecycle

    init(_ shapeElement: ShapeElement, _ triggerContext: TriggerContext) {
        self.shapeElement = shapeElement
        self.triggerContext = triggerContext
    }

    // MARK: Internal

    var body: some View {
        ZStack {
            Text("").position(x: 0, y: 0)
        }//.modifier(AbstractInAppRenderer(elementData: shapeElement, triggerContext: triggerContext, isContainer: false))
    }

    // MARK: Private

    private var shapeElement: ShapeElement
    private var triggerContext: TriggerContext
}
