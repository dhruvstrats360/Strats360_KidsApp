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
    @IBOutlet weak var btnExtra: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    // custom Model
    let customModel = CustomClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar - disabling
        navigationController?.navigationBar.isHidden = true
        // btns
        customModel.curveBTN(btn: btnBack)
        btnExtra.isHidden = true
        customModel.curveBTN(btn: btnSignUp)
        
        // txt fields
        customModel.cornerRadiusTXT(txt: txtEmail)
        customModel.cornerRadiusTXT(txt: txtphoneNo)
        customModel.cornerRadiusTXT(txt: txtUserName)
        customModel.cornerRadiusTXT(txt: txtPassword)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func gotoLogin(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func signUpPressed(_ sender: UIButton) {
        if !(txtUserName.text == "" || txtEmail.text == "" || txtphoneNo.text == "" || txtPassword.text == ""){
            if let email = txtEmail.text,let password = txtEmail.text{
                Auth.auth().createUser(withEmail: email, password: password) { [self] authResult, error in
                        if let error = error as? NSError {
                            self.SignUp_error(error: error as! AuthErrorCode)
                        }
                        else {
                            self.customModel.errorTxtFields(txt: [txtEmail,txtphoneNo,txtPassword,txtUserName], error: false)
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
        else{
            let arrlist = [txtUserName, txtEmail, txtphoneNo, txtPassword]
            let filteredData = arrlist.map({ (index) in
                if index?.text == ""{
                    return index
                }
                return nil
            })
            customModel.errorTxtFields(txt: filteredData, error: true)
                var data = ""
                for linedData in filteredData{
                    if linedData != nil{
                        data = data + " \(String(describing: linedData!.placeholder!)) cannot be empty, "
                        customModel.errorTxtField(txt: linedData!, iserror: true)
                    }
                }
                UIAlertController.alert(title: "Error", msg: "\(data)", target: self)
        }
    }
    
}
extension SignUpViewController{
    func SignUp_error(error: AuthErrorCode) {
        switch error.code{
        case .operationNotAllowed:
            // Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.
            
            UIAlertController.alert(title: "Error", msg: "\(error.localizedDescription)", target: self)
            break
        case .emailAlreadyInUse:
            UIAlertController.alert(title: "Error", msg: "\(error.localizedDescription)", target: self)
            break
            // Error: The email address is already in use by another account.
        case .invalidEmail: UIAlertController.alert(title: "Error", msg: "\(error.localizedDescription)", target: self)
            break
            // Error: The email address is badly formatted.
        case .weakPassword: UIAlertController.alert(title: "Error", msg: "\(error.localizedDescription)", target: self)
            break
            // Error: The password must be 6 characters long or more.
        default:
            UIAlertController.alert(title: "Error", msg: "\(error.localizedDescription)", target: self)
            break
        }
//        switch AuthErrorCode.Code(rawValue: error.code){
//        case .operationNotAllowed: break
//            // Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.
//        case .emailAlreadyInUse:
//            print(error.localizedDescription)
//            break
//            // Error: The email address is already in use by another account.
//        case .invalidEmail: break
//            // Error: The email address is badly formatted.
//        case .weakPassword: break
//            // Error: The password must be 6 characters long or more.
//        default:
//            print("Error: \(error.localizedDescription)")
//        }
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
