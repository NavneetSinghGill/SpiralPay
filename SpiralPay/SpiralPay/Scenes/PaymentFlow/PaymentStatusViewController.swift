//
//  PaymentStatusViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 05/03/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

enum PaymentStatus {
    case Done
    case Failed
    case None
}

class PaymentStatusViewController: SpiralPayViewController {
    
    @IBOutlet weak var statusMessageLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var infoMessageLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var failedViewOfButton: UIView!
    
    var paymentStatus: PaymentStatus = .None

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
    
    //MARK:- Private methods
    
    func initialSetup() {
        if paymentStatus == .Done {
            statusMessageLabel.text = "Done!"
            statusImageView.image = UIImage(named: "paymentDoneTick")
            infoMessageLabel.text = "Your payment has been approved!"
            failedViewOfButton.isHidden = true
        } else if paymentStatus == .Failed {
            statusMessageLabel.text = "Something went wrong!"
            statusImageView.image = UIImage(named: "paymentFailedCross")
            infoMessageLabel.text = "Your transaction was declined!"
            failedViewOfButton.isHidden = false
        }
        
        amountLabel.text = "265.12"
        currencyLabel.text = "£"
        dateLabel.text = "20/Nov/2018"
    }
    
    //MARK:- IBAction methods
    
    @IBAction func thanksButtonTapped() {
        
    }
    
    @IBAction func payWithAnotherCardButtonTapped() {
        
    }
    
    @IBAction func goToSpiralPayButtonTapped() {
        
    }

}
