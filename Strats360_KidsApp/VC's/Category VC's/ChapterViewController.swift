//
//  ChapterViewController.swift
//  Strats360_KidsApp
//
//  Created by Strats 360 on 09/01/23.
//

import UIKit
import FTPopOverMenu
import AVFoundation
import Alamofire


class ChapterViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var ChapterColView: UICollectionView!
    @IBOutlet weak var lessoncolView: UICollectionView!
    
    // Custom model
    let customClass = CustomClass()
    let homePagemodel = HomePageModels()
    let customAlamofire = CustomAlamofire()
    var upperFetchedDataFromAPI = [CategoryWiseDatum]()
    var lowerFetchedDataFromAPI = [ChapterDataModel]()
    
    // Constants
    var player: AVAudioPlayer!
    var arritem = ["Profile", "Sign Out"]
    let arrBGColor = [UIColor(named: "Color 1"),UIColor(named: "Color 2"),UIColor(named: "Color 3"),UIColor(named: "Color 4"),UIColor(named: "Color 5"),UIColor(named: "Color 6"),UIColor(named: "Color 7"),UIColor(named: "Color 8"),UIColor(named: "Color 9"),UIColor(named: "Color 10"), UIColor(named: "Color 11"),UIColor(named: "Color 12"),UIColor(named: "Color 13"),UIColor(named: "Color 14"),UIColor(named: "Color 15"),UIColor(named: "Color 16"),UIColor(named: "Color 17"),UIColor(named: "Color 18"),UIColor(named: "Color 19"),UIColor(named: "Color 20"),UIColor(named: "Color 1"),UIColor(named: "Color 2"),UIColor(named: "Color 3"),UIColor(named: "Color 4"),UIColor(named: "Color 5"),UIColor(named: "Color 6")]
    var currentIndex = 0
    let token = UserDefaults.standard.value(forKey: AppConstants.UserAuthToken)! as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigation back btn title changed..
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    // Navigating between cell images
    @IBAction func backBtnPressed(_ sender: UIButton) {
        if currentIndex == 0{
            
        }
        else{
            currentIndex -= 1
            ChapterColView.reloadData()
            lessoncolView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                let idxPath = IndexPath(row: self.currentIndex, section: 0)
                
                // this helps to put upper col cell in Center....
                self.ChapterColView.scrollToItem(at: idxPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
            }
        }
    }
    
    // Audio players and their funcs..
    @IBAction func audioBtnPressed(_ sender: UIButton) {
        downloadFileFromURL(url: NSURL(string: lowerFetchedDataFromAPI[currentIndex].sound)!)
    }
    func downloadFileFromURL(url:NSURL){
        let loader = self.loader()
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { [weak self](URL, response, error) -> Void in
            self?.playAudio(url: URL! as NSURL)
            self?.stopLoader(loader: loader)
        })
        downloadTask.resume()
    }
    func playAudio(url:NSURL) {
        print("playing \(url)")
        do {
            self.player = try AVAudioPlayer(contentsOf: url as URL)
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch let error as NSError {
            //self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
    
    @IBAction func forwardBtnPressed(_ sender: UIButton) {
        if currentIndex >= (upperFetchedDataFromAPI.count - 1){
        }
        else{
            currentIndex += 1
            ChapterColView.reloadData()
            lessoncolView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                let idxPath = IndexPath(row: self.currentIndex, section: 0)
                self.ChapterColView.scrollToItem(at: idxPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
            }
        }
    }
    
    // rightBarButton pop btn...
    @IBAction func popBtnPressed(_ sender: UIBarButtonItem) {
        print(upperFetchedDataFromAPI as Any)
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
                                       , withMenuArray: arritem, imageArray: [],configuration:  homePagemodel.configuration, doneBlock: { [self] (selectedIndex) in
                        
                        // here action will be done on clicked btn.
                        if self.arritem.count > 0{
                            
                            if selectedIndex == 0{
                                performSegue(withIdentifier: "gotoProfile", sender: self)
                            }
                            else if selectedIndex == 1{
                                let header: HTTPHeaders? = [.authorization(bearerToken: token)]
                                let loader = self.loader()
                                ServerCommunication.share.APICallingFunction(request: RequestModel(url: APIConstants.LogOutAPI,httpMethod: .post,headerFields: header, parameter: [:])) { response, data in
                                    print(data!)
                                    self.stopLoader(loader: loader)
                                    self.customClass.LogOut(response: response, self: self, datamsg: data!)
                                }
                            }
                        }
                    } , dismiss: {
                        
                    })
                }
            }
        }
        
    }
    
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ChapterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0{
            return upperFetchedDataFromAPI.count
        }
        else{
            // for lower main image section..
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // LowerCollection Cell..
        if collectionView.tag == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChapterVCLowerCell", for: indexPath) as! ChapterVCLowerCell
            cell.imgLesson.downloaded(from: lowerFetchedDataFromAPI[currentIndex].image)
            return cell
        }
        // UpperCollection Cell..
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChapterVCUpperCell", for: indexPath) as! ChapterVCUpperCell
            cell.bgView.layer.cornerRadius = cell.bgView.frame.height/2
            cell.lblOverview.layer.cornerRadius = 34.875
            cell.lblOverview.backgroundColor = arrBGColor[indexPath.row]
            
            // Gets Label/Image data from URL...
            customAlamofire.JString_2_Json(Jstring: upperFetchedDataFromAPI[indexPath.row].nameOrImage, completion: { (jsonData) in
                if jsonData["name_or_image"] as! String == "name"{
                    cell.lblOverview.text = jsonData["value"] as? String
                    cell.imgOverview.image = .none
                    let width = jsonData["value"] as! String
                    cell.viewWidthConst.constant = CGFloat(75 + ((width.count - 1) * 20))
                }
                else{
                    cell.lblOverview.text = ""
                    cell.lblOverview.layer.backgroundColor = UIColor.clear.cgColor
                    cell.imgOverview.downloaded(from: (jsonData["value"] as? String)!)
                    cell.viewWidthConst.constant = CGFloat(75)
                    // image data
                }
            })
            
                // Highlights selected cell..
                if currentIndex == indexPath.row{
                    cell.lblOverview.layer.borderColor = UIColor.gray.cgColor
                    cell.lblOverview.layer.borderWidth = 2
                    cell.layer.shadowColor = UIColor.gray.cgColor
                    cell.layer.shadowOffset = CGSize(width: 0, height: 5.0)
                    cell.layer.shadowRadius = 1.0
                    cell.layer.shadowOpacity = 0.5
                    cell.layer.masksToBounds = false
                }
                else{
                    // makes other cells normal..
                    cell.bgView.backgroundColor = .clear
                    cell.lblOverview.layer.borderColor = UIColor.clear.cgColor
                    cell.layer.shadowColor = UIColor.clear.cgColor
                }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Setting cell size of Upper Coll view..
        if collectionView.tag == 0{
            return CGSize(width: 75, height: 75)
        }
        else{
            return CGSize(width: (view.frame.size.width) * 0.95, height:(view.frame.size.height) * 0.7)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Setting indexPath of UpperColl View to Current Index..
        if collectionView.tag == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChapterVCUpperCell", for: indexPath) as! ChapterVCUpperCell
            cell.bgView.backgroundColor = .red
            currentIndex = indexPath.row
            lessoncolView.reloadData()
            collectionView.reloadData()
        }
    }
}

//MARK: - ChapterVCUpperCell
class ChapterVCUpperCell: UICollectionViewCell{
    
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var viewWidthConst: NSLayoutConstraint!
    @IBOutlet weak var imgOverview: UIImageView!
    
}

//MARK: - ChapterVCLowerCell
class ChapterVCLowerCell: UICollectionViewCell{
    
    @IBOutlet weak var imgLesson: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
}
struct Connectivity {
  static let sharedInstance = NetworkReachabilityManager()!
  static var isConnectedToInternet:Bool {
      return self.sharedInstance.isReachable
    }
}
