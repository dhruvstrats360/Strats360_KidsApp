//
//  HomePageViewController.swift
//  Strats360_KidsApp
//
//  Created by Strats 360 on 06/01/23.
//

import UIKit
import FirebaseAuth
import FTPopOverMenu


class HomePageViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var animatedView: UIView!
    
    @IBOutlet weak var btnpopUpmenu: UIBarButtonItem!
    @IBOutlet weak var imgVIP: UIImageView!
    @IBOutlet weak var SubjectColView: UICollectionView!
    @IBOutlet weak var txtSearchBar: UITextField!
    
    // Custom Model initialized
    let CustomModel = CustomClass()
    let ftpDropdown = FTPopOverMenuConfiguration()
    let homepageModel = HomePageModels()
    
    
    // Constants
    let arrVIPImg = [UIImage(imageLiteralResourceName: "360 Kids logo")]
    
    let arrSubImg = [UIImage(imageLiteralResourceName: "alphabet")
                     ,UIImage(imageLiteralResourceName: "animal")
                     ,UIImage(imageLiteralResourceName: "birds")
                     ,UIImage(imageLiteralResourceName: "digits")
                     ,UIImage(imageLiteralResourceName: "fruits")
                     ,UIImage(imageLiteralResourceName: "vegs")]
    let arrSubImageName = ["ALPHABETS","ANIMALS","BIRDS","DIGITS","FRUITS","VEGETABLES"]
    var arritem = ["Profile", "Language", "Sign Out"]
    var isComeFromLogin = true // by default false
    var loggedinuserData = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        animatedView.alpha = 0
        UIView.animate(withDuration: 1, delay: 0, animations: {
            self.animatedView.alpha = 1
        })
        
        SubjectColView.delegate = self
        SubjectColView.dataSource = self
        CustomModel.cornerRadiusTXT(txt: txtSearchBar)
        imgVIP.layer.cornerRadius = 15
        imgVIP.image = arrVIPImg[0]
        
        //navigation
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.view.showToast(toastMessage: "Namaste.. ", duration: 1.5, imageName: "success")
        
    }
    
    @IBAction func popBtnPressed(_ sender: UIBarButtonItem) {
        
        if let navigationBarSubviews = self.navigationController?.navigationBar.subviews {
            for view in navigationBarSubviews {
                if let findClass = NSClassFromString("_UINavigationBarContentView"),
                   view.isKind(of: findClass),
                   let barButtonView = self.navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView {
                    
                    let point = barButtonView.convert(barButtonView.center, to: view)
                    // got bar btn center from the view.
                            let popframe = CGRect(origin: CGPoint(x: point.x, y: point.y + UIApplication.shared.statusBarFrame.height + 10), size: CGSize(width: 0, height: 0))
                        // added popup btn to it.
                        FTPopOverMenu.show(fromSenderFrame: popframe
                                           , withMenuArray: arritem, imageArray: arrVIPImg,configuration: homepageModel.configuration, doneBlock: { [self] (selectedIndex) in
                            // here action will be done on clicked btn.
                            if self.arritem.count > 0{
                                
                                if selectedIndex == 0{
                                    performSegue(withIdentifier: "gotoProfile", sender: self)
                                }
                                
                                else if selectedIndex == 1{
                                    // 2nd pop on selected btn.
                                    
                                    FTPopOverMenu.show(fromSenderFrame: popframe
                                                       , withMenuArray: ["Hindi", "English","Gujrati"], imageArray: [],configuration: homepageModel.configuration, doneBlock: { (selectedIndex) in
                                        if self.arritem.count > 0{
                                            
                                             if selectedIndex == 1{
                                                // 3rd pop on selected btn.
                                                
                                            }
                                        }
                                    } , dismiss: {
                                    })
                                }
                                if selectedIndex == 2{
                                    do {
                                      try Auth.auth().signOut()
                                        
                                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                      let rootVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                        let nvc:UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "StartNavController") as! StartNavController
                                                           nvc.viewControllers = [rootVC]
                                        rootVC.cameFromHomePage = true
                                        let appDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                                        appDelegate.window!.rootViewController = nvc
                                        
                                    } catch {
                                      print("Sign out error")
                                    }
                                }
                            }
                        } , dismiss: {
                            
                    })
                }
            }
        }
    }
    
    @IBAction func homeBtnPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
extension HomePageViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrSubImg.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageCollectionViewCell", for: indexPath) as! HomePageCollectionViewCell
        cell.imgSubject.image = arrSubImg[indexPath.row]
        cell.lblSubName.text = arrSubImageName[indexPath.row]
        cell.contentView.layer.cornerRadius = 15
        cell.imgSubject.layer.cornerRadius = 15
        cell.containerView.layer.cornerRadius = 15
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "ChapterViewController") as! ChapterViewController
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

class HomePageCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var lblSubName: UILabel!
    @IBOutlet weak var imgSubject: UIImageView!
    @IBOutlet weak var containerView: UIView!
}
