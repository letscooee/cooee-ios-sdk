//
//  PublicApiClient.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 21/12/21.
//

import Foundation

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
}
