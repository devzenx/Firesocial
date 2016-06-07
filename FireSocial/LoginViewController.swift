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
    
    override func viewDidAppear(animated: Bool) {
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier("loginToMain", sender: nil)
        }
    }
  
    @IBAction func login(sender: AnimatableButton) {
        KRProgressHUD.show(progressHUDStyle: KRProgressHUDStyle.Black, maskType: KRProgressHUDMaskType.Black, activityIndicatorStyle: KRProgressHUDActivityIndicatorStyle.Black, font: ERROR_ALERT_FONT, message: "Loading", image: nil)
        if let email = emailTextField.text where email != "" ,let password = passwordTextField.text where password != "" {
            DataService.instance.REF_BASE.authUser(email, password: password, withCompletionBlock: { error, authData in
                
                if error == nil {
                    print(authData.uid)
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKeyPath: KEY_UID)
                    KRProgressHUD.showSuccess(message: "Success!")
                    self.performSegueWithIdentifier("loginToMain", sender: nil)
                    
                }else if ERROR_WRONG_PASSWORD == error.code{
                   self.showErrorAlert("Wrong Password!")
                }else if ERROR_INVALID_EMAIL == error.code {
                    self.showErrorAlert("Invalid Email!")
                }else if ERROR_USER_NOT_EXIST == error.code {
                   self.showErrorAlert("SignUp Before Login!")
                }else {
                    print(error)
                }
                
            })
        }else {
            KRProgressHUD.showError(progressHUDStyle: KRProgressHUDStyle.BlackColor, maskType: KRProgressHUDMaskType.Black, activityIndicatorStyle: KRProgressHUDActivityIndicatorStyle.Black, font: ERROR_ALERT_FONT, message: "Fill All Areas!")
        }
        
    }
    
    @IBAction func createAccount(sender: UIButton) {
        performSegueWithIdentifier("loginToSignUp", sender: nil)
    }
    @IBAction func resetPassword(sender: UIButton) {
        let alert = UIAlertController(title: "Reset Your Password", message: "Enter your email to reset your password", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Email"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Reset", style: UIAlertActionStyle.Default, handler: { action in
            
            let ref = DataService.instance.REF_BASE
            ref.resetPasswordForUser(alert.textFields![0].text!, withCompletionBlock: { error in
                if error == nil {
                    KRProgressHUD.showSuccess(progressHUDStyle: KRProgressHUDStyle.Black, maskType: KRProgressHUDMaskType.Black, activityIndicatorStyle: KRProgressHUDActivityIndicatorStyle.Black, font: ERROR_ALERT_FONT, message: "Check your email")
                }else if ERROR_INVALID_EMAIL == error.code {
                    self.showErrorAlert("Invalid Email")
                }
            })
            
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(message : String){
     KRProgressHUD.showError(progressHUDStyle: KRProgressHUDStyle.BlackColor, maskType: KRProgressHUDMaskType.Black, activityIndicatorStyle: KRProgressHUDActivityIndicatorStyle.Black, font: ERROR_ALERT_FONT, message: message)
    }

}
