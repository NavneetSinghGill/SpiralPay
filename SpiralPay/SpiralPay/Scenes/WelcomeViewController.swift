//
//  WelcomeViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 15/02/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class WelcomeViewController: SpiralPayViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var actionButton: SpiralPayButton!
    @IBOutlet weak var subHeadingLabel: UILabel!
    
    var appFlowType = AppFlowType.Onboard
    var verificationStatus: VerificationStatus!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        actionButton.isSelected = true
        nameLabel.text = "\(User.shared.firstName ?? "")"
        
        if verificationStatus == .verified || verificationStatus == .verifiedAdmin {
            subHeadingLabel.text = "Welcome. You are now onboard!\nYour details have been verified, you are now free to make full use of SpiralPay."
        }
        
        if appFlowType == .Onboard {
            actionButton.setTitle("Add card", for: .normal)
        } else if appFlowType == .Setting {
            actionButton.setTitle("Done", for: .normal)
        }
    }
    
    //MARK: IBAction methods
    
    @IBAction func actionButtonTapped() {
        if appFlowType == .Onboard {
            let addCardOptionsScreen = AddCardOptionsViewController.create()
            self.navigationController?.pushViewController(addCardOptionsScreen, animated: true)
        } else if appFlowType == .Setting {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

}
