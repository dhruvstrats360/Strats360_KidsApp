//
//  SubscribeVIPViewController.swift
//  Strats360_KidsApp
//
//  Created by Strats 360 on 22/02/23.
//

import UIKit

class Subscribe2VIPViewController: UIViewController {
    
    @IBOutlet weak var imgTop: UIImageView!
    @IBOutlet weak var btnSubs: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblVIP: UILabel!
    @IBOutlet weak var imgStar: UIImageView!
    
    @IBOutlet weak var bgView: UIView!
    //Models
    let CustomClassModel = CustomClass()
    
    //Constants
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSubs.frame.size = CGSize(width: btnSubs.frame.width, height: (btnSubs.frame.height * 1.2))
        CustomClassModel.curveBTN(btn: btnSubs)
        btnSubs.titleLabel?.font = UIFont(name: AppConstants.BoldFont, size: 22)
        bgView.layer.cornerRadius = bgView.frame.width * 0.3 / 2
    }
    
    @IBAction func SubBtnPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Payment Gateway", message: "from here payment gateway should appear", preferredStyle: .alert)
        present(alert, animated: true)
    }
}

