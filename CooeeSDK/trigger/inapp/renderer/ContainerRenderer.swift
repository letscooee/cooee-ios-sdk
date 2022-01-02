//
// Created by Ashish Gaikwad on 27/10/21.
//

import Foundation
import SwiftUI
import UIKit

/**
 Renders the top most container of the in-app.

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
struct ContainerRenderer: View {
    // MARK: Lifecycle

    init(inAppTrigger data: InAppTrigger, _ triggerContext: TriggerContext) {
        self.container = data.cont!
        self.elements = data.elems!
        self.triggerContext = triggerContext
    }

    // MARK: Internal

    let deviceWidth = UIScreen.main.bounds.width
    let deviceHeight = UIScreen.main.bounds.height

    var body: some View {

        ZStack(alignment: .topLeading) {
            ZStack {
                Text("").position(x: 0, y: 0)
            }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

                //.blur(radius: 18)


            ElementRenderer(elements, triggerContext).background(Color.white.opacity(0))
        }
        .modifier(AbstractInAppRenderer(elementData: container, triggerContext: triggerContext, isContainer: true))
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }

    // MARK: Private

    private var container: Container
    private var elements: [[String: Any]]
    private var triggerContext: TriggerContext
}