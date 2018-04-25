//
//  LoyaltyTableViewCell.swift
//  SpiralPay
//
//  Created by Zoeb on 25/04/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit



class LoyaltyTableViewCell: UITableViewCell {
    
    var percentage: CGFloat!
    
    @IBOutlet weak var extraInfoView: UIView!
    @IBOutlet weak var upperRedeemView: UIView!
    @IBOutlet weak var circleProgressView: CircularProgressView!
    @IBOutlet weak var lineProgressSuperView: UIView!
    @IBOutlet weak var lineProgressViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var remainingPointsLabel: UILabel!
    @IBOutlet weak var completedPercentageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUI(percentage: CGFloat, index: Int) {
        print("\(percentage), \(index)")
        self.percentage = percentage
        circleProgressView.setProgress(percentage: percentage)
        
        lineProgressViewWidthConstraint.constant = lineProgressSuperView.frame.size.width * percentage
        lineProgressSuperView.layoutIfNeeded()
        
        if percentage >= 1 { //Completed
            remainingPointsLabel.text = "Completed"
            completedPercentageLabel.text = "100% completed"
            upperRedeemView.isHidden = false
        } else {
            remainingPointsLabel.text = "50\nPOINTS"
            completedPercentageLabel.text = "\(Int(percentage*100))% completed"
            upperRedeemView.isHidden = true
        }
    }
    
}
