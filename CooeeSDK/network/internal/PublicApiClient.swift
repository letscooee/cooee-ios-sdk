//
//  PublicApiClient.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 21/12/21.
//

import Foundation
import UIKit

/**
 Provide access to those Cooee API which provide app configurations

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
class PublicApiClient {
    static let shared = PublicApiClient()

    /**
     Gets app configuration from server

     - Parameter appID: appID provided by COOEE
     - Returns: Dictionary of App Configuration
     - Throws: Network errors
     */
    func getAppConfig(appID: String) throws -> [String: Any]? {
        let group = DispatchGroup()
        let url = URL(string: "\(Constants.BASE_URL)\(Constants.appConfig)\(appID)")!
        let request = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        var capturedError: Error?
        var responseMap: [String: Any]?

        group.enter()
        let task = session.dataTask(with: request, completionHandler: { data, _, error in
            if error == nil {
                responseMap = String(data: data!, encoding: .utf8)?.convertToDictionary()
                print("""
                \n-------WS Response--------\n
                \(String(describing: responseMap))\n
                -------End WS Response--------
                """)
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

        return responseMap
    }

    /**
     Sends giver Image to the server with is Screen name
     - Parameters:
       - imageToUpload: Scree image
       - screenName: screen name
       - header: request headers
     - Returns: dictionary of response sent by server
     - Throws: Error
     */
    func uploadImage(imageToUpload: UIImage, screenName: String, header: [String: String]) throws -> [String: Any]? {
        let group = DispatchGroup()
        var capturedError: Error?
        var responseMap: [String: Any]?
        let url = NSURL(string: "\(Constants.BASE_URL)\(Constants.uploadScreenshot)")
        let request = NSMutableURLRequest(url: url! as URL)

        let param = [
            "screenName": screenName
        ]

        let boundary = generateBoundaryString()
        let imageData = imageToUpload.pngData()

        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        if imageData == nil {
            return nil
        }

        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file",
                imageDataKey: imageData! as NSData, boundary: boundary, screenName: screenName) as Data
        request.allHTTPHeaderFields = header

        group.enter()

        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, _, error in

            if error == nil {
                responseMap = String(data: data!, encoding: .utf8)?.convertToDictionary()
                print("""
                      \n-------WS Response--------\n
                      \(String(describing: responseMap))\n
                      -------End WS Response--------
                      """)
            } else {
                capturedError = error
            }
            group.leave()
        }

        task.resume()
        group.wait()

        if capturedError != nil {
            throw capturedError!
        }

        return responseMap
    }

    /**
     Creates request body with multipart data and other parameters
     - Parameters:
       - parameters: parameters other than image
       - filePathKey:  type of file
       - imageDataKey: image data
       - boundary: unique id
       - screenName: screen name
     - Returns: request body
     */
    private func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String, screenName: String) -> NSData {
        let body = NSMutableData()

        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }

        let filename = "\(screenName).png"
        let mimetype = "image/png"

        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        body.appendString(string: "--\(boundary)--\r\n")

        return body
    }

    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}
