//
//  ShapeRenderer.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 23/11/21.
//

import Foundation
import SwiftUI

/**
 Check for shape element and renders a ZStack with base element properties

 - Author: Ashish Gaikwad
 - Since: 1.3.0
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
        }
    }

    // MARK: Private

    private var shapeElement: ShapeElement
    private var triggerContext: TriggerContext
}
