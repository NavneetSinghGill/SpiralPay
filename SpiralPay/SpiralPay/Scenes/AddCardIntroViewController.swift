//
//  AddCardIntroViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 25/05/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class AddCardIntroViewController: SpiralPayViewController {
    
    @IBOutlet weak var addCardButton: SpiralPayButton!
    var appFlowType = AppFlowType.Onboard

    override func viewDidLoad() {
        super.viewDidLoad()

        addCardButton.isSelected = true
    }
    
    //MARK:- IBAction methods
    
    @IBAction func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addCardButtonTapped() {
        let cardAddScreen = AddCardOptionsViewController.create()
        cardAddScreen.appFlowType = appFlowType
        self.navigationController?.pushViewController(cardAddScreen, animated: true)
    }

}
