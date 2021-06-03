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
        if NetworkMonitor.shared.isConnected{
            print("\n---------WS Params--------\n\(params)\n\n\(header)\nComplete URL\n\(url)\n")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data,
                      let _ = response as? HTTPURLResponse,
                      error == nil else {
                    self.saveRequestData(withURL: fromURL, header: header, method: method, params: params)
                    print("error", error ?? "Unknown error")
                    return
                }
                let responseString = String(data: data, encoding: .utf8)
                print("\n---------WS Response--------\n\(responseString ?? "")\n")
                
                if let decodedResponse = try? JSONDecoder().decode(T.self, from: data) {
                    DispatchQueue.main.async {
                        completionHandler(decodedResponse)
                    }
                    return
                }
            }
            task.resume()
        }else{
            saveRequestData(withURL: fromURL, header: header, method: method, params: params)
        }
    }
    
    func saveRequestData(withURL: String, header:[String: String],method: httpMethod, params: [String: Any] ){
        var requestList = UserSession.getNetworkData() ?? []
        let tempData = ["requestURL":  withURL,"header": header, "method": method.rawValue,"params": params] as [String : Any]
        requestList.append(tempData)
        UserSession.save(requestData: requestList)
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


enum httpMethod: String, Codable {
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

extension WService{
    func retry(){
        if let arrayRequests = UserSession.getNetworkData(){
            if arrayRequests.count>0{
                for request in arrayRequests{
                    if let requestURL = request["requestURL"] as? String,let method = httpMethod(rawValue: request["method"] as! String), let header = request["header"] as? [String: String], let params = request["params"] as? [String: Any]{
                        getResponse(fromURL: requestURL, method: method , params: params, header: header) { (result: TrackEventResponse) in
                        }
                    }
                    UserSession.removeAllElementsFromNetworkData()
                    
                }
            }
        }
    }
    
}
