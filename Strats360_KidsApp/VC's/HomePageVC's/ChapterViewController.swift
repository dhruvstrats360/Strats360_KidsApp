//
//  ChapterViewController.swift
//  Strats360_KidsApp
//
//  Created by Strats 360 on 09/01/23.
//

import UIKit

class ChapterViewController: UIViewController {

    //Outlets
    
    @IBOutlet weak var ChapterColView: UICollectionView!
    @IBOutlet weak var lessoncolView: UICollectionView!
    
    // Custom model
    let customClass = CustomClass()
    
    // Constants
    let arrBGColor = [UIColor(named: "Color 1"),UIColor(named: "Color 2"),UIColor(named: "Color 3"),UIColor(named: "Color 4"),UIColor(named: "Color 5"),UIColor(named: "Color 6"),UIColor(named: "Color 7"),UIColor(named: "Color 8"),UIColor(named: "Color 9"),UIColor(named: "Color 10"), UIColor(named: "Color 1"),UIColor(named: "Color 2"),UIColor(named: "Color 3"),UIColor(named: "Color 4"),UIColor(named: "Color 5"),UIColor(named: "Color 6"),UIColor(named: "Color 7"),UIColor(named: "Color 8"),UIColor(named: "Color 9"),UIColor(named: "Color 10") ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
}
extension ChapterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0{
            return arrBGColor.count
        }
        else{
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChapterVCUpperCell", for: indexPath) as! ChapterVCUpperCell
            cell.bgView.layer.cornerRadius = cell.bgView.frame.width / 2
            cell.lblOverview.layer.cornerRadius = cell.lblOverview.frame.width / 2
            
            cell.lblOverview.backgroundColor = arrBGColor[indexPath.row]
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChapterVCLowerCell", for: indexPath) as! ChapterVCLowerCell
           
            cell.imgLesson.image = UIImage(imageLiteralResourceName: "Screenshot")
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: (view.frame.size.width) * 0.95, height:(view.frame.size.height) * 0.7)
    }
}

class ChapterVCUpperCell: UICollectionViewCell{
    
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var bgView: UIView!
}
class ChapterVCLowerCell: UICollectionViewCell{
    @IBOutlet weak var imgLesson: UIImageView!
    @IBOutlet weak var bgView: UIView!
}
