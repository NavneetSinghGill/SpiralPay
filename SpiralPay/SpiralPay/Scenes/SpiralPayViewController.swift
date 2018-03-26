//
//  SpiralPayViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 02/02/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit
import CoreData

class SpiralPayViewController: UIViewController {
    
    var badge: Int? {
        didSet {
            if (badge ?? 0) > 0 {
                badgeLabel?.isHidden = false
            } else {
                badgeLabel?.isHidden = true
            }
            if (badge ?? 0) > 9 {
                badgeLabel?.text = "+"
            } else {
                badgeLabel?.text = "\(badge ?? 0)"
            }
        }
    }
    var badgeLabel: UILabel?
    var cartView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if badgeLabel != nil {
            let combinedItems = fetchCombinedItems()
            
            badge = combinedItems.count
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(SpiralPayViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SpiralPayViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardWillShow(keyboardFrame: keyboardSize)
        }
        
    }
    
    func keyboardWillShow(keyboardFrame: CGRect) {
        
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardWillHide(keyboardFrame: keyboardSize)
        }
    }
    
    func keyboardWillHide(keyboardFrame: CGRect) {
        
    }
    
    //MARK: Cart
    
    func addCartIcon(parentView: UIView) {
        let pixelsToBeShiftedBy: CGFloat = 5
        cartView = UIView(frame: CGRect(x: self.view.frame.size.width - 50, y: (self.view == parentView) ? 25 : 5, width: 35 + pixelsToBeShiftedBy, height: 35))
        let cartButton = UIButton(frame: CGRect(x: 0, y: 0, width: cartView!.frame.size.width, height: cartView!.frame.size.height))
        cartButton.setImage(UIImage(named: "cart"), for: .normal)
        cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        cartButton.imageEdgeInsets = UIEdgeInsetsMake(0, -pixelsToBeShiftedBy, 0, 0)
        cartView!.addSubview(cartButton)
        
        let badgeWidth: CGFloat = 16
        badgeLabel = UILabel(frame: CGRect(x: cartView!.frame.size.width - badgeWidth - pixelsToBeShiftedBy, y: 0, width: badgeWidth, height: badgeWidth))
        badgeLabel!.backgroundColor = UIColor(red: 1, green: 211/255, blue: 93/255, alpha: 1)
        badgeLabel!.textAlignment = .center
        badgeLabel!.layer.cornerRadius = badgeWidth/2
        badgeLabel!.clipsToBounds = true
        badgeLabel!.textColor = UIColor.white
        badgeLabel?.font = UIFont(name: "Lato", size: 12)
        cartView!.addSubview(badgeLabel!)
        
        parentView.addSubview(cartView!)
    }
    
    @objc func cartButtonTapped() {
        if badge == 0 {
            return
        }
        let cartScreen = ShoppingCartViewController.create()
        if self.navigationController != nil {
            navigationController?.pushViewController(cartScreen, animated: true)
        } else {
            present(cartScreen, animated: true, completion: nil)
        }
    }
    
    //MARK:- Coredata methods
    
    func fetchCombinedItems() -> [CombinedItem] {
        
        deleteDanglingDataIn(context: ApplicationDelegate.mainContext)
        
        return getCombinedItemsIn(context: ApplicationDelegate.mainContext)
    }
    
    func fetchRecordsIn(context: NSManagedObjectContext) -> [NSManagedObject] {
        var paymentAndCampaigns = [NSManagedObject]()
        do {
            paymentAndCampaigns = try context.fetch(Payment.fetchRequest())
        } catch {
            print("Fetching payments Failed")
        }
        
        do {
            let campaigns: [NSManagedObject] = try context.fetch(Campaign.fetchRequest())
            paymentAndCampaigns.append(contentsOf: campaigns)
        } catch {
            print("Fetching campaigns Failed")
        }
        
        return paymentAndCampaigns
    }
    
    func deleteDanglingDataIn(context: NSManagedObjectContext) {
        deleteDanglingCombinedItemsIn(context: context)
        deleteDanglingItemsIn(context: context)
        
        let paymentAndCampaigns = fetchRecordsIn(context: context)
        var paymentAndCampaignsWithItems = [NSManagedObject]()
        
        for paymentAndCampaign in paymentAndCampaigns {
            if let payment = paymentAndCampaign as? Payment {
                if payment.customerItems == nil || payment.customerItems?.count == 0 {
                    context.delete(payment)
                    continue
                } else {
                    paymentAndCampaignsWithItems.append(payment)
                }
            } else if let campaign = paymentAndCampaign as? Campaign {
                if campaign.items == nil || campaign.items?.count == 0 {
                    context.delete(campaign)
                    continue
                } else {
                    paymentAndCampaignsWithItems.append(campaign)
                }
            }
        }
        
        save(context: context)
    }
    
    func deleteDanglingItemsIn(context: NSManagedObjectContext) {
        
        var items = [Item]()
        do {
            items = try context.fetch(Item.fetchRequest())
        } catch {
            print("Fetching items Failed")
        }
        
        for item in items {
            if ((item.payment == nil) && (item.campaign == nil)) ||
                item.combinedItem == nil {
                context.delete(item)
            }
        }
    }
    
    func deleteDanglingCombinedItemsIn(context: NSManagedObjectContext) {
        
        let combinedItems = getCombinedItemsIn(context: context)
        
        var filteredCombinedItems = [CombinedItem]()
        for combinedItem in combinedItems {
            if combinedItem.items == nil || combinedItem.items!.count == 0 {
                context.delete(combinedItem)
            } else {
                filteredCombinedItems.append(combinedItem)
            }
        }
    }
    
    func getCombinedItemsIn(context: NSManagedObjectContext) -> [CombinedItem] {
        var combinedItems = [CombinedItem]()
        do {
            combinedItems = try context.fetch(CombinedItem.fetchRequest())
        } catch {
            print("Fetching combined items Failed")
        }
        return combinedItems
    }
    
    func save(context: NSManagedObjectContext) {
        if context == ApplicationDelegate.mainContext {
            ApplicationDelegate.saveContext()
        } else {
            do {
                if context.hasChanges {
                    try context.save()
                }
            } catch {
                print("Failed to save general context")
            }
        }
    }

}
