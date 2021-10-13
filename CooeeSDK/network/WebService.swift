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
class WebService: NSObject {
    // MARK: Internal

    static let shared = WebService()

    func getResponse<T: Decodable>(fromURL: String, method: httpMethod, params: [String: Any?], header: [String: String], t: T.Type) throws -> T? {
        let url = URL(string: getCompleteURL(url: fromURL))!
        let group = DispatchGroup()
        var request = URLRequest(url: url)
        var responseData: Data?
        var responseError: Error?

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = method.rawValue
        request.httpBody = params.percentEncoded()
        request.allHTTPHeaderFields = header
        print("""
              \n-------WS Params--------\n 
              Request Body:\(params)\n
              Request Headers:\(header)\n
              Request URL:\(url)\n
              -------End WS Params--------
              """)

        group.enter()
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            responseData = data
            responseError = error
            group.leave()
        }
        task.resume()
        group.wait()
        return try processResponse(responseData, responseError, t)
    }

    // MARK: Private

    private func processResponse<T: Decodable>(_ data: Data?, _ error: Error?, _ t: T.Type) throws -> T? {
        guard let data = data,
              error == nil
                else {
            print("error", error ?? "Unknown error")
            throw error!
        }
        let responseString = String(data: data, encoding: .utf8)
        print("""
              \n-------WS Response--------\n
              \(responseString ?? "")\n
              -------End WS Response--------
              """)

        let decodedResponse = try? JSONDecoder().decode(t.self, from: data)
        return decodedResponse

    }

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
