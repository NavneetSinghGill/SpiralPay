//
//  TouchActivatedViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 17/05/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class TouchActivatedViewController: SpiralPayViewController {

    var successBlock: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    //MARK:- IBAction methods
    
    @IBAction func greatButtonTapped() {
        successBlock!()
    }

}
