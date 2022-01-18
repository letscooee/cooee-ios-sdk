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
        let contentAlignment = container.getGravity()

        ZStack(alignment: .topLeading) {
            ZStack {
                Text("").position(x: 0, y: 0)
            }.if (container.bg != nil && container.bg!.g != nil) {
                $0.background(BlurBackground(effect: UIBlurEffect(style: .light)))
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

            // .blur(radius: 18)
            ZStack(alignment: contentAlignment) {
                Text("").position(x: 0, y: 0)
                ZStack(alignment: .topLeading) {
                    Text("").position(x: 0, y: 0)
                    ElementRenderer(elements, triggerContext).background(Color.white.opacity(0))
                }.clipped().frame(UnitUtil.getScaledPixel(1080), UnitUtil.getScaledPixel(1920))
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        .modifier(AbstractInAppRenderer(elementData: container, triggerContext: triggerContext, isContainer: true))
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }

    // MARK: Private

    private var container: Container
    private var elements: [[String: Any]]
    private var triggerContext: TriggerContext
}

struct BlurBackground: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
