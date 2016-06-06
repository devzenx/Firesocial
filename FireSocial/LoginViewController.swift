//
//  LoginViewController.swift
//  FireSocial
//
//  Created by yusuf_kildan on 05/06/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import UIKit
import IBAnimatable
import KRProgressHUD
class LoginViewController: UIViewController  {
    @IBOutlet weak var emailTextField: AnimatableTextField!
    @IBOutlet weak var passwordTextField: AnimatableTextField!


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
  
    @IBAction func login(sender: AnimatableButton) {
        KRProgressHUD.show(message: "Loading...")
        if let email = emailTextField.text where email != "" ,let password = passwordTextField.text where password != "" {
            DataService.instance.REF_BASE.authUser(email, password: password, withCompletionBlock: { error, authData in
                
                if error == nil {
                    KRProgressHUD.showSuccess(message: "Success!")
                    self.performSegueWithIdentifier("loginToMain", sender: nil)
                    
                }else if ERROR_WRONG_PASSWORD == error.code{
                    KRProgressHUD.showError(progressHUDStyle: KRProgressHUDStyle.BlackColor, maskType: KRProgressHUDMaskType.Black, activityIndicatorStyle: KRProgressHUDActivityIndicatorStyle.Black, font: UIFont(name: "Avenir-Light", size: 13.0), message: "Wrong Password!")
                }else if ERROR_INVALID_EMAIL == error.code {
                    KRProgressHUD.showError(progressHUDStyle: KRProgressHUDStyle.BlackColor, maskType: KRProgressHUDMaskType.Black, activityIndicatorStyle: KRProgressHUDActivityIndicatorStyle.Black, font: UIFont(name: "Avenir-Light", size: 13.0), message: "Invalid Email!")
                }else if ERROR_USER_NOT_EXIST == error.code {
                    KRProgressHUD.showError(progressHUDStyle: KRProgressHUDStyle.BlackColor, maskType: KRProgressHUDMaskType.Black, activityIndicatorStyle: KRProgressHUDActivityIndicatorStyle.Black, font: UIFont(name: "Avenir-Light", size: 13.0), message: "SignUp Before Login!")
                }else {
                    print(error)
                }
                
            })
        }else {
            KRProgressHUD.showError(progressHUDStyle: KRProgressHUDStyle.BlackColor, maskType: KRProgressHUDMaskType.Black, activityIndicatorStyle: KRProgressHUDActivityIndicatorStyle.Black, font: UIFont(name: "Avenir-Light", size: 13.0), message: "Fill All Areas!")
        }
        
    }
    @IBAction func createAccount(sender: UIButton) {
        performSegueWithIdentifier("loginToSignUp", sender: nil)
        
    }
    @IBAction func resetPassword(sender: UIButton) {
    }
    
  

}
