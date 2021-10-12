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

    func getResponse<T: Decodable>(fromURL: String, method: httpMethod, params: [String: Any], header: [String: String], completionHandler: @escaping (_ result: T?, _ error: Error?) -> ()) throws {
        let url = URL(string: getCompleteURL(urlString: fromURL))!
        let group = DispatchGroup()
        var request = URLRequest(url: url)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = method.rawValue
        request.httpBody = params.percentEncoded()
        request.allHTTPHeaderFields = header

        print("\n-------WS Params--------\n\(params)\n\n\(header)\nComplete URL \n\(url)\n")

        group.enter()
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            group.leave()
            guard let data = data,
                  let _ = response as? HTTPURLResponse,
                  error == nil
                    else {
                print("error", error ?? "Unknown error")
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            let responseString = String(data: data, encoding: .utf8)
            print("\n-------WS Response--------\n\(responseString ?? "")\n")

            if let decodedResponse = try? JSONDecoder().decode(T.self, from: data) {
                DispatchQueue.main.async {
                    completionHandler(decodedResponse, nil)
                }
                return
            }
        }
        task.resume()
        group.wait()
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

    private func getCompleteURL(urlString: String) -> String {
        let completeURL: String
        if urlString.contains(EndPoints.BASE_URL) {
            completeURL = urlString
        } else {
            completeURL = EndPoints.BASE_URL + urlString
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
