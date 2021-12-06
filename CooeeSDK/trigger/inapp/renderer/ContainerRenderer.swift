//
// Created by Ashish Gaikwad on 27/10/21.
//

import Foundation
import SwiftUI
import UIKit

/**
 Renders the top most container of the in-app.

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct ContainerRenderer: View {
    // MARK: Lifecycle

    init(inAppTrigger data: InAppTrigger, _ triggerContext: TriggerContext) {
        self.container = data.cont!
        self.elements = data.elems!
        self.triggerContext = triggerContext
    }

    // MARK: Internal

    var body: some View {
        ZStack {
            ElementRenderer(elements, triggerContext)
        }.modifier(AbstractInAppRenderer(elementData: container, triggerContext: triggerContext, isContainer: true))

    }

    // MARK: Private

    private var container: Container
    private var elements: [[String: Any]]
    private var triggerContext: TriggerContext
}
