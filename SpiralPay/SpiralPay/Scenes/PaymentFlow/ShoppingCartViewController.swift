//
//  ShoppingCartViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 08/03/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit
import CoreData

class ShoppingCartViewController: SpiralPayViewController {
    
    var cellHeight: CGFloat {
        get {
            return self.view.frame.size.height * 0.14
        }
    }
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var shoppingCartLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topDividerImageView: UIImageView!
    @IBOutlet weak var bottomDividerImageView: UIImageView!
    
    var combinedItems: [CombinedItem]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    //MARK:- IBAction methods
    
    @IBAction func backButtonTapped() {
        if navigationController != nil {
            navigationController?.popToRootViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func continueShopping() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func checkout() {
        let productDetailsScreen = ProductDetailsViewController.create()
        if let combinedItems = combinedItems, combinedItems.count > 0 {
            productDetailsScreen.detailsType = DetailsType.Multiple
            productDetailsScreen.combinedItems = combinedItems
            self.navigationController?.pushViewController(productDetailsScreen, animated: true)
        }
    }
    
    //MARK:- Private methods
    
    func initialSetup() {
        let nib = UINib(nibName: "ShoppingCartTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ShoppingCartTableViewCell")
        
        refreshRecords()
        
        reloadTableView()
    }
    
    func refreshRecords() {
        combinedItems = fetchCombinedItems()
        
        setTotalAmount()
        shoppingCartLabel.text = "Shopping Cart (\(combinedItems?.count ?? 0))"
    }
    
    func setTotalAmount() {
        var totalAmount: CGFloat = 0
        var currency = ""
        
        for combinedItem in combinedItems ?? [] {
            totalAmount = totalAmount + CGFloat(combinedItem.count * combinedItem.amount)
            currency = combinedItem.currency ?? ""
        }
        totalAmountLabel.text = Utils.shared.getFormattedAmountStringWith(currency: currency, amount: totalAmount)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshDividers()
    }
    
    func reloadTableView() {
        tableView.reloadData()
        refreshDividers()
    }
    
    func refreshDividers() {
        if tableView.contentOffset.y < -1 {
            topDividerImageView.isHidden = true
        } else {
            topDividerImageView.isHidden = false
        }
        
        if -tableView.contentOffset.y + tableView.contentSize.height <= tableView.frame.size.height {
            bottomDividerImageView.isHidden = true
        } else {
            bottomDividerImageView.isHidden = false
        }
    }

}

extension ShoppingCartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return combinedItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartTableViewCell", for: indexPath) as! ShoppingCartTableViewCell
        cell.indexPath = indexPath
        cell.delegate = self
        
        cell.sizeLabel.text = "Size: -"
        
        let combinedItem = combinedItems![indexPath.row]
        cell.itemName.text = combinedItem.name
        cell.amountLabel.text = Utils.shared.getFormattedAmountStringWith(currency: combinedItem.currency, amount: CGFloat(combinedItem.amount * combinedItem.count))
        cell.quantityLabel.text = "Quantity: \(combinedItem.count)"
        cell.combinedItem = combinedItem
        Utils.shared.downloadImageFrom(url: Utils.shared.getURLfor(id: combinedItem.imageID), for: cell.itemImageView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
}

extension ShoppingCartViewController: ShoppingCartTableViewCellDelegate {
    
    func deleteCellWith(indexPath: IndexPath, combinedItem: CombinedItem?) {
        let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete:\n\(combinedItem?.count ?? 0)x \(combinedItem?.name ?? "-")", preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            if let combinedItem = combinedItem {
                if let items = combinedItem.items {
                    
                    for item in items {
                        
                        if let item = item as? Item {
                            if let payment = item.payment {
                                payment.customerItems = NSSet(array: payment.customerItems!.filter{ item_ in
                                    if let item_ = item_ as? Item {
                                        return item != item_
                                    }
                                    return true
                                })
                            } else if let campaign = item.campaign {
                                campaign.items = NSSet(array: campaign.items!.filter{ item_ in
                                    if let item_ = item_ as? Item {
                                        return item != item_
                                    }
                                    return true
                                })
                            }
                            
                        }
                    }
                    
                }
                ApplicationDelegate.mainContext.delete(combinedItem)
                ApplicationDelegate.saveContext()
            }
            self.refreshRecords()
//            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.reloadTableView()
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}
