//
//  Dollar30RestrictionViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 18/06/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class Dollar30RestrictionViewController: SpiralPayViewController {
    
    @IBOutlet weak var verifyMyselfButton: UIButton!
    @IBOutlet weak var proceedPaymentButton: UIButton!
    @IBOutlet weak var headingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let text = "Unless you verify your ID you can\nonly make a purchase up to £30"
        let attributedText = NSMutableAttributedString(string: text)
        
        attributedText.addAttributes([NSAttributedStringKey.foregroundColor: Colors.mediumBlue, NSAttributedStringKey.font: headingLabel.font], range: Utils.getRangeOfSubString(subString: "£30", fromString: text))
        headingLabel.attributedText = attributedText
    }
    
    //MARK:- IBAction methods
    
    @IBAction func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func verifyMyselfButtonTapped() {
        routeToVixVerify()
    }
    
    //MARK:- Overridden methods
    
    override func afterVixVerifySuccess(status: VerificationStatus) {
        let vixVerifyStatusScreen = VixVerifyStatusViewController.create()
        vixVerifyStatusScreen.appFlowType = AppFlowType.Setting
        vixVerifyStatusScreen.verificationStatus = status
        self.navigationController?.pushViewController(vixVerifyStatusScreen, animated: true)
    }
    
    override func vixVerifyNotNow() {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
