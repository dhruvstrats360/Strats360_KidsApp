//
//  UIkit CustomModel.swift
//  Strats360_KidsApp
//
//  Created by Strats 360 on 30/01/23.
//

import Foundation
import UIKit
import RevealingSplashView

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
    lblMessage.frame = CGRect(x: bgView.frame.midX - (bgView.frame.width * 0.33) , y: 90, width: bgView.frame.width * 0.6, height: 50)
    lblMessage.font = UIFont(name: "Roboto-Bold", size: lblMessage.frame.height * 0.5)
    lblMessage.textAlignment = .center
lblMessage.layer.cornerRadius = 8
lblMessage.layer.masksToBounds = true
    lblMessage.padding = UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 20)
    
    let bgimage = UIImageView()
    bgimage.image = UIImage(imageLiteralResourceName: "\(imageName)")
    
    bgimage.frame = CGRect(x: bgView.frame.midX - (bgView.frame.width * 0.33) , y: 90, width: bgView.frame.width * 0.6, height: 50)
    
    bgimage.contentMode = .scaleAspectFill
    bgimage.layer.cornerRadius = 8
    bgimage.layer.masksToBounds = true
    bgView.addSubview(bgimage)
    
bgView.addSubview(lblMessage)
self.addSubview(bgView)
lblMessage.alpha = 0
bgimage.alpha = 0
    bgView.alpha = 0

UIView.animateKeyframes(withDuration:TimeInterval(duration) , delay: 0, options: [] , animations: {
    lblMessage.alpha = 1
    bgimage.alpha = 1
    bgView.alpha = 1
//    bgView.backgroundColor = .lightText
}, completion: {
sucess in
UIView.animate(withDuration:TimeInterval(duration), delay: 0, options: [] , animations: {
    lblMessage.alpha = 0
    bgimage.alpha = 0
    bgView.alpha = 0
})
bgView.removeFromSuperview()
})
}
    func errorPopUp(title: String ,message: String){
        let alert = UIAlertController(title: title , message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: { (_) in
             }))
        
    }
    func ViewAnimations(view: UIView){
        UIView.animateKeyframes(withDuration:2 , delay: 0, options: [] , animations: {
            view.alpha = 0
        //    bgView.backgroundColor = .lightText
        }, completion: {
            sucess in
            UIView.animate(withDuration:2, delay: 0, options: [] , animations: {
                view.alpha = 1
            })
        })
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
    class func CustomAlert(title:String, msg:String, target: UIViewController) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        target.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            target.dismiss(animated: true)
        }
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
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

extension UIViewController{
    func splashScreenAnimation(view: UIView){
        let splashScreen = RevealingSplashView(iconImage: UIImage(imageLiteralResourceName: "Logo"), iconInitialSize: CGSize(width: 350, height: 350), backgroundColor: .clear)
        view.addSubview(splashScreen)
        splashScreen.animationType = .heartBeat
    }
    func loader() -> UIAlertController{
        let alert = UIAlertController(title: nil, message: "Loading....", preferredStyle: .alert)
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        indicator.style = .large
        alert.view.addSubview(indicator)
        present(alert, animated: true)
        return alert
    }
    func stopLoader(loader: UIAlertController){
        DispatchQueue.main.async {
            loader.dismiss(animated: true)
        }
    }
}

