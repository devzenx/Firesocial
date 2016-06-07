//
//  SignUpViewController.swift
//  FireSocial
//
//  Created by yusuf_kildan on 05/06/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import UIKit
import IBAnimatable
import Fusuma
import Firebase
import Alamofire
import KRProgressHUD

class SignUpViewController: UIViewController, FusumaDelegate{

    
    //OUTLETS
    @IBOutlet weak var userImage: AnimatableImageView!
    @IBOutlet weak var pickedUserImage: UIImageView!
    @IBOutlet weak var nameTextField: AnimatableTextField!
    @IBOutlet weak var emailTextField: AnimatableTextField!
    @IBOutlet weak var passwordTextField: AnimatableTextField!
    @IBOutlet weak var passwordTextField2: AnimatableTextField!
    
    //VARIABLES
    var isPicked : Bool = false
    var imagePicker : FusumaViewController!
    var imageLink : String!
    
    
    //FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.pickImage(_:)))
        tap.numberOfTapsRequired = 1
        pickedUserImage.addGestureRecognizer(tap)
        pickedUserImage.userInteractionEnabled = true
        imagePicker = FusumaViewController()
        imagePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    @IBAction func backToLogin(sender : UIButton) {
        performSegueWithIdentifier("signUpToLogin", sender: nil)
    }
    
    @IBAction func signUp(sender: UIButton) {
        KRProgressHUD.show(progressHUDStyle: KRProgressHUDStyle.Black, maskType: KRProgressHUDMaskType.Black, activityIndicatorStyle: KRProgressHUDActivityIndicatorStyle.Black, font: ERROR_ALERT_FONT, message: "User Creating!", image: nil)
        if let email = emailTextField.text where email != "" ,
            let password = passwordTextField.text where password != "" ,
            let password2 = passwordTextField2.text where password2 != "",
            let username = nameTextField.text where username != "",
            let image = userImage.image{
            
            if password2 == password {
                DataService.instance.REF_BASE.authUser(email, password: password, withCompletionBlock: { error,authData in
                    if error != nil {
                        if ERROR_USER_NOT_EXIST == error.code {
                            DataService.instance.REF_BASE.createUser(email, password: password, withCompletionBlock: { error in
                                if error == nil {
                                    DataService.instance.REF_BASE.authUser(email, password: password, withCompletionBlock: { error, authData in
                                        if error == nil {
                                            
                                            UploadImageService.instance.upload(image, completion: { (result) in
                                                let user = ["username" : username , "provider" : authData.provider! , "email"  : email , "profileImageUrl" : result]
                                                DataService.instance.createUser(authData.uid, user: user)
                                                NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKeyPath: KEY_UID)
                                            })
                                            KRProgressHUD.showSuccess()
                                            self.performSegueWithIdentifier("signUpToMain", sender: nil)
                                        }else {
                                            print(error)
                                        }
                                    })
                                    
                                }
                            })
                            
                        }else if ERROR_INVALID_EMAIL == error.code {
                           self.showErrorAlert("Invalid Email!")
                        }else if ERROR_WRONG_PASSWORD == error.code {
                              self.showErrorAlert("Wrong Password!")
                        }
                    }else {
                       self.showErrorAlert("Registered Email!")
                       
                    }
                })
                }else {
                    self.showErrorAlert("Mismatched Passwords!")
            
            }
        }else {
            if userImage.image == nil {
            self.showErrorAlert("Select Profile Image")
            }else {
                self.showErrorAlert("Fill All Areas!")}
        }
    }
    
    @IBAction func signIn(sender: UIButton) {
         performSegueWithIdentifier("signUpToLogin", sender: self)
    }
    
    func pickImage(sender : UITapGestureRecognizer) {
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
  
    func fusumaImageSelected(image: UIImage) {
        
        userImage.hidden = false
        pickedUserImage.image = UIImage(named: "")
        userImage.image = image
      
        print("Image selected")
    }
    
    
    func fusumaCameraRollUnauthorized() {
      self.showErrorAlert("Camera roll unauthorized")
    }
    
    func showErrorAlert(message : String) {
    
         KRProgressHUD.showError(progressHUDStyle: KRProgressHUDStyle.BlackColor, maskType: KRProgressHUDMaskType.Black, activityIndicatorStyle: KRProgressHUDActivityIndicatorStyle.Black, font: UIFont(name: "Avenir-Light", size: 13.0), message: message)
    }
  
 

}
