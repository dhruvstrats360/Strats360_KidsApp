//
//  VIPViewController.swift
//  Strats360_KidsApp
//
//  Created by Strats 360 on 22/02/23.
//

import UIKit

class VIPDashViewController: UIViewController {

    @IBOutlet weak var imgBanner: UIImageView!
    
    @IBOutlet weak var lblJoiningDate: UILabel!
    @IBOutlet weak var lblExpiringDate: UILabel!
    @IBOutlet weak var dateBGview: UIView!
    @IBOutlet weak var btnMyGifts: UIButton!
    @IBOutlet weak var btnMyDigitals: UIButton!
    @IBOutlet weak var btnMyProfile: UIButton!
    
    //Models
    
    
    
    //Constants
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presetEdits()
    }
    func presetEdits(){
        CustomClass().curveBTN(btn: btnMyGifts)
        CustomClass().curveBTN(btn: btnMyProfile)
        CustomClass().curveBTN(btn: btnMyDigitals)
        lblJoiningDate.font = UIFont(name: AppConstants.BoldFont, size: 25)
        lblExpiringDate.font = UIFont(name: AppConstants.BoldFont, size: 25)
    }
}
