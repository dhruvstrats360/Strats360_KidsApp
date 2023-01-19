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
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtUsername: UITextField!
    
    
    // Models
    let CustomModel = CustomClass()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // customModel in use
        
        CustomModel.curveBTN(btn: btnBack)
        CustomModel.curveBTN(btn: btnSignUp)
        CustomModel.curveBTN(btn: btnLogin)
        CustomModel.cornerRadiusTXT(txt: txtPassword)
        CustomModel.cornerRadiusTXT(txt: txtUsername)
    }
    
    @IBAction func backBTNpressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func signUpBTNpressed(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: .main)
        let destinationVC = sb.instantiateViewController(withIdentifier: "SignUpViewController")
        navigationController?.pushViewController(destinationVC, animated: true)
    }

    @IBAction func logingBTNpressed(_ sender: Any) {
        if let email = txtUsername.text{
            if let password = txtPassword.text{
                Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                  if let error = error as? NSError {
                      switch AuthErrorCode.Code(rawValue: error.code) {
                      case .operationNotAllowed: break
                      // Error: Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console.
                      case .userDisabled: break
                      // Error: The user account has been disabled by an administrator.
                      case .wrongPassword: break
                      // Error: The password is invalid or the user does not have a password.
                      case .invalidEmail: break
                      // Error: Indicates the email address is malformed.
                    default:
                        print("Error: \(error.localizedDescription)")
                    }
                  } else {
                    print("User signs in successfully")
                      
                    let userInfo = Auth.auth().currentUser
                    let email = userInfo?.email
                      
                      let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let rootVC:HomePageViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
                      let nvc:UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "HomePageNavController") as! HomePageNavController
                                         nvc.viewControllers = [rootVC]
                      rootVC.isComeFromLogin = true
                      rootVC.loggedinuserData = String(describing: "\(String(describing: email))")
                      let appDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                      appDelegate.window!.rootViewController = nvc
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
