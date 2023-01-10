//
//  SignUpViewController.swift
//  Strats360_KidsApp
//
//  Created by Strats 360 on 05/01/23.
//

import UIKit

class SignUpViewController: UIViewController {

    // Outlet
    
    @IBOutlet weak var countryView: UIView!
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
