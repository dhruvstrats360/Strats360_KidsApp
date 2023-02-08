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
        customModel.txtFieldPopUp(view: self, numberOfTxtfield: 2, txtplaceholder: ["New Password :", "Re Enter New Password :"], title: "Change Password", message: "Enter Your New Password")
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
