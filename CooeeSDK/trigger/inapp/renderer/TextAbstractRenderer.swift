//
//  TextAbstractRenderer.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 26/08/22.
//

import Foundation
import SwiftUI
import UIKit

/**
 Process base properties for TextElement

 - Author: Ashish Gaikwad
 - Since: 1.3.17
 */
struct TextAbstractRenderer: ViewModifier {
    var elementData: BaseElement
    var triggerContext: TriggerContext
    let deviceWidth = UIScreen.main.bounds.width
    let deviceHeight = UIScreen.main.bounds.height

    @ViewBuilder func body(content: Content) -> some View {
        let calculatedHeight = elementData.getCalculatedHeight()
        let calculatedWidth = elementData.getCalculatedWidth()
        let calculatedX = elementData.getX(for: calculatedWidth ?? 0)
        let calculatedY = elementData.getY(for: calculatedHeight ?? 0)

        content.if(elementData.br != nil) {
                    $0.cornerRadius(elementData.br!.getRadius())
                }
                .if(elementData.shd != nil) {
                    $0.shadow(radius: CGFloat(elementData.shd!.getElevation()), x: 20, y: 20)
                }
                .if(elementData.trf != nil) {
                    $0.rotationEffect(elementData.trf!.getRotation())
                }
                .if(calculatedWidth != nil && calculatedHeight != nil) {
                    $0.frame(width: calculatedWidth!, height: calculatedHeight!)
                }
                .if(calculatedWidth != nil && calculatedHeight == nil) {
                    $0.width(calculatedWidth!)
                }
                .if(calculatedWidth == nil && calculatedHeight != nil) {
                    $0.height(calculatedHeight!)
                }
                .if(elementData.getX() != 0.0 || elementData.getY() != 0.0) {
                    $0.offset(x: calculatedX, y: calculatedY)
                }
                .gesture(
                        TapGesture()
                                .onEnded { _ in
                                    if let clickAction = self.elementData.getClickAction() {
                                        ClickActionExecutor(clickAction, self.triggerContext).execute()
                                    }
                                }
                )
    }
}
