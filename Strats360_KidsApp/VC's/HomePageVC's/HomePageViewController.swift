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
    let arrVIPImg = [UIImage(imageLiteralResourceName: "360 Kids logo")]
    let arrSubImg = [UIImage(imageLiteralResourceName: "Screenshot")]
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Hello"
        SubjectColView.delegate = self
        SubjectColView.dataSource = self
        CustomModel.cornerRadiusTXT(txt: txtSearchBar)
        imgVIP.layer.cornerRadius = 15
        imgVIP.image = arrVIPImg[0]
        navigationController?.isNavigationBarHidden = false
        
    }
    
    
    
    @IBAction func homeBtnPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
extension HomePageViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageCollectionViewCell", for: indexPath) as! HomePageCollectionViewCell
        cell.imgSubject.image = arrSubImg[0]
        cell.lblSubName.text = "Subject Name"
        cell.containerView.layer.cornerRadius = 10
        
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
