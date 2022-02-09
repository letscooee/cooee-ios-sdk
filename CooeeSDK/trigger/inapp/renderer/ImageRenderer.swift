//
// Created by Ashish Gaikwad on 27/10/21.
//

import Foundation
import SwiftUI
/**
 Renders a ImageElement

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct ImageRenderer<Placeholder: View, ConfiguredImage: View>: View {
    // MARK: Lifecycle

    init(
        url: URL,
        @ViewBuilder placeholder: @escaping () -> Placeholder,
        @ViewBuilder image: @escaping (GIFImageView) -> ConfiguredImage,
        data: BaseElement
    ) {
        self.url = url
        self.placeholder = placeholder
        self.image = image
        self.baseData = data
        self.imageLoader = ImageLoaderService(url: url)
    }

    // MARK: Internal

    var url: URL
    @ObservedObject var imageLoader: ImageLoaderService
    @State var imageData: UIImage?

    var body: some View {
        imageContent
            .onReceive(imageLoader.$image) { imageData in
                self.imageData = imageData
            }
    }

    // MARK: Private

    private let placeholder: () -> Placeholder
    private let image: (GIFImageView) -> ConfiguredImage
    private let baseData: BaseElement

    @ViewBuilder private var imageContent: some View {
        if let data = imageData {
            image(GIFImageView(imageData: data, baseElement: baseData))
        } else {
            placeholder()
        }
    }
}

class ImageLoaderService: ObservableObject {
    // MARK: Lifecycle

    convenience init(url: URL) {
        self.init()
        loadImage(for: url)
    }

    // MARK: Internal

    @Published var image = UIImage()

    func loadImage(for url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.image = UIImage.gif(data: data)!
            }
        }
        task.resume()
    }
}
