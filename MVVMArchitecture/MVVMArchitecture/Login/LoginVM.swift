//
//  LoginVM.swift
//  MVVMArchitecture
//
//  Created by Tejora on 05/02/20.
//  Copyright © 2020 Tejora. All rights reserved.
//

import UIKit

class LoginVM {
 var movieModel: [MovieModel]?
 func validateLoginTxtField(username: String, password: String) -> String? {
    if username.isEmpty {
        return "Please enter username."
    } else if password.isEmpty {
        return "Please enter password."
    } else {
        return nil
    }
 }
    
    func fetchData(completionHandler: @escaping (_ errorMsg: String?) -> Void) {
        MVVMApp.appInstance.networkClient.ApiRequestwith(inpParam: nil, methodName: HttpMethodType.get.rawValue, ApiName: .apiFetchData) { (error, result, response) in
            print("result is \(result as! [String: Any])")
            
            if error == nil {
                do {
                    let data =  try JSONSerialization.data(withJSONObject: result as! [String: Any], options: .prettyPrinted)
                    let movieRecords = try JSONDecoder().decode(LoginModel.self, from: data)
                    self.movieModel = movieRecords.records
                    completionHandler(nil)
                } catch let error {
                    print("error is \(error)")
                    completionHandler(error.localizedDescription)
                }
            } else {
                completionHandler(error?.localizedDescription)
            }
        }
    }

}
