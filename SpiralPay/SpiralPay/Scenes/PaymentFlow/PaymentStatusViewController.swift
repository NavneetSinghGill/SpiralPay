//
//  PaymentStatusViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 05/03/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

enum PaymentStatus {
    case Completed
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
    
    var paymentDetail: Home.PaymentDetail.Response?
    
    var paymentStatus: PaymentStatus = .None

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
    
    //MARK:- Private methods
    
    func initialSetup() {
        if paymentStatus == .Completed {
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
        
        amountLabel.text = "\((paymentDetail?.amount ?? 0)/CGFloat(100))"
        currencyLabel.text = Utils.shared.getCurrencyStringWith(currency: paymentDetail?.currency)
        merchantNameLabel.text = paymentDetail?.merchantName
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yyyy"
        dateLabel.text = dateformatter.string(from: Date())
    }
    
    //MARK:- IBAction methods
    
    @IBAction func thanksButtonTapped() {
        shouldPopToHome()
    }
    
    @IBAction func payWithAnotherCardButtonTapped() {
        
    }
    
    @IBAction func goToSpiralPayButtonTapped() {
        shouldPopToHome()
    }
    
    //MARK:- Private methods
    
    func shouldPopToHome() {
        for viewcontroller in self.navigationController!.viewControllers {
            if let vc = viewcontroller as? HomeContainerViewController {
                vc.homeViewController.shouldRefreshOnNextAppearance = true
            }
        }
        self.navigationController?.popToRootViewController(animated: true)
    }

}
