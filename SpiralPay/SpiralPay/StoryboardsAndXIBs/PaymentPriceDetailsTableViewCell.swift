//
//  PaymentPriceDetailsTableViewCell.swift
//  SpiralPay
//
//  Created by Zoeb on 01/03/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class PaymentPriceDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subTotalAmountLabel: UILabel!
    @IBOutlet weak var vatStandardRateAmountLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var refNoLabel: UILabel!
    @IBOutlet weak var vatNoLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
