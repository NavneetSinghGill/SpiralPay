//
//  HomeAddressTableViewCell.swift
//  SpiralPay
//
//  Created by Zoeb on 04/04/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

protocol HomeAddressTableViewCellDelegate {
    func deleteButtonTappedWith(index: Int)
    func editButtonTappedWith(index: Int)
    func defaultButtonTappedWith(index: Int)
}

enum AddressType {
    case Home
    case Shipping
}

class HomeAddressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressNameLabel: UILabel!
    @IBOutlet weak var defaultButton: UIButton!
    
    @IBOutlet weak var shippingOptionsView: UIView!
    @IBOutlet weak var homeOptionsView: UIView!
    
    var address: Dictionary<String,String>?
    var delegate: HomeAddressTableViewCellDelegate?
    var index: Int! = 0
    var addressType = AddressType.Shipping
    
    var isDefault: Bool! {
        didSet {
            if isDefault {
                defaultButton.isHidden = false
            } else {
                defaultButton.isHidden = true
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func doUI(address: Dictionary<String,String>) {
        hideOptionView()
        self.address = address
        if index == 0 {
            addressNameLabel.text = "Home Address"
            addressType = .Home
        } else {
            addressNameLabel.text = "Shipping Address \(index ?? 0)"
            addressType = .Shipping
        }
        addressLabel.text = "\(address[User.address] ?? "-"), \(address[User.city] ?? "-"), \(address[User.country] ?? "-") \(address[User.postcode] ?? "-")"
        
        if address[User.isDefault] == "true" {
            isDefault = true
        } else {
            isDefault = false
        }
    }
    
    @IBAction func optionsButtonTapped() {
        if isDefault {
            //Since default address cant be deleted or made default again
            delegate?.editButtonTappedWith(index: index)
        } else {
            showOptionView()
        }
    }
    
    @IBAction func deleteButtonTapped() {
        hideOptionView()
        delegate?.deleteButtonTappedWith(index: index)
    }
    
    @IBAction func defaultButtonTapped() {
        hideOptionView()
        delegate?.defaultButtonTappedWith(index: index)
    }
    
    @IBAction func editButtonTapped() {
        hideOptionView()
        delegate?.editButtonTappedWith(index: index)
    }
    
    //MARK:- Private methods
    
    func hideOptionView() {
        UIView.animate(withDuration: 0.2) {
            self.homeOptionsView.alpha = 0
            self.shippingOptionsView.alpha = 0
        }
    }
    
    func showOptionView() {
        UIView.animate(withDuration: 0.2) {
            if self.addressType == .Home {
                self.homeOptionsView.alpha = 1
            } else {
                self.shippingOptionsView.alpha = 1
            }
        }
    }
    
}
