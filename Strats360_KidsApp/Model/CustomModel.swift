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

//MARK: Add Toast method function in UIView Extension so can use in whole project.
extension UIView
{
    func showToast(toastMessage:String,duration:CGFloat,imageName: String)
{
//View to blur bg and stopping user interaction
let bgView = UIView(frame: self.frame)
bgView.tag = 555

//Label For showing toast text
let lblMessage = UILabel()
lblMessage.numberOfLines = 0
lblMessage.lineBreakMode = .byWordWrapping
lblMessage.textColor = .white
    lblMessage.backgroundColor = .clear
lblMessage.text = toastMessage
    lblMessage.frame = CGRect(x: bgView.frame.midX - (bgView.frame.width * 0.33) , y: (bgView.frame.width * 0.25), width: bgView.frame.width * 0.63, height: 50)
    lblMessage.font = UIFont(name: "Roboto-Bold", size: lblMessage.frame.height * 0.5)
    lblMessage.textAlignment = .center
lblMessage.layer.cornerRadius = 8
lblMessage.layer.masksToBounds = true
    lblMessage.padding = UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 20)
    
    let bgimage = UIImageView()
    bgimage.image = UIImage(imageLiteralResourceName: "\(imageName)")
    
    bgimage.frame = CGRect(x: bgView.frame.midX - (bgView.frame.width * 0.33) , y: (bgView.frame.width * 0.25), width: bgView.frame.width * 0.6, height: 50)
    bgimage.contentMode = .scaleAspectFill
    bgimage.layer.cornerRadius = 8
    bgimage.layer.masksToBounds = true
    bgView.addSubview(bgimage)
    bgView.backgroundColor = .clear
    
bgView.addSubview(lblMessage)
self.addSubview(bgView)
lblMessage.alpha = 0
bgimage.alpha = 0

UIView.animateKeyframes(withDuration:TimeInterval(duration) , delay: 0, options: [] , animations: {
    lblMessage.alpha = 1
    bgimage.alpha = 1
}, completion: {
sucess in
UIView.animate(withDuration:TimeInterval(duration/2), delay: 0, options: [] , animations: {
    lblMessage.alpha = 0.5
    bgimage.alpha = 0.5
    bgView.alpha = 0.5
})
bgView.removeFromSuperview()
})
}
    func errorPopUp(title: String ,message: String){
        let alert = UIAlertController(title: title , message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: { (_) in
             }))
        
    }
}
extension CGFloat
{
func getminimum(value2:CGFloat)->CGFloat
{
if self < value2
{
return self
}
else
{
return value2
}
}
}
extension UIAlertController {
    class func alert(title:String, msg:String, target: UIViewController) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
            (result: UIAlertAction) -> Void in
        })
        target.present(alert, animated: true, completion: nil)
    }
}


//MARK: Extension on UILabel for adding insets - for adding padding in top, bottom, right, left.

extension UILabel
{
private struct AssociatedKeys {
static var padding = UIEdgeInsets()
}

var padding: UIEdgeInsets? {
get {
return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
}
set {
if let newValue = newValue {
    objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}
}
}

override open func draw(_ rect: CGRect) {
if let insets = padding {
    self.drawText(in: rect.inset(by: insets))
} else {
self.drawText(in: rect)
}
}

override open var intrinsicContentSize: CGSize {
get {
var contentSize = super.intrinsicContentSize
if let insets = padding {
contentSize.height += insets.top + insets.bottom
contentSize.width += insets.left + insets.right
}
return contentSize
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
