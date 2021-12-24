//
//  ShapeRenderer.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 23/11/21.
//

import Foundation
import SwiftUI

struct ShapeRenderer: View {
    // MARK: Lifecycle

    init(_ shapeElement: ShapeElement, _ triggerContext: TriggerContext) {
        self.shapeElement = shapeElement
        self.triggerContext = triggerContext
    }

    // MARK: Internal

    var body: some View {
        ZStack {}.modifier(AbstractInAppRenderer(elementData: shapeElement, triggerContext: triggerContext))
    }

    // MARK: Private

    private var shapeElement: ShapeElement
    private var triggerContext: TriggerContext
}
