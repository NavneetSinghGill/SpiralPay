//
//  HomeAddressTableViewCell.swift
//  SpiralPay
//
//  Created by Zoeb on 04/04/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

protocol HomeAddressTableViewCellDelegate {
    func defaultButtonTappedWith(index: Int)
    func deleteButtonTappedWith(index: Int)
    func editButtonTappedWith(index: Int)
}

class HomeAddressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityCountryLabel: UILabel!
    @IBOutlet weak var postcodeLabel: UILabel!
    @IBOutlet weak var addressNameLabel: UILabel!
    @IBOutlet weak var defaultButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var address: Dictionary<String,String>?
    var delegate: HomeAddressTableViewCellDelegate?
    var index: Int! = 0
    
    var isDefault: Bool! {
        didSet {
            if isDefault {
                defaultButton.setTitleColor(Colors.mediumBlue, for: .normal)
                defaultButton.layer.borderColor = Colors.mediumBlue.cgColor
                deleteButton.isHidden = true
            } else {
                defaultButton.setTitleColor(Colors.lightGrey, for: .normal)
                defaultButton.layer.borderColor = Colors.lightGrey.cgColor
                deleteButton.isHidden = false
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
        addressNameLabel.text = "Address \(index+1)"
        addressLabel.text = "\(address[User.address1] ?? "-") \(address[User.address2] ?? "-")"
        cityCountryLabel.text = "\(address[User.city] ?? "-"), \(address[User.country] ?? "-")"
        postcodeLabel.text = "\(address[User.postcode] ?? "-")"
        
        if address[User.isDefault] == "true" {
            isDefault = true
        } else {
            isDefault = false
        }
    }
    
    @IBAction func defaultButtonTapped() {
        delegate?.defaultButtonTappedWith(index: index)
    }
    
    @IBAction func deleteButtonTapped() {
        if !isDefault {
            delegate?.deleteButtonTappedWith(index: index)
        }
    }
    
    @IBAction func editButtonTapped() {
        delegate?.editButtonTappedWith(index: index)
    }
    
}
