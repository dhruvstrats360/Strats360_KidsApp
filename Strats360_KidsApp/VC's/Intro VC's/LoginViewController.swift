//
//  LoginViewController.swift
//  Strats360_KidsApp
//
//  Created by Strats 360 on 05/01/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtUsername: UITextField!
    
    // Models
    let CustomModel = CustomClass()
    var cameFromHomePage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // view Animation
        if cameFromHomePage{
            view.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.view.alpha = 1
            })
        }
        
        // customModel in use
        CustomModel.curveBTN(btn: btnSignUp)
        CustomModel.curveBTN(btn: btnLogin)
        CustomModel.cornerRadiusTXT(txt: txtPassword)
        CustomModel.cornerRadiusTXT(txt: txtUsername)
        
        // txtFields edits
        txtPassword.placeholder = "Password"
        txtUsername.placeholder = "User Name"
        
    }
    
    @IBAction func signUpBTNpressed(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: .main)
        let destinationVC = sb.instantiateViewController(withIdentifier: "SignUpViewController")
        navigationController?.pushViewController(destinationVC, animated: true)
    }

    @IBAction func forgetPasspressed(_ sender: UIButton) {
        
    }
    
    @IBAction func logingBTNpressed(_ sender: Any) {
        
        txtUsername.clearButtonMode = .never
        txtPassword.clearButtonMode = .never
        if let email = txtUsername.text{
            if let password = txtPassword.text{
                Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                  if let error = error as? NSError {
                      self.SignUp_error(error: error as! AuthErrorCode)
                  } else {
                    print("User signs in successfully")
                      self.CustomModel.errorTxtFields(txt: [self.txtUsername,self.txtPassword], error: false)
                      Task{
                          // hold it for 4 secs
                          try await Task.sleep(nanoseconds: 500000000)
                          let userInfo = Auth.auth().currentUser
                          let email = userInfo?.email
                            
                            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                          let rootVC:HomePageViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
                            let nvc:UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "HomePageNavController") as! HomePageNavController
                            
                            nvc.viewControllers = [rootVC]
                            rootVC.loggedinuserData = String(describing: "\(String(describing: email))")
                            //Set rootVC
                            rootVC.isComeFromLogin = true
                            let appDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                            appDelegate.window!.rootViewController = nvc
                        }
                    }
                }
            }
        }
    }
}
extension UINavigationController {

    var rootViewController: UIViewController? {
        return viewControllers.first
    }
}
