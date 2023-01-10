//
//  CustomModel.swift
//  Strats360_KidsApp
//
//  Created by Strats 360 on 05/01/23.
//

import Foundation
import UIKit

class CustomClass{
//    let logoColor: UIColor = UIColor(named: "LogoColor")!
//    let appFont_Bold:UIFont = UIFont(name: "Roboto-Bold", size: 20)!
//    let appFont:UIFont = UIFont(name: "Roboto-Medium", size: 16)!
    func curveBTN( btn button: UIButton){
        button.layer.cornerRadius = button.frame.height / 2.5
        button.titleLabel?.font = UIFont(name: "Roboto-Bold", size: button.frame.height * 0.33)
        }
    func cornerRadiusTXT( txt textfield: UITextField){
        textfield.layer.masksToBounds = true
        textfield.layer.cornerRadius = textfield.frame.height / 2.5
        textfield.borderStyle = .none
        textfield.backgroundColor = .white
        let paddingView = UIView(frame: CGRectMake(0, 0, 10, 10))
             textfield.leftViewMode = .always
             textfield.leftView = paddingView
        
    }
    func imgCustom( ){
        
    }
    
    
    
    
}
