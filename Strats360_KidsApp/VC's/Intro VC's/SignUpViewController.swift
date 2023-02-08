//
//  SignUpViewController.swift
//  Strats360_KidsApp
//
//  Created by Strats 360 on 05/01/23.
//

import UIKit
import FirebaseAuth
import CountryPickerView



class SignUpViewController: UIViewController, CountryPickerViewDelegate, CountryPickerViewDataSource {
    
    
    
    // Outlet
    
    @IBOutlet weak var countryPicker: CountryPickerView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtphoneNo: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnLOGIN: UIButton!
    
    // custom Model
    let customModel = CustomClass()
    
    //Constants
    var countryCodee: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // btns
        customModel.curveBTN(btn: btnLOGIN)
        customModel.curveBTN(btn: btnSignUp)
        
        // txt fields
        customModel.cornerRadiusTXT(txt: txtEmail)
        customModel.cornerRadiusTXT(txt: txtphoneNo)
        customModel.cornerRadiusTXT(txt: txtUserName)
        customModel.cornerRadiusTXT(txt: txtPassword)
        
        //Country picker Delegates Datasource
        countryPicker.delegate = self
        countryPicker.dataSource = self
        countryPicker.showPhoneCodeInView = true
        countryPicker.font = UIFont(name: "Roboto-Bold", size: 12)!
        countryPicker.flagSpacingInView = 8.0
        // Do any additional setup after loading the view.
    }
    
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        print(country.code)
        countryCodee = country.code
        
    }
    @IBAction func backtoLogin(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        if !(txtUserName.text == "" || txtEmail.text == "" || txtphoneNo.text == "" || txtPassword.text == ""){
            if let email = txtEmail.text,let password = txtEmail.text{
                Auth.auth().createUser(withEmail: email, password: password) { [self] authResult, error in
                        if let error = error as? NSError {
                            
                            SignUp_error(error: error as! AuthErrorCode)
                        }
                        else {
                            // .....dispatchQueue line will come here - Note......
                            
                                self.customModel.errorTxtFields(txt: [self.txtEmail,self.txtphoneNo,self.txtPassword,self.txtUserName], error: false)
                                
                            Task{
                                // hold it for 1 mins
                                try await Task.sleep(nanoseconds: 1000000000)
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
                UIAlertController.CustomAlert(title: "Error", msg: "\(data)", target: self)
        }
    }
    
}
extension UIViewController{
    func SignUp_error(error: AuthErrorCode) {
        switch error.code{
        case .operationNotAllowed:
            // Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.
            
            UIAlertController.CustomAlert(title: "Error", msg: "\(error.localizedDescription)", target: self)
            break
        case .emailAlreadyInUse:
            UIAlertController.CustomAlert(title: "Error", msg: "\(error.localizedDescription)", target: self)
            break
            // Error: The email address is already in use by another account.
        case .invalidEmail: UIAlertController.CustomAlert(title: "Error", msg: "\(error.localizedDescription)", target: self)
            break
            // Error: The email address is badly formatted.
        case .weakPassword: UIAlertController.CustomAlert(title: "Error", msg: "\(error.localizedDescription)", target: self)
            break
            // Error: The password must be 6 characters long or more.
        default:
            UIAlertController.CustomAlert(title: "Error", msg: "\(error.localizedDescription)", target: self)
            break
        }
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
