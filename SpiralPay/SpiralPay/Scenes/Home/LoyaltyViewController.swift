//
//  LoyaltyViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 20/02/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class LoyaltyViewController: SpiralPayViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var headingView: UIView!
    @IBOutlet weak var availableView: UIView!
    @IBOutlet weak var bottomViewTopContraint: NSLayoutConstraint!
    @IBOutlet weak var blueViewLeadingContraint: NSLayoutConstraint!
    
    var expandedCellIndex: Int = -1
    var lastContentOffset: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
    
    //MARK:- IBAction methods
    
    @IBAction func availableButtonTapped() {
        blueViewLeadingContraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.headingView.layoutIfNeeded()
        }
    }
    
    @IBAction func completedButtonTapped() {
        blueViewLeadingContraint.constant = availableView.frame.size.width
        UIView.animate(withDuration: 0.3) {
            self.headingView.layoutIfNeeded()
        }
    }
    
    //MARK:- Private methods
    
    func initialSetup() {
        let nib = UINib(nibName: "LoyaltyTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "LoyaltyTableViewCell")
        
        //Add shadow
        headingView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        headingView.layer.shadowOffset = CGSize(width: 0, height: 3)
        headingView.layer.shadowOpacity = 1.0
        headingView.layer.shadowRadius = 10.0
        headingView.layer.masksToBounds = false
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            // moved to top
            if bottomViewTopContraint.constant != -upperView.frame.size.height {
                bottomViewTopContraint.constant = -upperView.frame.size.height
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        } else if (self.lastContentOffset > scrollView.contentOffset.y) {
            // moved to bottom
            if self.tableView.contentOffset.y < 0 && bottomViewTopContraint.constant != 0 {
                bottomViewTopContraint.constant = 0
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        } else {
            // didn't move
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
    }

}

extension LoyaltyViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoyaltyTableViewCell", for: indexPath) as! LoyaltyTableViewCell
        if expandedCellIndex == indexPath.row {
            cell.extraInfoView.alpha = 1
        } else {
            cell.extraInfoView.alpha = 0
        }
        
        cell.setUI(percentage: (CGFloat(arc4random()%101) / 100), index: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if expandedCellIndex == -1 {
            let wouldBeOpenedCell = tableView.cellForRow(at: indexPath) as! LoyaltyTableViewCell
            UIView.animate(withDuration: 0.3, animations: {
                wouldBeOpenedCell.extraInfoView.alpha = 1
            })
            
            expandedCellIndex = indexPath.row
        } else if expandedCellIndex == indexPath.row {
            let toBeClosedCell = tableView.cellForRow(at: indexPath) as! LoyaltyTableViewCell
            UIView.animate(withDuration: 0.3, animations: {
                toBeClosedCell.extraInfoView.alpha = 0
            })
            
            expandedCellIndex = -1
        } else {
            let toBeClosedCell = tableView.cellForRow(at: IndexPath(row: expandedCellIndex, section: 0)) as! LoyaltyTableViewCell
            UIView.animate(withDuration: 0.3, animations: {
                toBeClosedCell.extraInfoView.alpha = 0
            })
            
            let wouldBeOpenedCell = tableView.cellForRow(at: indexPath) as! LoyaltyTableViewCell
            UIView.animate(withDuration: 0.3, animations: {
                wouldBeOpenedCell.extraInfoView.alpha = 1
            })
            
            expandedCellIndex = indexPath.row
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == expandedCellIndex {
            return 70 + 150 + 46 + 15 // 15 is the bottom gap of black shade
        } else {
            return 70 + 15
        }
    }
    
}
