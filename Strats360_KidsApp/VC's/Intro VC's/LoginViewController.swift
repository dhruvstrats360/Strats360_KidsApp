//
//  LoginViewController.swift
//  Strats360_KidsApp
//
//  Created by Strats 360 on 05/01/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtUsername: UITextField!
    
    // Models
    let CustomModel = CustomClass()
    var cameFromHomePage = false
    var UserId: Int!
    
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
        txtUsername.text = "tester03@gmail.com"
        txtPassword.text = "tester@123"
    }
    
    @IBAction func signUpBTNpressed(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: .main)
        let destinationVC = sb.instantiateViewController(withIdentifier: "SignUpViewController")
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @IBAction func forgetPasspressed(_ sender: UIButton) {
//        txtFieldPopUp(view: self, numberOfTxtfield: 1, txtplaceholder: ["Enter your email ID"], title: "Forgot Password your password ?", message: "No worries Enter your Email ID, you will get new Password their.")
    }
    
    @IBAction func logingBTNpressed(_ sender: Any) {
        
        txtUsername.clearButtonMode = .never
        txtPassword.clearButtonMode = .never
        
        guard let email = txtUsername.text,let password = txtPassword.text
        else {
            return
        }
        
        let isValidatePassword = self.CustomModel.validatePassword(password: password)
        let isValidateEmail = self.CustomModel.validateEmailId(emailID: email)
        if (isValidateEmail == false || isValidatePassword == false){
            UIAlertController.CustomAlert(title: "Error", msg: "Incorrect Name or Password", target: self)
            print("Incorrect Name & password")
            return
        }
        if ( isValidateEmail == true || isValidatePassword == true  ) {
            
            // Parameters -  name, profile
            let parameter = [
                "email" : email,
                "password" : password
            ] as [String: Any]
            
            let request = RequestModel(url: APIConstants.LoginPageAPI, httpMethod: .post, headerFields: [:], parameter: parameter )
            
            ServerCommunication.share.APICallingFunction(request: request) { response, data in
                if response{
                    
                    print(data!)
                    
                    // USer data auth Code..
                    let authCode = data!["authorisation"]! as? NSDictionary
                    let authToken = authCode!["token"]!
                    UserDefaults.standard.set(authToken, forKey: APIConstants.UserAuthToken)
                    
                    // USer ID
                    let userData = data!["data"]! as? NSDictionary
                    let UserId = userData!["id"]!
                    UserDefaults.standard.set(UserId, forKey: APIConstants.UserloggedId)
                    
                    // USer login status code...
                    UserDefaults.standard.set(true, forKey: APIConstants.UserLoginSatus)
                    
                    self.CustomModel.errorTxtFields(txt: [self.txtUsername,self.txtPassword], error: false)
                    print("User signs up successfully")
                    UIAlertController.CustomAlert(title: "\(data!["message"]!)", msg: "", target: self)
                    // hold it for 1 sec
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let rootVC:HomePageViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
                        let nvc:UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "HomePageNavController") as! HomePageNavController
                        nvc.viewControllers = [rootVC]
                        rootVC.isComeFromLogin = true
                        rootVC.UserData = data!
                        
                        let appDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                        appDelegate.window!.rootViewController = nvc
                    }
                }
                else{
                    let errorText = data!["message"]!
                    UIAlertController.CustomAlert(title: "Error", msg: "\(errorText)", target: self)
                    print(data!)
                }
            }
            print("All fields are correct")
        }
    }
}
extension UINavigationController {
    
    var rootViewController: UIViewController? {
        return viewControllers.first
    }
}
