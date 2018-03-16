//
//  PaymentHistoryTableViewCell.swift
//  SpiralPay
//
//  Created by Zoeb on 01/03/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class PaymentHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var merchantImageView: UIImageView!
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var exportButton: UIButton!
    
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var detailsTableViewHeightConstraint: NSLayoutConstraint!
    
    var shouldExpand: Bool = false {
        didSet {
            reloadTableView()
        }
    }
    
    var payment: Home.PaymentHistory.Response?
    var totalAmount: CGFloat = 0
    var vat: CGFloat = 0
    var currency: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let nib1 = UINib(nibName: "PaymentPriceDetailsTableViewCell", bundle: nil)
        detailsTableView.register(nib1, forCellReuseIdentifier: "PaymentPriceDetailsTableViewCell")
        let nib2 = UINib(nibName: "ProductTableViewCell", bundle: nil)
        detailsTableView.register(nib2, forCellReuseIdentifier: "ProductTableViewCell")
        
        detailsTableView.rowHeight = UITableViewAutomaticDimension
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Public methods
    
    func reloadTableView() {
        if shouldExpand {
            self.accessoryType = .none
            amountLabel.isHidden = true
            exportButton.isHidden = false
        } else {
            self.accessoryType = .disclosureIndicator
            amountLabel.isHidden = false
            exportButton.isHidden = true
        }
        
        totalAmount = payment?.details?.amount ?? 0
        currency = payment?.details?.currency ?? ""
        vat = payment?.details?.vat ?? 0
        
        detailsTableView.reloadData()
        
        var height: CGFloat = 0
        if payment?.details?.customerItems != nil && payment!.details!.customerItems!.count != 0 {
            height = CGFloat(payment!.details!.customerItems!.count * 50 + 265)
        }
        detailsTableViewHeightConstraint.constant = shouldExpand ? height : 0
        
        self.layoutIfNeeded()
    }
    
    //MARK:- IBAction methods
    
    @IBAction func exportButtonTapped() {
        
    }
    
}

extension PaymentHistoryTableViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldExpand {
            if payment?.details?.customerItems == nil || payment!.details!.customerItems!.count == 0 {
                return 0
            } else {
                return payment!.details!.customerItems!.count + 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == payment!.details!.customerItems!.count { //last cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentPriceDetailsTableViewCell", for: indexPath) as! PaymentPriceDetailsTableViewCell
            
            cell.totalAmountLabel.text = Utils.shared.getFormattedAmountStringWith(currency: currency, amount: totalAmount)
            cell.vatLabel.text = Utils.shared.getFormattedAmountStringWith(currency: currency, amount: vat)
            cell.subTotalAmountLabel.text = Utils.shared.getFormattedAmountStringWith(currency: currency, amount: totalAmount - vat)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
            let customItem = payment!.details!.customerItems![indexPath.row]
            cell.productNameLabel.text = "\(customItem.name ?? "--") x\(customItem.count ?? 1)"

            cell.productAmountLabel.text = Utils.shared.getFormattedAmountStringWith(currency: customItem.currency, amount: customItem.amount)
            
            return cell
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == products!.count { //last cell
//            return 265
//        } else {
//            return 50
//        }
//    }
    
}
