//
//  ProfileViewController.swift
//  Strats360_KidsApp
//
//  Created by Strats 360 on 20/01/23.
//

import UIKit

class ProfileViewController:UIViewController {
    //Outlets
    
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtphoneNo: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    
    @IBOutlet weak var btnSavechanges: UIButton!
    @IBOutlet weak var btnVIP: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnLiveEvent: UIButton!
    
    // custom Model
    let customModel = CustomClass()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //btns, txt, cornerRad etc.
        
        presetEdits()
        
        // save button
        btnSavechanges.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0).isActive = true
        

        
    }
    
    func presetEdits(){
        btnSavechanges.alpha = 0
        customModel.curveBTN(btn: btnSavechanges)
        customModel.curveBTN(btn: btnVIP)
        customModel.curveBTN(btn: btnLogout)
        customModel.curveBTN(btn: btnLiveEvent)
        customModel.cornerRadiusTXT(txt: txtUserName)
        customModel.cornerRadiusTXT(txt: txtEmail)
        customModel.cornerRadiusTXT(txt: txtPassword)
        customModel.cornerRadiusTXT(txt: txtphoneNo)
    }
    @IBAction func txtseditingBegans(_ sender: UITextField) {
        
        self.btnSavechanges.heightAnchor.constraint(equalTo: self.btnVIP.heightAnchor, multiplier: 1).isActive = true
        //animate btn
        
        UIView.animateKeyframes(withDuration: 0.4 , delay: 0, options: [] , animations: {
            
        }, completion: {
        sucess in
            UIView.animate(withDuration: 0.6, delay: 0, options: [] , animations: {
                self.customModel.curveBTN(btn: self.btnSavechanges)
                self.view.layoutIfNeeded()
        })
            self.btnSavechanges.alpha = 1
        })
    }
}
