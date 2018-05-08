//
//  LoyaltyViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 20/02/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class LoyaltyViewController: SpiralPayViewController {
    
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var headingView: UIView!
    @IBOutlet weak var bottomViewTopContraint: NSLayoutConstraint!
    @IBOutlet weak var blueViewLeadingContraint: NSLayoutConstraint!
    
    @IBOutlet weak var currentPointHeaderLabel: UILabel!
    @IBOutlet weak var currentPoints: UILabel!
    
    var loyaltyPageViewController : LoyaltyPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if User.shared.currentLoyaltyPoints >= 2 {
            currentPointHeaderLabel.text = "Your Current Points"
        } else {
            currentPointHeaderLabel.text = "Your Current Point"
        }
        currentPoints.text = "\(Int(User.shared.currentLoyaltyPoints))"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLoyaltyPageViewController" {
            if let loyaltyPageViewController = segue.destination as? LoyaltyPageViewController {
                self.loyaltyPageViewController = loyaltyPageViewController
            }
        }
    }
    
    //MARK:- IBAction methods
    
    @IBAction func activeButtonTapped() {
        blueViewLeadingContraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.headingView.layoutIfNeeded()
        }
        loyaltyPageViewController?.setControllerOf(index: 0)
    }
    
    @IBAction func availableButtonTapped() {
        blueViewLeadingContraint.constant = headingView.frame.size.width / 3
        UIView.animate(withDuration: 0.3) {
            self.headingView.layoutIfNeeded()
        }
        loyaltyPageViewController?.setControllerOf(index: 1)
    }
    
    @IBAction func redeemedButtonTapped() {
        blueViewLeadingContraint.constant = (headingView.frame.size.width / 3) * 2
        UIView.animate(withDuration: 0.3) {
            self.headingView.layoutIfNeeded()
        }
        loyaltyPageViewController?.setControllerOf(index: 2)
    }
    
    //MARK:- Private methods
    
    func initialSetup() {
        
        //Add shadow
        headingView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        headingView.layer.shadowOffset = CGSize(width: 0, height: 3)
        headingView.layer.shadowOpacity = 1.0
        headingView.layer.shadowRadius = 10.0
        headingView.layer.masksToBounds = false
    }

}
