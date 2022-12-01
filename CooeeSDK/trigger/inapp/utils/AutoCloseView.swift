// 
// AutoCloseView.swift
// CooeeSDK
//
// Created by Ashish Gaikwad on 01/12/22.
//

import Foundation
import SwiftUI

/**
 Shows auto close countdown with progressbar

 - Author: Ashish Gaikwad
 - Since: 1.4.2
 */
struct AutoCloseView: View {
    @State var currentWidth: CGFloat = 100.0
    @State var lastSeconds: Int
    let seconds: Int
    let triggerContext: TriggerContext
    let hideProgress: Bool
    let containerWidth: CGFloat
    let containerHeight: CGFloat
    let autoClose: AutoClose

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(_ autoClose: AutoClose, _ containerWidth: CGFloat, _ containerHeight: CGFloat, _ triggerContext: TriggerContext) {
        self.autoClose = autoClose
        self.seconds = autoClose.seconds ?? 0
        self.currentWidth = containerWidth
        self.lastSeconds = seconds
        self.containerWidth = containerWidth
        self.triggerContext = triggerContext
        self.hideProgress = autoClose.hideProgress ?? false
        self.containerHeight = containerHeight
    }

    var body: some View {

        ZStack(alignment: .bottomLeading) {
            if hideProgress {
                VStack {
                }
            } else {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Closes in \(lastSeconds) Seconds")
                        .font(.system(size: 11))
                        .padding(.top, 3)
                        .padding(.leading, 5)
                        .padding(.bottom, 3)
                        .padding(.trailing, 5)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(5)

                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(autoClose.getColor())
                        .frame(width: currentWidth, height: 5)
                        .animation(.linear(duration: 1))
                }
            }
        }
            .frame(width: containerWidth, height: containerHeight, alignment: .bottomLeading)
            .onReceive(timer) { timer in
                if lastSeconds > 0 {
                    lastSeconds -= 1
                    let percents = CGFloat((CGFloat(lastSeconds) / CGFloat(seconds)) * 100)
                    currentWidth = (percents * CGFloat(containerWidth)) / 100

                } else {
                    triggerContext.closeInApp("Auto")
                    self.timer.upstream.connect().cancel()
                }
            }

    }
}
