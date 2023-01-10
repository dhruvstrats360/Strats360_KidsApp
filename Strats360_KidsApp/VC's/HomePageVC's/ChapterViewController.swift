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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
extension ChapterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0{
            return 10
        }
        else{
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChapterVCUpperCell", for: indexPath) as! ChapterVCUpperCell
            cell.imgThumbnail.image = UIImage(imageLiteralResourceName: "GirlIcon")
            cell.bgView.layer.cornerRadius = cell.bgView.frame.width / 2.4
            
            
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChapterVCLowerCell", for: indexPath) as! ChapterVCLowerCell
           
            cell.imgLesson.image = UIImage(imageLiteralResourceName: "Screenshot")
            cell.bgView.bounds.size = CGSize(width: view.frame.width, height: view.frame.height * 0.7)
            cell.imgLesson.bounds.size = CGSize(width: cell.bgView.frame.width, height: cell.bgView.frame.height)
            return cell
        }
    }
}
class ChapterVCUpperCell: UICollectionViewCell{
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgThumbnail: UIImageView!
}
class ChapterVCLowerCell: UICollectionViewCell{
    @IBOutlet weak var imgLesson: UIImageView!
    @IBOutlet weak var bgView: UIView!
}
