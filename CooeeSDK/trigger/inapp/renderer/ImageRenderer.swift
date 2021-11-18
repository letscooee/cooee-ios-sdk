//
// Created by Ashish Gaikwad on 27/10/21.
//

import Foundation
import UIKit

/**
 Renders a ImageElement

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class ImageRenderer: AbstractInAppRenderer {
    // MARK: Lifecycle

    init(_ parentView: UIView, _ element: BaseElement, _ triggerContext: TriggerContext, _ isFlex: Bool) {
        super.init(triggerContext: triggerContext, elementData: element, parentElement: parentView, isFlex: isFlex)
    }

    // MARK: Internal

    override func render() -> UIView {
        let imageView = UIImageView()

        // ref. https://stackoverflow.com/a/4895327/9256497
        imageView.contentMode = .scaleAspectFit
        if let imageElement = elementData as? ImageElement {
            loadImage(imageElement.src, imageView)
        }

        newElement = imageView
        processCommonBlocks()

        return newElement!
    }

    // MARK: Private

    private func loadImage(_ url: String?, _ imageView: UIImageView) {
        if url?.isEmpty ?? true {
            return
        }

        DispatchQueue.main.async {
            let data = try? Data(contentsOf: URL(string: url!)!)
            if let imageData = data {
                if let uiImage = UIImage(data: imageData) {
                    imageView.image = uiImage
                    //self.updateSize(uiImage.size.width, uiImage.size.height)
                }
            }
        }
    }
}
