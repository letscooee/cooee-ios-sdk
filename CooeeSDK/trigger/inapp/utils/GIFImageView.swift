//
//  GIFImageView.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 03/02/22.
//

import Foundation
import UIKit
import SwiftUI

/**
 Custom view which will load both GIF and Image

 - Author: Ashish Gaikwad
 - Since: 1.3.8
 */
struct GIFImageView: UIViewRepresentable {
    var imageData: UIImage
    var baseElement: BaseElement
    let view = UIImageView()

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<GIFImageView>) {
        uiView.frame = CGRect(x: 0, y: 0, width: baseElement.getCalculatedWidth() ?? 0, height: baseElement.getCalculatedHeight() ?? 0)
        uiView.contentMode = .scaleAspectFill
        uiView.autoresizesSubviews = true
        uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        uiView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        (uiView as! UIImageView).image = imageData
    }

    func makeUIView(context: Context) -> UIView {
        view.contentMode = .scaleAspectFill
        view.autoresizesSubviews = true
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        view.image = imageData.imageResize(sizeChange: CGSize(width: baseElement.getCalculatedWidth() ?? 0, height: baseElement.getCalculatedHeight() ?? 0))
        return view
    }
}
