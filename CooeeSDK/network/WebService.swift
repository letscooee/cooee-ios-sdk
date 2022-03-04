//
//  File.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 20/09/21.
//

import Foundation
import HandyJSON

/**
 Send any request to server

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class WebService: NSObject {
    // MARK: Internal

    override init() {
        debugging = SDKInfo.shared.cachedInfo.isDebugging
    }

    let debugging: Bool

    static let shared = WebService()

    func getResponse(fromURL: String, method: httpMethod, params: [String: Any?], header: [String: String]) throws -> [String: Any]? {
        let url = URL(string: getCompleteURL(url: fromURL))!
        let group = DispatchGroup()
        var request = URLRequest(url: url)
        var responseData: Data?
        var responseError: Error?

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = method.rawValue
        if method != .GET {
            request.httpBody = params.percentEncoded()
        }
        request.allHTTPHeaderFields = header

        let eventName = params["name"] as? String ?? ""
        NSLog("Request: Method=\(method.rawValue), URL=\(url.path), Event=\(eventName)")
        if debugging {
            NSLog("""
                  \n-------WS Params--------\n
                  Request Body:\(params)\n
                  -------End WS Params--------
                  """)
        }

        group.enter()
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            responseData = data
            responseError = error
            group.leave()
        }
        task.resume()
        group.wait()
        return try processResponse(responseData, responseError)
    }

    // MARK: Private

    private func processResponse(_ data: Data?, _ error: Error?) throws -> [String: Any]? {
        guard let data = data, error == nil else {
            throw error!
        }

        return String(data: data, encoding: .utf8)?.convertToDictionary()
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
