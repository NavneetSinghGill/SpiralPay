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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        addCardButton.isSelected = true
        nameLabel.text = "\(User.shared.firstName ?? "")"
    }
    
    //MARK: IBAction methods
    
    @IBAction func addCardButtonTapped() {
        let addCardOptionsScreen = AddCardOptionsViewController.create()
        self.navigationController?.pushViewController(addCardOptionsScreen, animated: true)
    }

}
