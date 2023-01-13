//
//  SignUpViewController.swift
//  Strats360_KidsApp
//
//  Created by Strats 360 on 05/01/23.
//

import UIKit
import FirebaseAuth



class SignUpViewController: UIViewController {
    
    // Outlet
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtphoneNo: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnLOGIN: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    // custom Model
    let customModel = CustomClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar - disabling
        navigationController?.navigationBar.isHidden = true
        // btns
        customModel.curveBTN(btn: btnBack)
        customModel.curveBTN(btn: btnLOGIN)
        customModel.curveBTN(btn: btnSignUp)
        
        // txt fields
        customModel.cornerRadiusTXT(txt: txtEmail)
        customModel.cornerRadiusTXT(txt: txtphoneNo)
        customModel.cornerRadiusTXT(txt: txtUserName)
        customModel.cornerRadiusTXT(txt: txtPassword)
        txtEmail.layer.borderColor = UIColor.green.cgColor
        txtPassword.layer.borderColor = UIColor.red.cgColor
        txtEmail.layer.borderWidth = 3
        txtPassword.layer.borderWidth = 3
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnpressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        if let email = txtEmail.text {
            if  let password = txtEmail.text{
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error as? NSError {
                        switch AuthErrorCode.Code(rawValue: error.code){
                        case .operationNotAllowed: break
                            // Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.
                        case .emailAlreadyInUse:
                            print(error.localizedDescription)
                            break
                            // Error: The email address is already in use by another account.
                        case .invalidEmail: break
                            // Error: The email address is badly formatted.
                        case .weakPassword: break
                            // Error: The password must be 6 characters long or more.
                        default:
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                    else {
                        // Logged in successfully.
                        print("User signs up successfully")
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
    
    @IBAction func loginBTNpressed(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: .main)
        let destinationVC = sb.instantiateViewController(withIdentifier: "LoginViewController")
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

 
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */
