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
    let splashScreen = RevealingSplashView(iconImage: UIImage(imageLiteralResourceName: "Logo"), iconInitialSize: CGSize(width: 350, height: 350), backgroundColor: UIColor(named: "LogoColor")!)
    
    var ApifetchedData = [HomePageData]()
    var UserData: NSDictionary!
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
//                self.fetchingAPiData()
            self.fetchingAPIDataV2()
        }
        SubjectColView.delegate = self
        SubjectColView.dataSource = self
        
        //navigation
        navigationController?.isNavigationBarHidden = false
        navigationItem.titleView?.bounds.size = CGSize(width: 100, height: 66)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    func fetchingAPIDataV2(){
        let loader = self.loader()
        let token = UserDefaults.standard.value(forKey: APIConstants.UserAuthToken)! as! String
        
        let header: HTTPHeaders? = [.authorization(bearerToken: token)]
        
        let request = RequestModel(url: APIConstants.HomePageAPI, httpMethod: .post, headerFields: header, parameter: [:])
        ServerCommunication.share.APICallingFunction(request: request) { response, data in
            
            if response{
                print(data!)
                DispatchQueue.main.async {
                    //Toast msg
                    self.view.showToast(toastMessage: "Namaste.. ", duration: 1.5, imageName: "success")
                    self.CustomModel.cornerRadiusTXT(txt: self.txtSearchBar)
                    self.imgVIP.layer.cornerRadius = 15
                    self.imgNavLogo.downloaded(from: data!["logo"]! as! String)
                    self.imgVIP.downloaded(from: data!["banner"]! as! String)
                    
                UIView.animate(withDuration: 1, delay: 0, animations: {
                    self.animatedView.alpha = 1
                })
                    self.SubjectColView.reloadData()
                    self.stopLoader(loader: loader)
            }
                
                let arrData = data!["data"]! as! Array<Any>
                for index in 0...(arrData.count - 1){
                    let id = arrData[index] as! NSDictionary
                    print(id)
                    self.ApifetchedData.append(HomePageData(id: id["id"]! as! Int, name: (id["name"]! as! String), image: id["image"]! as! String))
                }
                self.stopLoader(loader: loader)
            }
            else{
                print(data!)
                self.stopLoader(loader: loader)
                DispatchQueue.main.asyncAfter(deadline: .now()){
                    UIAlertController.CustomAlert(title: "Error Occured", msg: data!["message"]! as! String, target: self)
                }
            }
            
        }
    }
    
    func shareingIdtoALL(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let rootVC:ProfileViewController = mainStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController

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
                                    let token = UserDefaults.standard.object(forKey: APIConstants.UserAuthToken)!
                                    let header: HTTPHeaders? = [.authorization(bearerToken: token as! String)]
                                    ServerCommunication.share.APICallingFunction(request: RequestModel(url: APIConstants.LogOutAPI,httpMethod: .post,headerFields: header, parameter: [:])) { response, data in
                                        print(data!)
                                        if response{
                                            // USer login status code...
                                            UIAlertController.CustomAlert(title: "Success", msg: "You Logged Out..", target: self)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                                                UserDefaults.standard.set(false, forKey: APIConstants.UserLoginSatus)
                                                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                                let rootVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                                let nvc:UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "StartNavController") as! StartNavController
                                                nvc.viewControllers = [rootVC]
                                                rootVC.cameFromHomePage = true
                                                let appDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                                                appDelegate.window!.rootViewController = nvc
                                            }
                                        }
                                        else{
                                            UserDefaults.standard.set(false, forKey: APIConstants.UserLoginSatus)
                                            DispatchQueue.main.asyncAfter(deadline: .now()){
                                                UIAlertController.CustomAlert(title: "Error", msg: (data!["message"]! as? String)!, target: self)
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
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
        ApifetchedData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageCollectionViewCell", for: indexPath) as! HomePageCollectionViewCell
        cell.imgSubject.downloaded(from: (ApifetchedData[indexPath.row].image))
        cell.lblSubName.text = ApifetchedData[indexPath.row].name
        cell.contentView.layer.cornerRadius = 15
        
        cell.imgBGview.layer.cornerRadius = 17
        cell.containerView.layer.cornerRadius = 15
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        DispatchQueue.main.asyncAfter(deadline: .now()){
            let header: HTTPHeaders? = [.authorization(bearerToken: UserDefaults.standard.value(forKey: APIConstants.UserAuthToken)! as! String)]
            let loader = self.loader()
            ServerCommunication.share.APICallingFunction(request: RequestModel(url: APIConstants.ChapterPageAPI, httpMethod: .post, headerFields: header,parameter: ["category_id": self.ApifetchedData[indexPath.row].id])) { response, data in
                if response{
                    print(data!)
                    let destinationVC = storyboard.instantiateViewController(withIdentifier: "ChapterViewController") as! ChapterViewController
                    let arrUpperData = data!["category_wise_data"]! as! Array<Any>
                    let arrLowerData = data!["data"]! as! Array<Any>
                    
                    for index in 0...(arrUpperData.count - 1){
                        let fetchedDATA = arrUpperData[index] as! NSDictionary
                        destinationVC.upperFetchedDataFromAPI.append(CategoryWiseDatum(nameOrImage: fetchedDATA["name_or_image"]! as! String))
                    }
                    for index in 0...(arrLowerData.count - 1){
                        let fetchedDATA = arrLowerData[index] as! NSDictionary
                        destinationVC.lowerFetchedDataFromAPI.append(ChapterDataModel(id: fetchedDATA["id"]! as! Int, categoryID: fetchedDATA["category_id"]! as! String , name: fetchedDATA["name"]! as! String, image: fetchedDATA["image"]! as! String, sound: fetchedDATA["sound"]! as! String))
                        print(fetchedDATA)
                    }
                    self.stopLoader(loader: loader)
                    
                    self.navigationController?.pushViewController(destinationVC, animated: true)
                }
                else{
                    UIAlertController.CustomAlert(title: "Error", msg: data!["message"]! as! String, target: self)
                }
            }
        }
    }
}

class HomePageCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var lblSubName: UILabel!
    @IBOutlet weak var imgSubject: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgBGview: UIView!
}

