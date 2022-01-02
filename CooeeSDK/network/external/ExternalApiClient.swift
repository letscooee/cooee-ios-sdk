//
//  ExternalApiClient.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 21/12/21.
//

import Foundation

/**
 Provide a access any external API other than Cooee's APIs
 
 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
class ExternalApiClient {
    static let shared = ExternalApiClient()

    /**
     Downloads file from given <code>webURL</code> at given <code>filePath</code> path

     - Parameters:
       - webURL: URL to send http/https request
       - filePath: URL of storage path to store file locally
     - Throws:
     */
    func downloadFile(webURL: URL, filePath: URL) throws {
        let group = DispatchGroup()
        let request = URLRequest(url: webURL)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        var capturedError: Error?
        group.enter()
        let task = session.dataTask(with: request, completionHandler: { data, _, error in
            if error == nil {
                if let fileData = data {
                    do {
                        try fileData.write(to: filePath, options: .atomic)
                    } catch let writeError {
                        capturedError = writeError
                    }
                }
            } else {
                capturedError = error
            }
            group.leave()
        })
        task.resume()
        group.wait()

        if capturedError != nil {
            throw capturedError!
        }
    }
}
