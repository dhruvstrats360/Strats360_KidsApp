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
class CustomClass{
    
    func curveBTN( btn button: UIButton){
        button.layer.masksToBounds = true
        button.layer.cornerRadius = button.frame.height / 2.5
        button.titleLabel?.font = UIFont(name: "Roboto-Bold", size: button.frame.height * 0.33)
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
        textfield.font = UIFont(name: "Roboto-Regular", size: textfield.frame.height * 0.27)
        
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
          let nameRegex = "^[a-zA-Z-]+ ?.* [a-zA-Z-]+$"
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
    func validateAnyOtherTextField(otherField: String) -> Bool {
          let otherRegexString = "Your regex String"
          let trimmedString = otherField.trimmingCharacters(in: .whitespaces)
          let validateOtherString = NSPredicate(format: "SELF MATCHES %@", otherRegexString)
          let isValidateOtherString = validateOtherString.evaluate(with: trimmedString)
          return isValidateOtherString
       }
        
}

//MARK: HomePage CustomCLass Model
class HomePageModels{
    
    // Constants
    let configuration = FTPopOverMenuConfiguration()
    //functions
    func customizedPopupButton(){
        configuration.textColor = UIColor(named: "LogoColor")
            configuration.textFont = UIFont(name: "Roboto-medium", size: 16)
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
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "prev")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "prev")
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



