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

    override func viewDidLoad() {
        super.viewDidLoad()

        spiralPayHomeButton.isSelected = true
    }
    
    //MARK: IBAction methods
    
    @IBAction func spiralPayButtonTapped() {
        let homeTabBar = HomeContainerViewController.create()
        ApplicationDelegate.getWindow().rootViewController = homeTabBar
    }

}
