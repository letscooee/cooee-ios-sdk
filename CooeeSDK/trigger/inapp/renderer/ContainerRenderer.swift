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
        inAppTrigger = data
        container = data.cont!
        elements = data.elems!
        self.triggerContext = triggerContext
        orientation = UIDevice.current.orientation
        displayWidth = triggerContext.getDeviceInfo().getDeviceWidth()
        displayHeight = triggerContext.getDeviceInfo().getDeviceHeight()

        if orientation == .landscapeLeft || orientation == .landscapeRight {
            displayWidth = displayWidth - (UIApplication.shared.windows.first?.safeAreaInsets.left ?? 40)
                - (UIApplication.shared.windows.first?.safeAreaInsets.right ?? 40)
        } else {
            //Will take portrait safe area padding for all other orientations
            displayHeight = displayHeight - (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 40)
                - (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 40)
        }

        updateScalingFactor()
    }

    // MARK: Internal

    var body: some View {
        let contentAlignment = inAppTrigger.getGravity()

        ZStack(alignment: .topLeading) {
            ZStack {
                Text("").position(x: 0, y: 0)
            }
            .modifier(AbstractInAppRenderer(elementData: inAppTrigger, triggerContext: triggerContext, isContainer: true))
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .edgesIgnoringSafeArea(.all)

            ZStack(alignment: contentAlignment) {
                Text("").position(x: 0, y: 0)
                ZStack(alignment: .topLeading) {
                    Text("").position(x: 0, y: 0)
                    ElementRenderer(elements, triggerContext).background(Color.white.opacity(0))
                }
                .modifier(AbstractInAppRenderer(elementData: container, triggerContext: triggerContext, isContainer: false))
                .clipped()
                .frame(UnitUtil.getScaledPixel(container.getWidth()), UnitUtil.getScaledPixel(container.getHeight()))
            }
            .frame(width: displayWidth, height: displayHeight)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }

    // MARK: Private

    private var displayWidth: CGFloat
    private var displayHeight: CGFloat

    private var container: Container
    private var elements: [[String: Any]]
    private var triggerContext: TriggerContext
    private var inAppTrigger: InAppTrigger
    private var orientation: UIDeviceOrientation

    private func updateScalingFactor() {
        let containerWidth = container.getWidth()
        let containerHeight = container.getHeight()

        var scalingFactor: Float = 1
        if displayWidth / displayHeight < CGFloat(containerWidth) / CGFloat(containerHeight) {
            scalingFactor = Float(displayWidth) / containerWidth
        } else {
            scalingFactor = Float(displayHeight) / containerHeight
        }

        UnitUtil.setScalingFactor(scalingFactor: scalingFactor)
    }
}

struct BlurBackground: UIViewRepresentable {
    var effect: UIVisualEffect?

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        UIVisualEffectView()
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = effect
    }
}
