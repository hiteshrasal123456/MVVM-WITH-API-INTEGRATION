//
//  LoginVc.swift
//  MVVMArchitecture
//
//  Created by Tejora on 05/02/20.
//  Copyright © 2020 Tejora. All rights reserved.
//

import UIKit

class LoginVc: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    var loginVmObj = LoginVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("records count \(self.loginVmObj.movieModel?.count ?? 0)")
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if let errorMsg = self.loginVmObj.validateLoginTxtField(username: self.txtUsername.text!, password: self.txtPassword.text!) {
            print("error message is \(errorMsg)")
            showAlert(errorMsg, viewController: self) {
                
            }
        } else {
            print("validation success")
            self.loginVmObj.fetchData { (errorMsg) in
                if errorMsg == nil {
                   print("records count \(self.loginVmObj.movieModel?.count ?? 0)")
                    showAlert("records count \(self.loginVmObj.movieModel?.count ?? 0)", viewController: self) {
                        
                    }
                } else {
                    print("error is \(String(describing: errorMsg))")
                    showAlert("error is \(String(describing: errorMsg))", viewController: self) {
                        
                    }
                    
                }
            }
            
        }
    }
}
