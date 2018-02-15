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
    @IBOutlet weak var addCardButton: SpiralPayButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addCardButton.isSelected = true
        nameLabel.text = User.shared.name
    }
    
    //MARK: IBAction methods
    
    @IBAction func addCardButtonTapped() {
        
    }

}
