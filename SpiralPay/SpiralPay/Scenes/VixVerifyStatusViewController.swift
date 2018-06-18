//
//  VixVerifyStatusViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 15/06/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class VixVerifyStatusViewController: SpiralPayViewController {
    
    var appFlowType = AppFlowType.Onboard
    var verificationStatus: VerificationStatus!
    
    @IBOutlet weak var actionButton: SpiralPayButton!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var subHeadingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        actionButton.isSelected = true
        if appFlowType == .Onboard {
            actionButton.setTitle("Add card", for: .normal)
        } else if appFlowType == .Setting {
            actionButton.setTitle("Done", for: .normal)
        }
        
        if verificationStatus == .pending || verificationStatus == .inProgress {
            headingLabel.text = "We are still verifying you"
            
            let text = "It is taking us longer than usual to verify your details we will be in touch when verified. Meanwhile you can still make purchases of up to £30"
            let attributedText = NSMutableAttributedString(string: text)
            
            attributedText.addAttributes([NSAttributedStringKey.foregroundColor: Colors.mediumBlue, NSAttributedStringKey.font: headingLabel.font], range: Utils.getRangeOfSubString(subString: "£30", fromString: text))
            subHeadingLabel.attributedText = attributedText
        }
    }
    
    //MARK:- IBAction methods
    
    @IBAction func actionButtonTapped() {
        if appFlowType == .Onboard {
            let addCardOptionsScreen = AddCardOptionsViewController.create()
            self.navigationController?.pushViewController(addCardOptionsScreen, animated: true)
        } else if appFlowType == .Setting {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

}
