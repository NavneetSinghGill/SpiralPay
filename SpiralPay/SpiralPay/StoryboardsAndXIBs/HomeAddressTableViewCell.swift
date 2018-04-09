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

class HomeAddressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressNameLabel: UILabel!
    @IBOutlet weak var defaultButton: UIButton!
    
    @IBOutlet weak var optionsView: UIView!
    
    var address: Dictionary<String,String>?
    var delegate: HomeAddressTableViewCellDelegate?
    var index: Int! = 0
    
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
        self.address = address
        if index == 0 {
            addressNameLabel.text = "Home Address"
        } else {
            addressNameLabel.text = "Shipping Address \(index ?? 0)"
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
            self.optionsView.alpha = 0
        }
    }
    
    func showOptionView() {
        UIView.animate(withDuration: 0.2) {
            self.optionsView.alpha = 1
        }
    }
    
}
