//
//  LoyaltyTableViewCell.swift
//  SpiralPay
//
//  Created by Zoeb on 25/04/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit



class LoyaltyTableViewCell: UITableViewCell {
    
    var voucher: Voucher?
    var percentage: CGFloat!
    
    @IBOutlet weak var extraInfoView: UIView!
    @IBOutlet weak var upperRedeemView: UIView!
    @IBOutlet weak var redeemView: UIView!
    @IBOutlet weak var circleProgressView: CircularProgressView!
    @IBOutlet weak var lineProgressSuperView: UIView!
    @IBOutlet weak var lineProgressViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var remainingPointsLabel: UILabel!
    @IBOutlet weak var completedPercentageLabel: UILabel!
    
    @IBOutlet weak var voucherName1Label: UILabel!
    @IBOutlet weak var voucherName2Label: UILabel!
    @IBOutlet weak var voucherName3Label: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var voucherImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUI(voucher: Voucher) {
        self.voucher = voucher
        self.percentage = (CGFloat(User.shared.currentLoyaltyPoints/(voucher.pointsToAcquire < 1 ? 1:voucher.pointsToAcquire)))
        circleProgressView.setProgress(percentage: percentage)
        
        lineProgressViewWidthConstraint.constant = lineProgressSuperView.frame.size.width * percentage
        lineProgressSuperView.layoutIfNeeded()
        
        if percentage >= 1 && voucher.isRedeemed == false { //Completed, not redeemed
            remainingPointsLabel.text = "Completed"
            completedPercentageLabel.text = "100% completed"
            upperRedeemView.isHidden = false
        } else {
            remainingPointsLabel.text = "\(Int(ceil(voucher.pointsToAcquire - User.shared.currentLoyaltyPoints)))\nPOINTS"
            completedPercentageLabel.text = "\(Int(percentage*100))% completed"
            upperRedeemView.isHidden = true
        }
        
        voucherName1Label.text = voucher.name
        voucherName2Label.text = voucher.name
        voucherName3Label.text = voucher.name
        
        voucherImageView.image = UIImage(named: voucher.imageURL ?? "")
        
        if voucher.isRedeemed {
            redeemView.isHidden = true
            
            let color = UIColor(displayP3Red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
            circleProgressView.setBorder(color: color)
            remainingPointsLabel.textColor = color
            remainingPointsLabel.text = "Redeemed"
        } else {
            circleProgressView.setBorder(color: Colors.mediumBlue)
            remainingPointsLabel.textColor = UIColor(displayP3Red: 53/255, green: 58/255, blue: 65/255, alpha: 1)
            
            if User.shared.currentLoyaltyPoints < voucher.pointsToAcquire {
                redeemView.isHidden = true
            } else {
                redeemView.isHidden = false
            }
        }
        
        if User.shared.currentLoyaltyPoints < voucher.pointsToAcquire {
            pointsLabel.text = "\(User.shared.currentLoyaltyPoints) of \(voucher.pointsToAcquire)"
        } else {
            pointsLabel.text = ""
        }
    }
    
    //MARK:- IBAction methods
    
    @IBAction func redeemButtonTapped() {
        if let voucher = voucher {
            voucher.isRedeemed = true
            ApplicationDelegate.saveContext()
            
            setUI(voucher: voucher)
        }
    }
    
}
