//
//  LoyaltyContentViewController.swift
//  SpiralPay
//
//  Created by Apple on 08/05/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit
import CoreData

enum LoyaltyContentType {
    case Active
    case Available
    case Redeemed
}

class LoyaltyContentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noVouchersLabel: UILabel!
    
    var loyaltyContentType: LoyaltyContentType = .Active
    var expandedCellIndex: Int = -1
    var lastContentOffset: CGFloat = 0
    
    var vouchers: [Voucher]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    //MARK:- Private methods
    
    func initialSetup() {
        let nib = UINib(nibName: "LoyaltyTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "LoyaltyTableViewCell")
        
        switch loyaltyContentType {
        case .Active:
            noVouchersLabel.text = "No Active vouchers"
        case .Available:
            noVouchersLabel.text = "No Available vouchers"
        case .Redeemed:
            noVouchersLabel.text = "No Redeemed vouchers"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch loyaltyContentType {
        case .Active:
            vouchers = getActiveVouchers()
            tableView.reloadData()
        case .Available:
            vouchers = getAvailableVouchers()
            tableView.reloadData()
        case .Redeemed:
            vouchers = getRedeemedVouchers()
            tableView.reloadData()
        }
        
        if let vouchers = vouchers {
            if vouchers.count > 0 {
                noVouchersLabel.isHidden = true
            } else {
                noVouchersLabel.isHidden = false
            }
        } else {
            noVouchersLabel.isHidden = true
        }
    }
    
    //MARK:- Private methods
    
    func getActiveVouchers(context: NSManagedObjectContext = ApplicationDelegate.mainContext) -> [Voucher]? {
        
        var vouchers: [Voucher]? = nil
        do {
            let fetchRequest = NSFetchRequest<Voucher>(entityName: "Voucher")
            fetchRequest.predicate = NSPredicate(format: "isRedeemed == %@", NSNumber(value: false))
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "pointsToAcquire", ascending: true)]
            vouchers = try context.fetch(fetchRequest)
        } catch {
            print("Fetching vouchers Failed")
        }
        
        return vouchers
    }
    
    func getAvailableVouchers(context: NSManagedObjectContext = ApplicationDelegate.mainContext) -> [Voucher]? {
        
        var vouchers: [Voucher]? = nil
        do {
            let fetchRequest = NSFetchRequest<Voucher>(entityName: "Voucher")
            fetchRequest.predicate = NSPredicate(format: "isRedeemed == %@ AND pointsToAcquire <= %@", NSNumber(value: false), NSNumber(value: User.shared.currentLoyaltyPoints))
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "pointsToAcquire", ascending: true)]
            vouchers = try context.fetch(fetchRequest)
        } catch {
            print("Fetching vouchers Failed")
        }
        
        return vouchers
    }
    
    func getRedeemedVouchers(context: NSManagedObjectContext = ApplicationDelegate.mainContext) -> [Voucher]? {
        
        var vouchers: [Voucher]? = nil
        do {
            let fetchRequest = NSFetchRequest<Voucher>(entityName: "Voucher")
            fetchRequest.predicate = NSPredicate(format: "isRedeemed == %@", NSNumber(value: true))
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "pointsToAcquire", ascending: false)]
            vouchers = try context.fetch(fetchRequest)
        } catch {
            print("Fetching vouchers Failed")
        }
        
        return vouchers
    }
    
    //Uncomment to enable automatic expansion and contraction of tableview
    
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        self.lastContentOffset = scrollView.contentOffset.y
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if let loyaltyPageVC = self.parent as? LoyaltyPageViewController, let loyaltyVC = loyaltyPageVC.parent as? LoyaltyViewController {
//            if (self.lastContentOffset < scrollView.contentOffset.y) {
//                // moved to top
//                if loyaltyVC.bottomViewTopContraint.constant != -loyaltyVC.upperView.frame.size.height {
//                    loyaltyVC.bottomViewTopContraint.constant = -loyaltyVC.upperView.frame.size.height
//                    UIView.animate(withDuration: 0.3, animations: {
//                        loyaltyVC.view.layoutIfNeeded()
//                    })
//                }
//            } else if (self.lastContentOffset > scrollView.contentOffset.y) {
//                // moved to bottom
//                if self.tableView.contentOffset.y < 0 && loyaltyVC.bottomViewTopContraint.constant != 0 {
//                    loyaltyVC.bottomViewTopContraint.constant = 0
//                    UIView.animate(withDuration: 0.3, animations: {
//                        loyaltyVC.view.layoutIfNeeded()
//                    })
//                }
//            } else {
//                // didn't move
//            }
//        }
//    }

}

extension LoyaltyContentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vouchers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoyaltyTableViewCell", for: indexPath) as! LoyaltyTableViewCell
        if expandedCellIndex == indexPath.row {
            cell.extraInfoView.alpha = 1
        } else {
            cell.extraInfoView.alpha = 0
        }
        
        cell.setUI(voucher: vouchers![indexPath.row])
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if expandedCellIndex == -1 {
//            let wouldBeOpenedCell = tableView.cellForRow(at: indexPath) as! LoyaltyTableViewCell
//            UIView.animate(withDuration: 0.3, animations: {
//                wouldBeOpenedCell.extraInfoView.alpha = 1
//            })
//
//            expandedCellIndex = indexPath.row
//        } else if expandedCellIndex == indexPath.row {
//            let toBeClosedCell = tableView.cellForRow(at: indexPath) as! LoyaltyTableViewCell
//            UIView.animate(withDuration: 0.3, animations: {
//                toBeClosedCell.extraInfoView.alpha = 0
//            })
//
//            expandedCellIndex = -1
//        } else {
//            if let toBeClosedCell = tableView.cellForRow(at: IndexPath(row: expandedCellIndex, section: 0)) as? LoyaltyTableViewCell {
//                UIView.animate(withDuration: 0.3, animations: {
//                    toBeClosedCell.extraInfoView.alpha = 0
//                })
//            }
//
//            let wouldBeOpenedCell = tableView.cellForRow(at: indexPath) as! LoyaltyTableViewCell
//            UIView.animate(withDuration: 0.3, animations: {
//                wouldBeOpenedCell.extraInfoView.alpha = 1
//            })
//
//            expandedCellIndex = indexPath.row
//        }
//        tableView.beginUpdates()
//        tableView.endUpdates()
//        if expandedCellIndex != -1 {
//            tableView.scrollToRow(at: IndexPath(row: expandedCellIndex, section: 0), at: .top, animated: true)
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == expandedCellIndex {
            return 70 + 150 + 46 + 15 // 15 is the bottom gap of black shade
        } else {
            return 70 + 15
        }
    }
    
}
