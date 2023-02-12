//
//  HomePageViewController.swift
//  Strats360_KidsApp
//
//  Created by Strats 360 on 06/01/23.
//

import UIKit
import FTPopOverMenu
import Alamofire
import RevealingSplashView


class HomePageViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //Outlets
    @IBOutlet weak var animatedView: UIView!
    @IBOutlet weak var imgNavLogo: UIImageView!
    @IBOutlet weak var btnpopUpmenu: UIBarButtonItem!
    @IBOutlet weak var imgVIP: UIImageView!
    @IBOutlet weak var SubjectColView: UICollectionView!
    @IBOutlet weak var txtSearchBar: UITextField!
    
    // Custom Model initialized
    let CustomModel = CustomClass()
    let ftpDropdown = FTPopOverMenuConfiguration()
    let homepageModel = HomePageModels()
    let customAlamofire = CustomAlamofire()
    
    // Constants
    var UserId: Int!
    let splashScreen = RevealingSplashView(iconImage: UIImage(imageLiteralResourceName: "Logo"), iconInitialSize: CGSize(width: 350, height: 350), backgroundColor: UIColor(named: "LogoColor")!)
    
    var ApifetchedData: HomePageAPIModel!
    var arritem = ["Profile", "Language", "Sign Out"]
    var isComeFromLogin = false // by default false
    var loggedinuserData = ""
    var timeInterval = 0.0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Splash Screen Animation
        if !isComeFromLogin{
            self.view.addSubview(self.splashScreen)
            self.splashScreen.startAnimation()
            self.animatedView.alpha = 0
            self.timeInterval = 2.0
        }
//        Fetching Data from API
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
                self.fetchingAPiData()
        }
        SubjectColView.delegate = self
        SubjectColView.dataSource = self
        
        //navigation
        navigationController?.isNavigationBarHidden = false
        navigationItem.titleView?.bounds.size = CGSize(width: 100, height: 66)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    func fetchingAPiData(){
        let loader = self.loader()
        customAlamofire.GetAPIData(url: APIConstants.HomePageAPI, dataModel: HomePageAPIModel.self, parameter: [:]){ (fetchedData) in
                self.ApifetchedData = fetchedData as? HomePageAPIModel
                print(self.ApifetchedData!)
                DispatchQueue.main.async {
                    //Toast msg
                    self.view.showToast(toastMessage: "Namaste.. ", duration: 1.5, imageName: "success")
                    self.CustomModel.cornerRadiusTXT(txt: self.txtSearchBar)
                    self.imgVIP.layer.cornerRadius = 15
                    self.imgNavLogo.downloaded(from: self.ApifetchedData!.logo)
                    self.imgVIP.downloaded(from: self.ApifetchedData!.banner)
                    self.UserId = self.ApifetchedData.data[0].id
                    self.shareingIdtoALL()
                UIView.animate(withDuration: 1, delay: 0, animations: {
                    self.animatedView.alpha = 1
                })
                    self.SubjectColView.reloadData()
                    self.stopLoader(loader: loader)
            }
        }
    }
    func shareingIdtoALL(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let rootVC:ProfileViewController = mainStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        rootVC.UserId = self.UserId!
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
                                           , withMenuArray: arritem, imageArray: [/* image for popup button */],configuration: homepageModel.configuration, doneBlock: { [self] (selectedIndex) in
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
                                    let header = UserDefaults.standard.object(forKey: APIConstants.UserAuthToken)
                                    ServerCommunication.share.APICallingFunction(request: RequestModel(url: APIConstants.LogOutAPI,httpMethod: .post,headerFields: header as? HTTPHeaders, parameter: [:])) { response, data in
                                        print(data!)
                                        if response{
                                            // USer login status code...
                                            UserDefaults.standard.set(false, forKey: APIConstants.UserLoginSatus)
                                            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                          let rootVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                            let nvc:UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "StartNavController") as! StartNavController
                                                               nvc.viewControllers = [rootVC]
                                            rootVC.cameFromHomePage = true
                                            let appDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                                            appDelegate.window!.rootViewController = nvc
                                        }
                                        else{
                                            UserDefaults.standard.set(false, forKey: APIConstants.UserLoginSatus)
                                            UIAlertController.CustomAlert(title: "Error", msg: (data!["msg"]! as? String)!, target: self)
                                        }
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
        ApifetchedData?.data.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageCollectionViewCell", for: indexPath) as! HomePageCollectionViewCell
        cell.imgSubject.downloaded(from: (ApifetchedData.data[indexPath.row].image))
        cell.lblSubName.text = ApifetchedData?.data[indexPath.row].name ?? "XYZ"
        cell.contentView.layer.cornerRadius = 15
        cell.imgSubject.layer.cornerRadius = 15
        cell.containerView.layer.cornerRadius = 15
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.customAlamofire.GetAPIData(url: APIConstants.ChapterPageAPI + String(self.ApifetchedData.data[indexPath.row].id), dataModel: ChapterPageAPIModel.self, parameter: [:]){ (fetchedData) in
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "ChapterViewController") as! ChapterViewController
            destinationVC.fetchedDataFromAPI = fetchedData as? ChapterPageAPIModel
            self.navigationController?.pushViewController(destinationVC, animated: true)
            }
        }
    }
}

class HomePageCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var lblSubName: UILabel!
    @IBOutlet weak var imgSubject: UIImageView!
    @IBOutlet weak var containerView: UIView!
}

