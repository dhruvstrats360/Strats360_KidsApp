//
//  CustomModel.swift
//  Strats360_KidsApp
//
//  Created by Strats 360 on 05/01/23.
//

import Foundation
import IQKeyboardManagerSwift
import FTPopOverMenu
import Alamofire
import RevealingSplashView

//MARK: Custom Class
public class CustomClass{
    
    func curveBTN( btn button: UIButton){
        button.layer.masksToBounds = true
        button.layer.cornerRadius = button.frame.height / 2.5
        button.titleLabel?.font = UIFont(name: AppConstants.BoldFont, size: button.frame.height * 0.33)
    }
    
    func addCustomizedBackBtn(navigationController: UINavigationController?, navigationItem: UINavigationItem?) {
        navigationItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func cornerRadiusTXT( txt textfield: UITextField){
        textfield.layer.masksToBounds = true
        textfield.layer.cornerRadius = textfield.frame.height / 2.5
        textfield.borderStyle = .none
        textfield.backgroundColor = .white
        let paddingView = UIView(frame: CGRectMake(0, 0, 10, 10))
        textfield.leftViewMode = .always
        textfield.leftView = paddingView
        textfield.layer.borderWidth = 3
        textfield.layer.borderColor = UIColor.clear.cgColor
        textfield.font = UIFont(name: AppConstants.RegularFont, size: textfield.frame.height * 0.27)
    }
    
    func errorTxtFields(txt txtField: [UITextField?], error: Bool) {
        
        if error{
            for txtx in txtField{
                if txtx != nil{
                    txtx!.layer.borderColor = UIColor.red.cgColor
                }
            }
        }
        else{
            for txtx in txtField{
                if txtx != nil{
                    txtx!.layer.borderColor = UIColor.systemGreen.cgColor
                    
                }
            }
        }
    }
    
    func errorTxtField(txt txtField: UITextField, iserror: Bool){
        if iserror{
            txtField.layer.borderColor = UIColor.red.cgColor
        }
        else{
            txtField.layer.borderColor = UIColor.green.cgColor
        }
    }
    
    
    func validateName(name: String) ->Bool {
        //  Length be 18 characters max and 3 characters minimum, you can always modify. // No characters limit..
        let nameRegex = "^[a-zA-Z-]+[a-zA-Z-]+$"
        let trimmedString = name.trimmingCharacters(in: .whitespaces)
        let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let isValidateName = validateName.evaluate(with: trimmedString)
        return isValidateName
    }
    func validaPhoneNumber(phoneNumber: String) -> Bool {
        let phoneNumberRegex = #"^\(?\d{3}\)?[ -]?\d{3}[ -]?\d{4}$"#
        let trimmedString = phoneNumber.trimmingCharacters(in: .whitespaces)
        let validatePhone = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = validatePhone.evaluate(with: trimmedString)
        return isValidPhone
    }
    func validateEmailId(emailID: String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9_+&*-]+(?:\\." + "[a-zA-Z0-9_+&*-]+)*@" + "(?:[a-zA-Z0-9-]+\\.)+[a-z" + "A-Z]{2,7}$"
        let trimmedString = emailID.trimmingCharacters(in: .whitespaces)
        let validateEmail = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValidateEmail = validateEmail.evaluate(with: trimmedString)
        return isValidateEmail
    }
    func validatePassword(password: String) -> Bool {
        //Minimum 8 characters at least 1 Alphabet and 1 Number:
        let passRegEx = "^(?=.*[a-z]).{6,}$"
        let trimmedString = password.trimmingCharacters(in: .whitespaces)
        let validatePassord = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        let isvalidatePass = validatePassord.evaluate(with: trimmedString)
        return isvalidatePass
    }
    func LogOut(response: Bool, self: UIViewController, datamsg: NSDictionary){
        
        if response{
            // USer login status code...
            UIAlertController.CustomAlert(title: "Success", msg: "You Logged Out..", target: self)
        }
        else{
            DispatchQueue.main.asyncAfter(deadline: .now()){
                UIAlertController.CustomAlert(title: "Error", msg: (datamsg["message"]! as? String)!, target: self)
            }
        }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                UserDefaults.standard.set(false, forKey: AppConstants.UserLoginStatus)
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let rootVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let nvc:UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "StartNavController") as! StartNavController
                nvc.viewControllers = [rootVC]
                rootVC.cameFromHomePage = true
                let appDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                appDelegate.window!.rootViewController = nvc
            }
    }
    
}

//MARK: HomePage CustomCLass Model
class HomePageModels{
    
    // Constants
    let configuration = FTPopOverMenuConfiguration()
    //functions
    func customizedPopupButton(){
        configuration.textColor = UIColor(named: AppConstants.LogoImage)
        configuration.textFont = UIFont(name: AppConstants.MediumFont, size: 16)
        configuration.borderColor = .gray
        configuration.borderWidth = 0.5
        configuration.textAlignment = .center
        configuration.separatorColor = .gray
        configuration.shadowColor = .black
        configuration.shadowOpacity = 0.3
        configuration.shadowRadius = 5
        configuration.selectedCellBackgroundColor = .lightGray
        configuration.backgroundColor = .white
    }
}

extension UINavigationController{
    func CustombackBtn(){
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: AppConstants.prevBtn)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: AppConstants.prevBtn)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

//MARK: Custom Alamofire Model

class CustomAlamofire{
    
    func GetAPIData(url: String, dataModel: Decodable.Type, parameter: [String: Any], header: [String:String]? , completion: @escaping((Any) -> ()) ){
        
        AF.request(url, method: .post, parameters: parameter,encoding: URLEncoding.default, headers: HTTPHeaders(header ?? [:])).response{ (responseData) in
            guard let data = responseData.data else { return }
            do{
                
                let results = try JSONDecoder().decode(dataModel.self, from: data)
                
                DispatchQueue.main.async {
                    completion(results)
                }
            }
            catch{
                print("error while decoding API == \(error)")
            }
        }
    }
    
    func JString_2_Json(Jstring string: String, completion: @escaping((Dictionary<String,Any>) -> ())){
        
        let data = string.data(using: .utf8)!
        do {
            if let jsonDic = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
            {
                completion(jsonDic)
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
    }
}



