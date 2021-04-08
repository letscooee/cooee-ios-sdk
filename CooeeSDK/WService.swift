//
//  WService.swift
//  SDKTesting
//
//  Created by Surbhi Lath on 05/02/21.
//

import Foundation

class WService: NSObject {
    
    static let shared = WService()
    
    func getResponse<T: Decodable>(fromURL:String, method: httpMethod, params: [String: Any], header: [String: String],  completionHandler: @escaping(_ result: T) -> ()){
        let url = URL(string: getCompleteURL(urlString: fromURL))!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = method.rawValue
        request.httpBody = params.percentEncoded()
        request.allHTTPHeaderFields = header
        print("\n-------WS Params--------\n\(params)\n\n\(header)\nComplete URL \n\(url)\n")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let _ = response as? HTTPURLResponse,
                  error == nil else {
                print("error", error ?? "Unknown error")
                return
            }
            let responseString = String(data: data, encoding: .utf8)
            print("\n-------WS Response--------\n\(responseString ?? "")\n")
            
            if let decodedResponse = try? JSONDecoder().decode(T.self, from: data) {
                DispatchQueue.main.async {
                    completionHandler(decodedResponse)
                }
                return
            }
        }
        task.resume()
    }
    
    private func getCompleteURL(urlString:String) -> String {
        let completeURL :String
        if urlString.contains("http")||urlString.contains("https") {
            completeURL = urlString
        }else{
            completeURL =  URLS.baseURL + urlString
        }
        return completeURL
    }
}


enum httpMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
}

extension Dictionary {
    func percentEncoded() -> Data? {
        let jsonData = try! JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        return jsonData
    }
}
