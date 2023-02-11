//
//  ProfileViewController.swift
//  Strats360_KidsApp
//
//  Created by Strats 360 on 20/01/23.
//

import UIKit
import Alamofire

class ProfileViewController:UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    //Outlets
    
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    
    @IBOutlet weak var txtphoneNo: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    
    @IBOutlet weak var btnChngPass: UIButton!
    @IBOutlet weak var btnSavechanges: UIButton!
    @IBOutlet weak var btnVIP: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnLiveEvent: UIButton!
    
    // custom Model
    let customModel = CustomClass()
    let customALamoFire = CustomAlamofire()
    var FetchedData = [String: Any]()
    let imagePicker = UIImagePickerController()
    
    //Constants
    var UserId: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //btns, txt, cornerRad etc.
        presetEdits()
        
        // save button
        btnSavechanges.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0).isActive = true
        
        // fetching data from API.
        fetchedProfileDataFromAPI()
        
        //img picker
        imagePicker.delegate = self

    }
    override func viewWillAppear(_ animated: Bool) {

    }
    
    func presetEdits(){
        btnSavechanges.alpha = 0
        customModel.curveBTN(btn: btnSavechanges)
        customModel.curveBTN(btn: btnVIP)
        customModel.curveBTN(btn: btnLogout)
        customModel.curveBTN(btn: btnLiveEvent)
        customModel.curveBTN(btn: btnChngPass)
        customModel.cornerRadiusTXT(txt: txtUserName)
        customModel.cornerRadiusTXT(txt: txtEmail)
        customModel.cornerRadiusTXT(txt: txtphoneNo)
        imgProfilePic.layer.cornerRadius = imgProfilePic.frame.height/2
    }
    func fetchedProfileDataFromAPI(){
        let loader = self.loader()
        
        let url = "\(APIConstants.ProfilePageAPI)"
        
        let request = RequestModel(url: url, httpMethod: .post, parameter: [:])
        
        ServerCommunication.share.APICallingFunction(request: request) { response, data in
            if response{
                
                self.FetchedData = data! as! [String : Any]
                let dicData:[String:Any] = self.FetchedData["data"] as! [String : Any]
                self.txtEmail.text = dicData["email"]! as? String
                self.txtphoneNo.text = dicData["phone"]! as? String
                self.txtUserName.text = dicData["name"]! as? String
                self.imgProfilePic.downloaded(from: (dicData["image"] as? String)!)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.stopLoader(loader: loader)
                }
            }
            else{
            // if status is something else, then also we can fetch response data
                
            }
        }
    }
    
    @IBAction func changeProfilePic(_ sender: UIButton) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @IBAction func txtseditingBegans(_ sender: UITextField) {
        
        self.btnSavechanges.heightAnchor.constraint(equalTo: self.btnVIP.heightAnchor, multiplier: 1).isActive = true
        //animate btn
        
        UIView.animateKeyframes(withDuration: 0.4 , delay: 0, options: [] , animations: {
            
        }, completion: {
        sucess in
            UIView.animate(withDuration: 0.4, delay: 0, options: [] , animations: {
                self.customModel.curveBTN(btn: self.btnSavechanges)
                self.view.layoutIfNeeded()
        })
            self.btnSavechanges.alpha = 1
        })
    }
    
    @IBAction func chngPasspresseD(_ sender: UIButton) {
    txtFieldPopUp(view: self, numberOfTxtfield: 3, txtplaceholder: ["Your Old Password: ", "Enter your New Password :","Re- Enter your new password :"], title: "Change Password", message: "Enter Your New Password ")
    }
    
    @IBAction func saveDataPressed(_ sender: UIButton) {
        guard let name = txtUserName.text, let email = txtEmail.text, let phone = txtphoneNo.text
        else {
           return
        }
        let isValidateName = self.customModel.validateName(name: name)
        let isValidateEmail = self.customModel.validateEmailId(emailID: email)
        if (isValidateName == false && isValidateEmail == false){
            customModel.errorTxtField(txt: txtUserName, iserror: true)
            customModel.errorTxtField(txt: txtEmail, iserror: true)
            UIAlertController.CustomAlert(title: "Error", msg: "Incorrect Name & Password", target: self)
           print("Incorrect Name & Password")
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
        
        if (isValidateEmail == true || isValidateName == true) {
            UIAlertController.CustomAlert(title: "Success", msg: "Data Saved Successfully.", target: self)
            customModel.errorTxtFields(txt: [txtEmail,txtphoneNo,txtUserName], error: false)
            // id, name, email, phone, profile
            let dicData:[String:Any] = self.FetchedData["data"] as! [String : Any]
            
            let parameter = [
                "name" : name,
                "email" : email,
                "phone" : phone,
                "profile" : (dicData["image"] as? String)!
            ] as [String: String]
            let url = "\(APIConstants.EditProfilePageAPI)"

            let request = RequestModel(url: url, httpMethod: .post, parameter: parameter )
            
            ServerCommunication.share.APICallingFunction(request: request) { response, data in
                if response{
                    print(data!)
                }
                else{
                    print(data!)
                }
            }
            print("All fields are correct")
        }
        self.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                imgProfilePic.contentMode = .scaleAspectFit
                imgProfilePic.image = pickedImage
            }
            dismiss(animated: true, completion: nil)
        }
}
extension ProfileViewController{
    func txtFieldPopUp(view: UIViewController, numberOfTxtfield: Int, txtplaceholder: [String], title: String, message: String){
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        //2. Add the text field. You can configure it however you need.
        
        for index in 0...(numberOfTxtfield - 1){
            alert.addTextField { (input) in
                input.text = ""
                input.placeholder = txtplaceholder[index]
            }
        }
         
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self, weak alert] (_) in
            guard let oldPassword = alert?.textFields![0].text, let newPassword = alert?.textFields![1].text, let confirmNewPass = alert?.textFields![2].text
            else{
                let alert = UIAlertController(title: "fields can't be NILL", message: "Invalid Data", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                view.present(alert, animated: true)
                return
            }
            if customModel.validatePassword(password: newPassword) {
                // url parameters
                let parameter1 =
                [
                    "user_id": 80,
                    "old_pwd": oldPassword,
                    "new_pwd": newPassword,
                    "confirm_new_pwd": confirmNewPass
                ] as [String: Any]
                let headers : HTTPHeaders? = [
                        "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovLzM2MGtpZHMuMzYwd2Vic2l0ZWRlbW8uY29tL2FwaS9sb2dpbiIsImlhdCI6MTY3NjAyODA3MCwiZXhwIjoxNjc2MDMxNjcwLCJuYmYiOjE2NzYwMjgwNzAsImp0aSI6IlNNdVBkSmZuTGMzazFnOTIiLCJzdWIiOiI3OSIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.QYw1WyxIgYnPrHvJ5Fv6q29HtG31MmjPZ8QfpZqhSPE",
                        "type": "bearer"
                    ]
                
                let request = RequestModel(url: APIConstants.ChangePassAPI, httpMethod: .post, headerFields: headers , parameter: parameter1)
                ServerCommunication.share.APICallingFunction(request: request) { response, data in
                    if response{

                        let msgString = data!["message"]! as! Array<Any>
                        var errorText = ""
                        for index in msgString{
                            errorText = errorText + " " + (index as! String)
                        }
                        let alert = UIAlertController(title: "\(errorText)", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                        view.present(alert, animated: true)
                        return
                    }
                    else{
                        print(data!)
                        let msgString = data!["message"] as! Array<Any>
                        var errorText = ""
                        for index in msgString{
                            errorText = errorText + " " + (index as! String)
                        }
                        let alert = UIAlertController(title: "\(errorText)", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                        view.present(alert, animated: true)
                        return
                    }
                }
            }
            else{
                let alert = UIAlertController(title: "Error", message: "Invalid Format of password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                view.present(alert, animated: true)
                return
            }
            
            }))
        
        view.present(alert, animated: true, completion: nil)
    }
}
