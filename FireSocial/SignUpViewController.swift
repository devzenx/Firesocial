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

 
   
    @IBOutlet weak var userImage: AnimatableImageView!
    @IBOutlet weak var pickedUserImage: UIImageView!
    @IBOutlet weak var nameTextField: AnimatableTextField!
    @IBOutlet weak var emailTextField: AnimatableTextField!
    @IBOutlet weak var passwordTextField: AnimatableTextField!
    @IBOutlet weak var passwordTextField2: AnimatableTextField!
    var isPicked : Bool = false
    var imagePicker : FusumaViewController!
    var imageLink : String!
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
                                            self.performSegueWithIdentifier("signUpToMain", sender: nil)
                                        }else {
                                            print(error)
                                        }
                                    })
                                    
                                }
                            })
                            
                        }else if ERROR_INVALID_EMAIL == error.code {
                            KRProgressHUD.showError(progressHUDStyle: KRProgressHUDStyle.BlackColor, maskType: KRProgressHUDMaskType.Black, activityIndicatorStyle: KRProgressHUDActivityIndicatorStyle.Black, font: UIFont(name: "Avenir-Light", size: 13.0), message: "Invalid Email!")
                        }else if ERROR_WRONG_PASSWORD == error.code {
                              KRProgressHUD.showError(progressHUDStyle: KRProgressHUDStyle.BlackColor, maskType: KRProgressHUDMaskType.Black, activityIndicatorStyle: KRProgressHUDActivityIndicatorStyle.Black, font: UIFont(name: "Avenir-Light", size: 13.0), message: "Wrong Password!")
                        }
                    }else {
                         KRProgressHUD.showError(progressHUDStyle: KRProgressHUDStyle.BlackColor, maskType: KRProgressHUDMaskType.Black, activityIndicatorStyle: KRProgressHUDActivityIndicatorStyle.Black, font: UIFont(name: "Avenir-Light", size: 13.0), message: "Registered Email!")
                       
                    }
                })
                }else {
                 KRProgressHUD.showError(progressHUDStyle: KRProgressHUDStyle.BlackColor, maskType: KRProgressHUDMaskType.Black, activityIndicatorStyle: KRProgressHUDActivityIndicatorStyle.Black, font: UIFont(name: "Avenir-Light", size: 13.0), message: "Mismatched Passwords!")            }
        }else {
             KRProgressHUD.showError(progressHUDStyle: KRProgressHUDStyle.BlackColor, maskType: KRProgressHUDMaskType.Black, activityIndicatorStyle: KRProgressHUDActivityIndicatorStyle.Black, font: UIFont(name: "Avenir-Light", size: 13.0), message: "Fill All Areas!")
           
        }
    }
    @IBAction func signIn(sender: UIButton) {
         performSegueWithIdentifier("signUpToLogin", sender: self)
    }
    func pickImage(sender : UITapGestureRecognizer) {
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    //ImagePicker Delegate Functions
    func fusumaImageSelected(image: UIImage) {
        
        userImage.hidden = false
        pickedUserImage.image = UIImage(named: "")
        userImage.image = image
      
        print("Image selected")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }
    
  
 

}
