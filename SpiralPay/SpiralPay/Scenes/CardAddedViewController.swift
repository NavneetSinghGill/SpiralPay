//
//  CardAddedViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 16/02/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class CardAddedViewController: SpiralPayViewController {
    
    @IBOutlet weak var spiralPayHomeButton: SpiralPayButton!
    var appFlowType = AppFlowType.Onboard

    override func viewDidLoad() {
        super.viewDidLoad()

        spiralPayHomeButton.isSelected = true
    }
    
    //MARK: IBAction methods
    
    @IBAction func spiralPayButtonTapped() {
        if appFlowType == .Onboard {
            Utils.shared.showHomeTabBarScreen()
        } else if appFlowType == .Home {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

}
