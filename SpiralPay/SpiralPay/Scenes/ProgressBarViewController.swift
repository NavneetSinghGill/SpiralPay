//
//  ProgressBarViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 02/02/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

let numberOfProgressBarPages: CGFloat = 7

class ProgressBarViewController: SpiralPayViewController {
    
    var percentageOfProgressBar: CGFloat!
    
    @IBOutlet weak var progressBar: ProgressBarView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        progressBar.percentage = Utils.currentProgressBarValue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateProgressBarIfShould()
    }
    
    func animateProgressBarIfShould() {
        if percentageOfProgressBar != nil {
            progressBar.animate(fromPercentage: Utils.currentProgressBarValue, toPercentage: percentageOfProgressBar)
            Utils.currentProgressBarValue = percentageOfProgressBar
        }
    }

}
