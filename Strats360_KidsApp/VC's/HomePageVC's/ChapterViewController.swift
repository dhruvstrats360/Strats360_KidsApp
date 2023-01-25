//
//  ChapterViewController.swift
//  Strats360_KidsApp
//
//  Created by Strats 360 on 09/01/23.
//

import UIKit
import FTPopOverMenu
import FirebaseAuth


class ChapterViewController: UIViewController {

    //Outlets
    
    @IBOutlet weak var ChapterColView: UICollectionView!
    @IBOutlet weak var lessoncolView: UICollectionView!
    
    
    // Custom model
    let customClass = CustomClass()
    let homePagemodel = HomePageModels()
    
    // Constants
    var arritem = ["Profile", "Language", "Sign Out"]
    let arrBGColor = [UIColor(named: "Color 1"),UIColor(named: "Color 2"),UIColor(named: "Color 3"),UIColor(named: "Color 4"),UIColor(named: "Color 5"),UIColor(named: "Color 6"),UIColor(named: "Color 7"),UIColor(named: "Color 8"),UIColor(named: "Color 9"),UIColor(named: "Color 10"), UIColor(named: "Color 1"),UIColor(named: "Color 2"),UIColor(named: "Color 3"),UIColor(named: "Color 4"),UIColor(named: "Color 5"),UIColor(named: "Color 6"),UIColor(named: "Color 7"),UIColor(named: "Color 8"),UIColor(named: "Color 9"),UIColor(named: "Color 10"),UIColor(named: "Color 1"),UIColor(named: "Color 2"),UIColor(named: "Color 3"),UIColor(named: "Color 4"),UIColor(named: "Color 5"),UIColor(named: "Color 6")]
    let arrLetters = ["Abc","Dog","Cat","Giraffe","E","D","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    let arrImages = [ UIImage(imageLiteralResourceName: "1"),UIImage(imageLiteralResourceName: "2"),UIImage(imageLiteralResourceName: "3"),UIImage(imageLiteralResourceName: "4"),UIImage(imageLiteralResourceName: "5"),UIImage(imageLiteralResourceName: "6"),UIImage(imageLiteralResourceName: "7"),UIImage(imageLiteralResourceName: "8"), UIImage(imageLiteralResourceName: "9"), UIImage(imageLiteralResourceName: "10"),UIImage(imageLiteralResourceName: "11"),UIImage(imageLiteralResourceName: "12"),UIImage(imageLiteralResourceName: "13"),UIImage(imageLiteralResourceName: "14"),UIImage(imageLiteralResourceName: "15"),UIImage(imageLiteralResourceName: "16"),UIImage(imageLiteralResourceName: "17"),UIImage(imageLiteralResourceName: "18"), UIImage(imageLiteralResourceName: "19"), UIImage(imageLiteralResourceName: "20"),UIImage(imageLiteralResourceName: "21"),UIImage(imageLiteralResourceName: "22"),UIImage(imageLiteralResourceName: "23"),UIImage(imageLiteralResourceName: "24"),UIImage(imageLiteralResourceName: "25"), UIImage(imageLiteralResourceName: "26")]
    
    var currentIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigation
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.image = UIImage(systemName: "arrow.left.fill")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        if currentIndex == 0{
        }
        else{
            
            currentIndex -= 1
            ChapterColView.reloadData()
            lessoncolView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                let idxPath = IndexPath(row: self.currentIndex, section: 0)
                                self.ChapterColView.scrollToItem(at: idxPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
                        }
        }
    }
    
    @IBAction func audioBtnPressed(_ sender: UIButton) {
    }
    
    @IBAction func forwardBtnPressed(_ sender: UIButton) {
        if currentIndex >= 25{
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
                                           , withMenuArray: arritem, imageArray: [],configuration:  homePagemodel.configuration, doneBlock: { [self] (selectedIndex) in
                            
                            // here action will be done on clicked btn.
                            if self.arritem.count > 0{
                                
                                if selectedIndex == 0{
                                    
                                    performSegue(withIdentifier: "gotoProfile", sender: self)
                                }
                                else if selectedIndex == 1{
                                    // 2nd pop on selected btn.
                                    
                                    FTPopOverMenu.show(fromSenderFrame: popframe
                                                       , withMenuArray: ["Hindi", "English","Gujrati"], imageArray: [],configuration: homePagemodel.configuration, doneBlock: { (selectedIndex) in
                                        if self.arritem.count > 0{
                                        }
                                    } , dismiss: {
                                        
                                    })
                                }
                                else if selectedIndex == 2{
                                    do {
                                      try Auth.auth().signOut()
                                        let storyboard = UIStoryboard(name: "Main", bundle: .main)
                                        let destinationVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                        let customViewControllersArray : NSArray = [destinationVC]
                                        self.navigationController?.viewControllers = customViewControllersArray as! [UIViewController]
                                        self.navigationController?.popToRootViewController(animated: true)
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
        
}
extension ChapterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0{
            return arrLetters.count
        }
        else{
            return 1
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChapterVCLowerCell", for: indexPath) as! ChapterVCLowerCell
           
            cell.imgLesson.image = arrImages[currentIndex]
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChapterVCUpperCell", for: indexPath) as! ChapterVCUpperCell
            cell.bgView.layer.cornerRadius = cell.bgView.frame.height/2
            cell.viewWidthConst.constant = CGFloat(75 + ((arrLetters[indexPath.row].count - 1) * 20))
            
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
                cell.bgView.backgroundColor = .clear
                cell.lblOverview.layer.borderColor = UIColor.clear.cgColor
                cell.layer.shadowColor = UIColor.clear.cgColor
            }
            cell.lblOverview.layer.cornerRadius = 34.875
            cell.lblOverview.backgroundColor = arrBGColor[indexPath.row]
            cell.lblOverview.text = arrLetters[indexPath.row]
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0{
            return CGSize(width: 75, height: 75)
          }
        else{
            return CGSize(width: (view.frame.size.width) * 0.95, height:(view.frame.size.height) * 0.7)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChapterVCUpperCell", for: indexPath) as! ChapterVCUpperCell
            cell.bgView.backgroundColor = .red
            currentIndex = indexPath.row
            lessoncolView.reloadData()
            collectionView.reloadData()
        }
    }
}

class ChapterVCUpperCell: UICollectionViewCell{
    
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var viewWidthConst: NSLayoutConstraint!
    
}
class ChapterVCLowerCell: UICollectionViewCell{
    @IBOutlet weak var imgLesson: UIImageView!
    @IBOutlet weak var bgView: UIView!
}
