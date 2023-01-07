//
//  ViewController.swift
//  Strats360_KidsApp
//
//  Created by Strats 360 on 04/01/23.
//

import UIKit

class DescriptionViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var descriptionColView: UICollectionView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var btnBack: UIButton!
    
    //Model initialization
    let customModel = CustomClass()
    
    //Constants
    var counter = 0
    var arrDescription = [1,2,3]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customModel.curveBTN(btn: btnBack)
        customModel.curveBTN(btn: btnNext)
        
        pageController.currentPage = counter
        pageController.numberOfPages = 3
        pageController.layer.shadowOffset = CGSize(width: 0.5, height: 10)
        pageController.tintColor = .black
        pageController.backgroundStyle = .prominent
        btnBack.isHidden = true
        navigationController?.navigationBar.isHidden = true
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
    
    @IBAction func nextPressed(_ sender: UIButton) {
        counter += 1
        if counter < arrDescription.count {
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
            let destinationVC = sb.instantiateViewController(withIdentifier: "SignUpViewController")
            navigationController?.pushViewController(destinationVC, animated: true)
          }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        
        if counter == 1 {
            btnBack.isHidden = true
        }
        else{
            btnBack.isHidden = false
        }
        counter -= 1
        if counter < arrDescription.count {
            
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
        arrDescription.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
        //        cell.insideView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.7)
        cell.imgLogo.image = UIImage(imageLiteralResourceName: "360 Kids logo")
        cell.imgKid.image = UIImage(imageLiteralResourceName: "kid_1")
        cell.lblTitle.text = "Hi my name is dhruv chhatbar"
        cell.lblSubTitle.text = "Hi my name is dhruv 123 235 44512 34234"
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
