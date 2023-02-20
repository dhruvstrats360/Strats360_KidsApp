//
//  SignUpViewController.swift
//  Strats360_KidsApp
//
//  Created by Strats 360 on 05/01/23.
//

import UIKit
import CountryPickerView
import Alamofire

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
    var UserId: Int!
    var countryCodee: String!
    var FetchedData: [String: Any]!
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
        countryPicker.font = UIFont(name: AppConstants.BoldFont, size: 12)!
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
        
        txtUserName.clearButtonMode = .never
        txtPassword.clearButtonMode = .never
        txtEmail.clearButtonMode = .never
        txtphoneNo.clearButtonMode = .never
        
        guard let name = txtUserName.text, let email = txtEmail.text, let phone = txtphoneNo.text, let password = txtPassword.text
        else {
           return
        }
        let isValidateName = self.customModel.validateName(name: name)
        let isValidateEmail = self.customModel.validateEmailId(emailID: email)
        let isValidatePassword = self.customModel.validatePassword(password: password)
        if (isValidateName == false && isValidateEmail == false){
            customModel.errorTxtField(txt: txtUserName, iserror: true)
            customModel.errorTxtField(txt: txtEmail, iserror: true)
            UIAlertController.CustomAlert(title: "Error", msg: "Incorrect Name & Password", target: self)
           print("Incorrect Name & email")
           return
        }
        if (isValidateName == false) {
            customModel.errorTxtField(txt: txtUserName, iserror: true)
            UIAlertController.CustomAlert(title: "Error", msg: "Incorrect Name", target: self)
            print("Incorrect Name")
            return
        }
        if (isValidateEmail == false){
            customModel.errorTxtField(txt: txtEmail, iserror: true)
            UIAlertController.CustomAlert(title: "Error", msg: "Incorrect Email", target: self)
            print("Incorrect Email")
            return
        }
        if (isValidatePassword == false) {
            customModel.errorTxtField(txt: txtPassword, iserror: true)
            UIAlertController.CustomAlert(title: "Error", msg: "Weak Password", target: self)
            print("Incorrect password")
            return
        }
        
        
        if (isValidateEmail == true || isValidateName == true || isValidatePassword == true  ) {
            
            // Parameters - id, name, email, phone, profile
            let parameter = [
                "name" : name,
                "email" : email,
                "phone" : countryPicker.selectedCountry.phoneCode + " " + phone,
                "password" : password
            ] as [String: Any]
            
            let request = RequestModel(url: APIConstants.RegisterPageAPI, httpMethod: .post, parameter: parameter)
            
            ServerCommunication.share.APICallingFunction(request: request) { response, data in
                if response{
                    print(data!)
                    
                    // USer data auth Code..
                    let authCode = data!["authorisation"]! as? NSDictionary
                    let authToken = authCode!["token"]!
                    UserDefaults.standard.set(authToken, forKey: AppConstants.UserAuthToken)
                    
                    // USer ID
                    let userData = data!["user"]! as? NSDictionary
                    let UserId = userData!["id"]!
                    UserDefaults.standard.set(UserId, forKey: AppConstants.UserloggedId)
                    
                    // USer login status code...
                    UserDefaults.standard.set(true, forKey: AppConstants.UserLoginStatus)
                    
                    self.customModel.errorTxtFields(txt: [self.txtEmail,self.txtphoneNo,self.txtPassword,self.txtUserName], error: false)
                    print("User signs up successfully")
                    UIAlertController.CustomAlert(title: "\(data!["message"]!)", msg: "", target: self)
                    // hold it for 1 sec
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
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
                else{
                    self.customModel.errorTxtFields(txt: [self.txtEmail], error: true)
                    var errorText = ""
                    let arrOfdata = data!["message"]! as! Array<String>
                    for index in arrOfdata{
                        errorText = errorText + index
                    }
                    UIAlertController.CustomAlert(title: "Error", msg: "\(errorText)", target: self)
                    print(data!)
                }
            }
            print("All fields are correct")
        }
    }
}
