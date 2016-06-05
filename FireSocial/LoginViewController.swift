//
//  LoginViewController.swift
//  FireSocial
//
//  Created by yusuf_kildan on 05/06/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import UIKit
import IBAnimatable
class LoginViewController: UIViewController  {
    @IBOutlet weak var emailTextField: AnimatableTextField!
    @IBOutlet weak var passwordTextField: AnimatableTextField!


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
  
    @IBAction func login(sender: AnimatableButton) {
        if let email = emailTextField.text where email != "" ,let password = passwordTextField.text where password != "" {
            DataService.instance.REF_BASE.authUser(email, password: password, withCompletionBlock: { error, authData in
                if error == nil {
                    self.performSegueWithIdentifier("loginToMain", sender: nil)
                }else if ERROR_WRONG_PASSWORD == error.code{
                    print("Please enter correct password!")
                }else if ERROR_INVALID_EMAIL == error.code {
                    print("Plesase enter valied email!")
                }else if ERROR_USER_NOT_EXIST == error.code {
                    print("Please signUp before the login")
                }else {
                    print(error)
                }
            })
        }else {
            print("Fill all areas")
        }
        
    }
    @IBAction func createAccount(sender: UIButton) {
        performSegueWithIdentifier("loginToSignUp", sender: nil)
        
    }
    @IBAction func resetPassword(sender: UIButton) {
    }
    
  

}
