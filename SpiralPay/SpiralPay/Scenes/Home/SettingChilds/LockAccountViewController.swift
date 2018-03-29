//
//  LockAccountViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 29/03/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class LockAccountViewController: SpiralPayViewController {
    
    @IBOutlet weak var lockButton: SpiralPayButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    //MARK:- IBAction methods
    
    @IBAction func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func lockAccountButtonTapped() {

    }
    
    //MARK:- Private methods
    
    func initialSetup() {
        lockButton.isSelected = true
    }

}
