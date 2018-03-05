//
//  CheckoutViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 07/03/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class CheckoutViewController: SpiralPayViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var chooseCardView: UIView!
    @IBOutlet weak var entensionView1: UIView!
    @IBOutlet weak var entensionView2: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var last4CardDigitsLabel: UILabel!
    @IBOutlet weak var dottedImageView: UIImageView!
    
    @IBOutlet weak var blueViewLeadingContraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var seeMoreViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var seeMoreView: UIView!
    
    var defaultTableViewHeight: CGFloat = 0
    var defaultSeeMoreViewHeight: CGFloat = 0
    
    var items = ["asdasd"]//,"asdasds122", "ad222sx","ni","as","asd","22ws"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    //MARK:- IBAction methods
    
    @IBAction func chooseCardButtonTapped() {
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
        button.isSelected = !button.isSelected
        if button.isSelected {
            tableViewHeightConstraint.constant = tableView.contentSize.height
        } else {
            tableViewHeightConstraint.constant = defaultTableViewHeight
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    //MARK:- Private methods
    
    private func initialSetup() {
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        
        defaultTableViewHeight = tableViewHeightConstraint.constant
        defaultSeeMoreViewHeight = seeMoreViewHeightConstraint.constant
        
        reloadTableViewData()
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
            
            itemNameLabel.text = "\(indexPath.row)"
            itemAmountLabel.text = "£\(indexPath.row).00"
            
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
                amountLabel.text = "£0.00"
            } else if indexPath.row == items.count + 1 {
                headingLabel.text = "VAT paid"
                amountLabel.text = "£0.00"
            }
            
            return itemCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 19
    }
    
}
