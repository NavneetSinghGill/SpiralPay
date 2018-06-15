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

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //MARK:- IBAction methods
    
    @IBAction func backButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
