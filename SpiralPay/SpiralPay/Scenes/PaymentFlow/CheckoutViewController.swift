//
//  CheckoutViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 07/03/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

enum ShutterAction {
    case Open
    case Close
    case Reverse
}

class CheckoutViewController: SpiralPayViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var chooseCardView: UIView!
    @IBOutlet weak var entensionView1: UIView!
    @IBOutlet weak var entensionView2: UIView!
    @IBOutlet weak var seeMoreView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var dottedImageView: UIImageView!
    
    @IBOutlet weak var seemoreButton: UIButton!
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var last4CardDigitsLabel: UILabel!
    @IBOutlet weak var boldTotalAmountLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var blueViewLeadingContraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var seeMoreViewHeightConstraint: NSLayoutConstraint!
    
    var defaultTableViewHeight: CGFloat = 0
    var defaultSeeMoreViewHeight: CGFloat = 0
    var currency: String?
    
    var subTotal: CGFloat = 0
    var vat: CGFloat = 0.2
    
    var items = [Home.PaymentDetail.Response]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    //MARK:- IBAction methods
    
    @IBAction func chooseCardButtonTapped() {
        doChangesToShutterAsPer(shutterAction: .Close)
        
        blueViewLeadingContraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.chooseCardView.superview?.layoutIfNeeded()
        }
        
        scrollView.scrollRectToVisible(entensionView1.frame, animated: true)
    }
    
    @IBAction func viewDetailButtonTapped() {
        blueViewLeadingContraint.constant = chooseCardView.frame.size.width
        UIView.animate(withDuration: 0.3) {
            self.chooseCardView.superview?.layoutIfNeeded()
        }
        
        scrollView.scrollRectToVisible(entensionView2.frame, animated: true)
    }
    
    @IBAction func seeMoreButtonTapped(button: UIButton) {
        doChangesToShutterAsPer()
    }
    
    @IBAction func declineButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func acceptButtonTapped() {

    }
    
    //MARK:- Private methods
    
    private func initialSetup() {
        setUIwithProduct()
        
        tableView.estimatedRowHeight = 19
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        defaultTableViewHeight = tableViewHeightConstraint.constant
        defaultSeeMoreViewHeight = seeMoreViewHeightConstraint.constant
        
        reloadTableViewData()
        
        addressLabel.text = "\(User.shared.address ?? "") \(User.shared.city ?? "") \(User.shared.countryName ?? "") \(User.shared.postcode ?? "")"
    }
    
    private func setUIwithProduct() {
        subTotal = 0
        for item in items {
            subTotal = subTotal + (item.amount ?? 0)
        }
        
        if let item = items.first {
            currency = Utils.shared.getCurrencyStringWith(currency: item.currency)
        }
        
        let totalAmountString = Utils.shared.getFormattedAmountStringWith(currency: currency, amount: subTotal * (1 + vat))
        totalAmountLabel.text = totalAmountString
        boldTotalAmountLabel.text = "\(subTotal * (1 + vat))"
        currencyLabel.text = currency
    }
    
    private func reloadTableViewData() {
        tableView.reloadData()
        tableViewHeightConstraint.constant = defaultTableViewHeight
        self.view.layoutIfNeeded()
        
        refreshSeeMoreUI()
    }
    
    private func refreshSeeMoreUI() {
        if defaultTableViewHeight >= tableView.contentSize.height {
            seeMoreViewHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
        } else {
            seeMoreViewHeightConstraint.constant = defaultSeeMoreViewHeight
            self.view.layoutIfNeeded()
        }
    }
    
    private func doChangesToShutterAsPer(shutterAction: ShutterAction = .Reverse) {
        if shutterAction == .Reverse {
            seemoreButton.isSelected = !seemoreButton.isSelected
        } else if shutterAction == .Open {
            seemoreButton.isSelected = true
        } else if shutterAction == .Close {
            seemoreButton.isSelected = false
        }
        
        if seemoreButton.isSelected {
            tableViewHeightConstraint.constant = tableView.contentSize.height
        } else {
            tableViewHeightConstraint.constant = defaultTableViewHeight
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }

}

extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count == 0 {
            return 0
        } else {
            return items.count + 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < items.count {
            let itemCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
            
            guard let itemNameLabel = itemCell.viewWithTag(101) as? UILabel else {
                return itemCell
            }
            guard let itemAmountLabel = itemCell.viewWithTag(102) as? UILabel else {
                return itemCell
            }
            
            itemNameLabel.text = "1x \(items[indexPath.row].merchantName ?? "-")"
            itemAmountLabel.text = Utils.shared.getFormattedAmountStringWith(currency: items[indexPath.row].currency, amount: items[indexPath.row].amount)
            
            return itemCell
        } else {
            let itemCell = tableView.dequeueReusableCell(withIdentifier: "AmountCell", for: indexPath)
            
            guard let headingLabel = itemCell.viewWithTag(101) as? UILabel else {
                return itemCell
            }
            guard let amountLabel = itemCell.viewWithTag(102) as? UILabel else {
                return itemCell
            }
            
            if indexPath.row == items.count {
                headingLabel.text = "Sub total"
                amountLabel.text = Utils.shared.getFormattedAmountStringWith(currency: currency, amount: subTotal)
            } else if indexPath.row == items.count + 1 {
                headingLabel.text = "VAT paid"
                amountLabel.text = Utils.shared.getFormattedAmountStringWith(currency: currency, amount: subTotal * vat)
            }
            
            return itemCell
        }
    }
    
}
