//
//  HomePageViewController.swift
//  Strats360_KidsApp
//
//  Created by Strats 360 on 06/01/23.
//

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet weak var imgVIP: UIImageView!
    @IBOutlet weak var SubjectColView: UICollectionView!
    @IBOutlet weak var txtSearchBar: UITextField!
    
    // Custom Model initialized
    let CustomModel = CustomClass()
    
    // Constants
    let arrVIPImg = [UIImage(imageLiteralResourceName: "Screenshot")]
    let arrSubImg = [UIImage(imageLiteralResourceName: "kid_1")]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CustomModel.cornerRadiusTXT(txt: txtSearchBar)
        imgVIP.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
        
    }

}
extension HomePageViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageCollectionViewCell", for: indexPath) as! HomePageCollectionViewCell
        cell.imgSubject.image = arrSubImg[0]
        cell.lblSubName.text = "Subject Name"
        cell.containerView.layer.cornerRadius = 10
        
        return cell
    }
    
    
}


class HomePageCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var lblSubName: UILabel!
    @IBOutlet weak var imgSubject: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
}
