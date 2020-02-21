//
//  NetworkClient.swift
//  NSUrlSessionTuto
//
//  Created by apple on 13/06/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

let timeInterval : Double  = 100
var BaseUrl      : String  = "https://itunes.apple.com/"

enum endPoints : String {
    case fetchData = "search?media=music&term=bollywood"
}

enum APIPoints: String {
    case apiFetchData
}

enum HttpMethodType : String {
    case get    = "GET"
    case delete = "DELETE"
    case post   = "POST"
    case put    = "PUT"
}


class NetworkClient: NSObject {
    /*
     Method Name   : makeApiTypeRequest
     Functionality : make diffrent type of url request
     */
    func makeApiTypeRequest(urlString: String, methodName: String , inpParam: Any?) -> URLRequest {
        let urlForRequest = urlString
        let strEscaped = urlForRequest.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let strUrl = URL(string: strEscaped!)
        var request = URLRequest(url: strUrl!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: timeInterval)
        if methodName == HttpMethodType.get.rawValue || methodName == HttpMethodType.delete.rawValue {
            let headers = [
                    "Content-Type": "application/json"
                ]
                request.allHTTPHeaderFields = headers
        }
        else if methodName == HttpMethodType.post.rawValue || methodName == HttpMethodType.put.rawValue{
            let headers = [
                    "Content-Type": "application/json"
                ]
                request.allHTTPHeaderFields = headers
        }
        if methodName == HttpMethodType.post.rawValue {
            if inpParam != nil {
               // request.encodeParameters(parameters: inpParam as! [String : Any])
                 request.httpBody =  try? JSONSerialization.data(withJSONObject: inpParam!, options: [])
            }
        }
        request.httpMethod = methodName
        return request;
    }
    
    
    func apiReq(request: URLRequest ,completionHandlerForResp:@escaping (_ responseHttp:HTTPURLResponse? , _ respData: Data? , _ error: Error? ) -> Void) {
        
        print("Start: \(Date())")
        print("request final url: \(String(describing: request.url?.absoluteString))")
        
        DispatchQueue.global(qos: .background).async {
            
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest  = 140.0
            sessionConfig.timeoutIntervalForResource = 140.0
            
            (URLSession(configuration: URLSessionConfiguration.default)).dataTask(with: request, completionHandler: {(respData, responseHttp, error) in
                DispatchQueue.main.async {
                    print("End: \(Date())")
                    if error != nil
                    {
                        
                        completionHandlerForResp(responseHttp as? HTTPURLResponse,respData, error)
                    }
                    do
                    {
                        if (responseHttp as? HTTPURLResponse) != nil
                        {
                            if (responseHttp as? HTTPURLResponse)?.statusCode == 200
                            {
                                completionHandlerForResp(responseHttp as? HTTPURLResponse,respData, error)
                            }
                            else if (responseHttp as? HTTPURLResponse)?.statusCode == 401
                            {
                                completionHandlerForResp(responseHttp as? HTTPURLResponse,respData, error)
                            }
                            else if (responseHttp as? HTTPURLResponse)?.statusCode == 404
                            {
                                completionHandlerForResp(responseHttp as? HTTPURLResponse,respData, error)
                            }
                            else if (responseHttp as? HTTPURLResponse)?.statusCode == 400
                            {
                                completionHandlerForResp(responseHttp as? HTTPURLResponse,respData, error)
                            }
                            else if (responseHttp as? HTTPURLResponse)?.statusCode == 422
                            {
                                completionHandlerForResp(responseHttp as? HTTPURLResponse,respData, error)
                            }
                            else
                            {
                                print("error is \(String(describing: error?.localizedDescription))")
                                completionHandlerForResp(responseHttp as? HTTPURLResponse,respData, error)
                            }
                        }
                    }
                    catch let error as NSError
                    {
                        completionHandlerForResp(responseHttp as? HTTPURLResponse,nil, error)
                    }
                }
            }).resume()
            
        }
    }
    
    // MARK: API Call
    func ApiRequestwith(inpParam : Any?,methodName: String ,ApiName: APIPoints , completionHandlerForResp : @escaping (_ error: Error? , _ result:Any , _ responseHttp:HTTPURLResponse?) -> Void) {
        
        var request: URLRequest!
        
        request = self.makeApiTypeRequest(urlString: UrlStringForAPI(APIName: ApiName) , methodName: methodName, inpParam: inpParam)
        print("Request for \(String(describing: request.url?.absoluteString))")
        print("Data: \(String(describing: inpParam)) \n Type: \(methodName)")
        self.apiReq(request: request) { (responseHttp, respData, error) in
            if error == nil{
                if respData != nil {
                    let result = try? JSONSerialization.jsonObject(with: respData!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    print("response is \(String(describing: result))")
                    completionHandlerForResp(error,result as Any,responseHttp!)
                }else{
                    completionHandlerForResp(error,respData as Any,responseHttp!)
                }
            }else{
                completionHandlerForResp(error,respData as Any,responseHttp)
            }
            
        }
    }
    
    
    func UrlStringForAPI(APIName: APIPoints) -> String
    {
        var url: String!
        switch APIName {
        case .apiFetchData:
            url = BaseUrl + endPoints.fetchData.rawValue
        }
        
        return url
    }
}

public func showAlert(_ message : String, viewController : UIViewController, okayButtonTapped : @escaping () -> Void) {
    let alert = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
        okayButtonTapped()
    }))
    
    viewController.present(alert, animated: true, completion: nil)
}
