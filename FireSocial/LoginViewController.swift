//
//  LoginViewController.swift
//  FireSocial
//
//  Created by yusuf_kildan on 05/06/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import UIKit
import IBAnimatable
class LoginViewController: UIViewController {
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var emailTextField: AnimatableTextField!
    @IBOutlet weak var passwordTextField: AnimatableTextField!


    override func viewDidLoad() {
        super.viewDidLoad()
      
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
      logoImage.hidden = true
    }
    
    func keyboardWillHide(notification: NSNotification) {
      logoImage.hidden = false
    }
    @IBAction func login(sender: AnimatableButton) {
        
        
    }
    @IBAction func createAccount(sender: UIButton) {
        performSegueWithIdentifier("loginToSignUp", sender: nil)
        
    }
    @IBAction func resetPassword(sender: UIButton) {
    }

}
