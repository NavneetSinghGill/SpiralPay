//
//  EnableTouchViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 17/05/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class EnableTouchViewController: SpiralPayViewController {

    var successBlock: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK:- IBAction methods
    
    @IBAction func notNowButtonTapped() {
        successBlock!()
    }
    
    @IBAction func yesButtonTapped() {
        UserDefaults.standard.set(true, forKey: Constants.kIsFingerPrintEnabled)
        UserDefaults.standard.synchronize()
        
        let touchActivatedVC = TouchActivatedViewController.create()
        touchActivatedVC.successBlock = {self.successBlock!()}
        self.navigationController?.pushViewController(touchActivatedVC, animated: true)
    }
    
    @IBAction func dontAskButtonTapped() {
        UserDefaults.standard.set(true, forKey: Constants.kDontAskAgainForTouchIDenabling)
        UserDefaults.standard.synchronize()
        successBlock!()
    }

}
