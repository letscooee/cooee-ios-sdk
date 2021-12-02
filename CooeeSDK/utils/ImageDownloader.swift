//
//  ImageDownloader.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 02/12/21.
//

import Foundation
import UIKit

public class ImageDownloader {
    // MARK: Lifecycle

    private init() {}

    // MARK: Public

    public static let shared = ImageDownloader()

    public func downloadImage(forURL url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
      
            guard let data = data else {
                completion(.failure(CustomError.emptyData))
                return
            }
      
            guard let image = UIImage(data: data) else {
                completion(.failure(CustomError.invalidImage))
                return
            }
      
            completion(.success(image))
        }
    
        task.resume()
    }
}
