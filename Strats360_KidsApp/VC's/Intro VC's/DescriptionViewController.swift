//
//  ViewController.swift
//  Strats360_KidsApp
//
//  Created by Strats 360 on 04/01/23.
//

import UIKit
import RevealingSplashView
import Alamofire

class DescriptionViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var descriptionColView: UICollectionView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var btnBack: UIButton!
    
    //Model initialization
    let customModel = CustomClass()
    let customAlamofire = CustomAlamofire()
    
    //Constants
    var counter = 0
    var arrDescription = [1,2,3]
    let splashScreen = RevealingSplashView(iconImage: UIImage(imageLiteralResourceName: "Logo"), iconInitialSize: CGSize(width: 350, height: 350), backgroundColor: UIColor(named: "LogoColor")!)
    var FetchedDataFromAPI:DescriptionPageModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Splash Screen..
        view.addSubview(self.splashScreen)
        splashScreen.startAnimation()
        
        //InternetConnection
        if Connectivity.isConnectedToInternet {
             print("Connected")
         } else {
             let alert = UIAlertController(title: "Please Connect to internet", message: "", preferredStyle: .alert)
             self.present(alert, animated: true)
             return
        }
        
        //APi Calling
        apiCalling()
        
        //Custom Buttons
        customModel.curveBTN(btn: btnBack)
        customModel.curveBTN(btn: btnNext)
        
        //PageController
        pageControllerCustoms()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if counter == 0{
            btnBack.isHidden = true
        }
        else{
            btnBack.isHidden = false
        }
    }
    func apiCalling(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            let loader = self.loader()
            self.customAlamofire.GetAPIData(url: APIConstants.DesccriptionPageAPI, dataModel: DescriptionPageModel.self, parameter: [:], header: nil) { responseData in
                self.FetchedDataFromAPI = responseData as? DescriptionPageModel
                self.descriptionColView.reloadData()
                self.stopLoader(loader: loader)
            }
        }
    }
    func pageControllerCustoms(){
        pageController.currentPage = counter
        pageController.numberOfPages = 3
        pageController.layer.shadowOffset = CGSize(width: 0.5, height: 10)
        pageController.tintColor = .black
        if #available(iOS 14.0, *) {
            pageController.backgroundStyle = .prominent
        } else {
            // Fallback on earlier versions
            pageController.layer.style = .none
        }
        btnBack.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
        counter += 1
        if counter < FetchedDataFromAPI.screenData.count {
            if counter >= 0 {
                btnBack.isHidden = false
            }
            
             let index = IndexPath.init(item: counter, section: 0)
             self.descriptionColView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
             pageController.currentPage = counter
            descriptionColView.reloadData()
        }
        else {
            let sb = UIStoryboard(name: "Main", bundle: .main)
            let destinationVC = sb.instantiateViewController(withIdentifier: "LoginViewController") 
            navigationController?.pushViewController(destinationVC, animated: true)
          }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
//        counter = FetchedDataFromAPI.screenData.count
        
        if counter == 1 {
            btnBack.isHidden = true
        }
        else{
            btnBack.isHidden = false
        }
        counter -= 1
        if counter < FetchedDataFromAPI.screenData.count {
            
             let index = IndexPath.init(item: counter, section: 0)
             self.descriptionColView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
             pageController.currentPage = counter
            descriptionColView.reloadData()
        } else {
            counter = 0
          }
    }
}
extension DescriptionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if FetchedDataFromAPI == nil{
            return 0
        }
        else{
            return FetchedDataFromAPI.screenData.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
        //        cell.insideView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.7)
        
        cell.imgLogo.downloaded(from: FetchedDataFromAPI.screenData[indexPath.row].logo)
        cell.imgKid.downloaded(from: FetchedDataFromAPI.screenData[indexPath.row].image)
        cell.lblTitle.text = FetchedDataFromAPI.screenData[indexPath.row].title
        cell.lblSubTitle.text = FetchedDataFromAPI.screenData[indexPath.row].subtitle
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { return CGSize(width: view.frame.width, height: view.frame.height * 0.7) }
}


class DescriptionCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgKid: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
}
