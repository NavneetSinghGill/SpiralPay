//
//  AddCardTableViewCell.swift
//  SpiralPay
//
//  Created by Zoeb on 11/04/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

protocol AddCardTableViewCellDelegate {
    func deleteButtonTappedWith(index: Int)
    func editButtonTappedWith(index: Int)
    func defaultButtonTappedWith(index: Int)
}

class AddCardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var defaultButton: UIButton!
    @IBOutlet weak var last4DigitsOnCardLabel: UILabel!
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var  visaImageView: UIImageView!
    @IBOutlet weak var masterCardImageView: UIImageView!

    var card: Dictionary<String,String>?
    var delegate: AddCardTableViewCellDelegate?
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
    
    func doUI(card: Dictionary<String,String>) {
        hideOptionView()
        self.card = card
        if Utils.shared.isVisa(text: card[Card.number] ?? "") {
            cardLabel.text = "VISA CREDIT"
            visaImageView.isHidden = false
            masterCardImageView.isHidden = true
        } else if Utils.shared.isMasterCard(text: card[Card.number] ?? "") {
            cardLabel.text = "MASTERCARD CREDIT"
            visaImageView.isHidden = true
            masterCardImageView.isHidden = false
        }
        
        let cardNumber = card[Card.number] ?? ""
        let last4Digits = String(cardNumber[cardNumber.index(cardNumber.endIndex, offsetBy: -4)..<cardNumber.endIndex])
        cardNumberLabel.text = Utils.shared.addSpacesToCard(text: "**** **** **** \(last4Digits)")
        last4DigitsOnCardLabel.text = last4Digits
        
        if card[Card.isDefault] == "true" {
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
