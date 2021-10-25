//
//  File.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 20/09/21.
//

import Foundation

/**
 Send any request to server

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class WService: NSObject {
    // MARK: Internal

    static let shared = WService()

    func getResponse<T: Decodable>(fromURL: String, method: httpMethod, params: [String: Any], header: [String: String], completionHandler: @escaping (_ result: T) -> ()) {
        let finalParams = appendSessionID(params: params)
        let url = URL(string: getCompleteURL(url: fromURL))!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = method.rawValue
        request.httpBody = finalParams.percentEncoded()
        request.allHTTPHeaderFields = header
        print("""
              \n-------WS Params--------\n 
              Request Body:\(finalParams)\n
              Request Headers:\(header)\n
              Request URL:\(url)\n
              -------End WS Params--------
              """)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let _ = response as? HTTPURLResponse,
                  error == nil
                    else {
                print("error", error ?? "Unknown error")
                return
            }
            let responseString = String(data: data, encoding: .utf8)
            print("""
                  \n-------WS Response--------\n
                  \(responseString ?? "")\n
                  -------End WS Response--------
                  """)

            if let decodedResponse = try? JSONDecoder().decode(T.self, from: data) {
                DispatchQueue.main.async {
                    completionHandler(decodedResponse)
                }
                return
            }
        }
        task.resume()
    }

    // MARK: Private

    private func appendSessionID(params: [String: Any?]) -> [String: Any?] {
        var updatedParam = [String: Any?]()
        updatedParam.merge(params) { _, new in
            new
        }
        updatedParam.updateValue(SessionManager.shared.getCurrentSessionID(), forKey: "sessionID")
        updatedParam.updateValue(SessionManager.shared.getCurrentSessionNumber(), forKey: "sessionNumber")
        return updatedParam
    }

    private func getCompleteURL(url: String) -> String {
        let completeURL: String
        if url.contains(Constants.BASE_URL) {
            completeURL = url
        } else {
            completeURL = Constants.BASE_URL + url
        }
        return completeURL
    }
}

enum httpMethod: String {
    case GET
    case POST
    case PUT
}

extension Dictionary {
    func percentEncoded() -> Data? {
        let jsonData = try! JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        return jsonData
    }
}
