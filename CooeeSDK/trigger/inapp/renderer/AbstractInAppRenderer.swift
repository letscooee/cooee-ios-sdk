//
// Created by Ashish Gaikwad on 22/10/21.
//

import Foundation
import SwiftUI
import UIKit

/**
 Process all common properties from BaseElement

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
struct AbstractInAppRenderer: ViewModifier {
    var elementData: BaseElement
    var triggerContext: TriggerContext
    var isContainer: Bool = false
    var isText: Bool = false
    let deviceWidth = UIScreen.main.bounds.width
    let deviceHeight = UIScreen.main.bounds.height

    @ViewBuilder func body(content: Content) -> some View {
        // process height and width
        let calculatedHeight = elementData.getCalculatedHeight()
        let calculatedWidth = elementData.getCalculatedWidth()
        let calculatedX = elementData.getX(for: calculatedWidth ?? 0)
        let calculatedY = elementData.getY(for: calculatedHeight ?? 0)

        /*let _ = print("\(elementData)")
        let _ = print("x: \(elementData.getX()), y: \(elementData.getY())")
        let _ = print("newX: \(calculatedX)), newY: \(calculatedY)")
        let _ = print("h: \(String(describing: calculatedHeight)), w: \(String(describing: calculatedWidth)), dh: \(deviceHeight), dw: \(deviceWidth)")*/

        /// MARK: Spacing

        content.if(elementData.spc != nil) {
            $0.padding(.bottom, elementData.spc!.getPaddingBottom())
                .padding(.top, elementData.spc!.getPaddingTop())
                .padding(.leading, elementData.spc!.getPaddingLeft())
                .padding(.trailing, elementData.spc!.getPaddingRight())
        }
        .if(elementData.bg != nil && elementData.bg!.s != nil && elementData.bg!.s!.g != nil) {
            $0.background(
                LinearGradient(gradient: SwiftUI.Gradient(colors: [Color(hex: elementData.bg!.s!.g!.c1!), Color(hex: elementData.bg!.s!.g!.c2!)]), startPoint: .top, endPoint: .bottom)
            ).cornerRadius(elementData.br?.getRadius() ?? 0)
        }
        .if(elementData.bg != nil && elementData.bg!.s != nil && elementData.bg!.s!.g == nil) {
            $0.background(Color(hex: elementData.bg!.s!.getColour(), alpha: elementData.bg!.s!.getAlpha()).cornerRadius(elementData.br?.getRadius() ?? 0))
        }
        .if(elementData.bg != nil && elementData.bg!.i != nil) {
            $0.background(
                ImageRenderer(
                    url: URL(string: elementData.bg!.i!.src!)!,
                    placeholder: {
                        // Place holder should be added
                    },
                    image: {
                        $0.cornerRadius(elementData.br?.getRadius() ?? 0)
                    },
                    data:elementData
                ).cornerRadius(elementData.br?.getRadius() ?? 0)
            ).cornerRadius(elementData.br?.getRadius() ?? 0)
        }
        .if(elementData.bg != nil && elementData.bg!.i != nil) {
            $0.clipped()
        }
        .if(elementData.br != nil && elementData.br!.getStyle() == Border.Style.SOLID && isText) {
            $0.padding(.bottom, elementData.getSpacing().getPaddingBottom(add: elementData.br!.getWidth()))
                .padding(.top, elementData.getSpacing().getPaddingTop(add: elementData.br!.getWidth()))
                .padding(.leading, elementData.getSpacing().getPaddingLeft(add: elementData.br!.getWidth()))
                .padding(.trailing, elementData.getSpacing().getPaddingRight(add: elementData.br!.getWidth()))
                .overlay(
                    RoundedRectangle(cornerRadius: elementData.br!.getRadius())
                        .strokeBorder(
                            style: StrokeStyle(
                                lineWidth: elementData.br!.getWidth()
                            )
                        )
                        .foregroundColor(Color(hex: elementData.br!.getColour(), alpha: elementData.br!.getAlpha()))
                )
        }
        .if(elementData.br != nil && elementData.br!.getStyle() == Border.Style.SOLID && !isText) {
            $0.overlay(
                RoundedRectangle(cornerRadius: elementData.br!.getRadius())
                    .strokeBorder(
                        style: StrokeStyle(
                            lineWidth: elementData.br!.getWidth()
                        )
                    )
                    .foregroundColor(Color(hex: elementData.br!.getColour(), alpha: elementData.br!.getAlpha()))
            )
        }
        .if(elementData.br != nil && elementData.br!.getStyle() == Border.Style.DASH && isText) {
            $0.padding(.bottom, elementData.getSpacing().getPaddingBottom(add: elementData.br!.getWidth()))
                .padding(.top, elementData.getSpacing().getPaddingTop(add: elementData.br!.getWidth()))
                .padding(.leading, elementData.getSpacing().getPaddingLeft(add: elementData.br!.getWidth()))
                .padding(.trailing, elementData.getSpacing().getPaddingRight(add: elementData.br!.getWidth()))
                .overlay(
                    RoundedRectangle(cornerRadius: elementData.br!.getRadius())
                        .strokeBorder(
                            style: StrokeStyle(
                                lineWidth: elementData.br!.getWidth(),
                                dash: [elementData.br!.getDashGap(), elementData.br!.getDashWidth()]
                            )
                        )
                        .foregroundColor(Color(hex: elementData.br!.getColour(), alpha: elementData.br!.getAlpha()))
                )
        }
        .if(elementData.br != nil && elementData.br!.getStyle() == Border.Style.DASH && !isText) {
            $0.overlay(
                    RoundedRectangle(cornerRadius: elementData.br!.getRadius())
                        .strokeBorder(
                            style: StrokeStyle(
                                lineWidth: elementData.br!.getWidth(),
                                dash: [elementData.br!.getDashGap(), elementData.br!.getDashWidth()]
                            )
                        )
                        .foregroundColor(Color(hex: elementData.br!.getColour(), alpha: elementData.br!.getAlpha()))
                )
        }
        .if(elementData.br != nil) {
            $0.cornerRadius(elementData.br!.getRadius())
        }
        .if(elementData.shd != nil) {
            $0.shadow(radius: CGFloat(elementData.shd!.getElevation()), x: 20, y: 20)
        }
        .if(elementData.trf != nil) {
            $0.rotationEffect(elementData.trf!.getRotation())
        }
        .if(calculatedWidth != nil && calculatedHeight != nil && !isContainer) {
            $0.frame(width: calculatedWidth!, height: calculatedHeight!)
        }
        .if(calculatedWidth != nil && calculatedHeight == nil && !isContainer) {
            $0.width(calculatedWidth!)
        }
        .if(calculatedWidth == nil && calculatedHeight != nil && !isContainer) {
            $0.height(calculatedHeight!)
        }
        .if(elementData.getX() != 0.0 || elementData.getY() != 0.0) {
            $0.offset(x: calculatedX, y: calculatedY)
        }
        .gesture(
            TapGesture()
                .onEnded { _ in
                    if let clickAction = elementData.getClickAction() {
                        ClickActionExecutor(clickAction, triggerContext).execute()
                    }else if(isContainer){
                        ClickActionExecutor(ClickAction(isContainer: isContainer), triggerContext).execute()
                    }
                }
        )
    }
}
