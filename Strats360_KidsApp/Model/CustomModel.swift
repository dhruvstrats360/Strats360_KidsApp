//
//  CustomModel.swift
//  Strats360_KidsApp
//
//  Created by Strats 360 on 05/01/23.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
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
//    public var modelData = HomePageAPIModel(status: 0, message: "", logo: URL(string: "")!, data: [])

    func GetAPIData(endPoint: String, dataModel: Decodable.Type, completion: @escaping((Any) -> ()) ){
        
        AF.request("https://360kids.360websitedemo.com/" + endPoint, method: .post,encoding: URLEncoding.default).response{ (responseData) in
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


