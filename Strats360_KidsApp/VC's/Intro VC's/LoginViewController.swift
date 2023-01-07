//
//  LoginViewController.swift
//  Strats360_KidsApp
//
//  Created by Strats 360 on 05/01/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    //Outlets
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    
    // Models
    let CustomModel = CustomClass()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // customModel in use
        
        CustomModel.curveBTN(btn: btnBack)
        CustomModel.curveBTN(btn: btnLogin)
        CustomModel.cornerRadiusTXT(txt: txtPassword)
        CustomModel.cornerRadiusTXT(txt: txtUsername)
        
    }
    
    @IBAction func backBTNpressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
