//
//  HomeAddressViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 02/04/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class HomeAddressViewController: SpiralPayViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var saveButton: SpiralPayButton!
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var postcodeTextField: UITextField!
    
    @IBOutlet weak var addressHeadingLabel: UILabel!
    
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    var defaultScrollViewHeight: CGFloat!
    
    var indexOfAddressToShow: Int! = -1
    
    var responderTextField: UITextField?
    
    var countryName: String?
    var countryCode: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        addKeyboardObservers()
        defaultScrollViewHeight = scrollView.frame.size.height
        
        fillAddressInUIIfShould()
    }
    
    //MARK:- IBAction methods
    
    @IBAction func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func countryButtonTapped() {
        let countryViewController: CountryViewController = self.storyboard?.instantiateViewController(withIdentifier: "CountryViewController") as! CountryViewController
        countryViewController.countrySelectionDelegate = self
        countryViewController.defaultCountryName = countryName
        countryViewController.defaultCountryCode = countryCode
        
        self.navigationController?.pushViewController(countryViewController, animated: true)
    }
    
    @IBAction func saveButtonTapped() {
        
        if indexOfAddressToShow == -1 {
            //Create and add new address
            var addressDict = Dictionary<String,String>()
            addressDict[User.address] = self.addressTextField.text ?? ""
            addressDict[User.city] = self.cityTextField.text ?? ""
            addressDict[User.postcode] = self.postcodeTextField.text ?? ""
            addressDict[User.country] = self.countryTextField.text ?? ""
            addressDict[User.countryCode] = countryCode ?? ""
            addressDict[User.isDefault] = "false"
            
            User.shared.addresses?.append(addressDict)
            User.shared.save()
        } else {
            //Save to existing address
            var addressDict = User.shared.addresses![indexOfAddressToShow]
            addressDict[User.address] = self.addressTextField.text ?? ""
            addressDict[User.city] = self.cityTextField.text ?? ""
            addressDict[User.postcode] = self.postcodeTextField.text ?? ""
            addressDict[User.country] = self.countryTextField.text ?? ""
            addressDict[User.countryCode] = countryCode ?? ""
            
            User.shared.addresses![indexOfAddressToShow] = addressDict
            User.shared.save()
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK:- Overridden methods
    
    override func keyboardWillShow(keyboardFrame: CGRect) {
        scrollView.isScrollEnabled = true
        scrollViewHeightConstraint.constant = self.view.frame.size.height - keyboardFrame.size.height - self.scrollView.frame.origin.y
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }) { (completed) in
            
        }
        if let textField = self.responderTextField {
            self.scrollView.scrollRectToVisible(textField.frame, animated: true)
        }  
    }
    
    override func keyboardWillHide(keyboardFrame: CGRect) {
        scrollView.isScrollEnabled = false
        scrollViewHeightConstraint.constant = defaultScrollViewHeight
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK:- Private methods
    
    func checkIfEntriesValid() -> Bool {
        var message = ""
        
        if (addressTextField.text == nil || addressTextField.text!.count == 0) ||
            (cityTextField.text == nil || cityTextField.text!.count == 0) ||
            (countryTextField.text == nil || countryTextField.text!.count == 0) ||
            (postcodeTextField.text == nil || postcodeTextField.text!.count == 0) {
            message = "Please enter a valid details."
        }
        
        saveButton.isSelected = message.isEmpty
        return !message.isEmpty
    }
    
    func fillAddressInUIIfShould() {
        if indexOfAddressToShow != -1 {
            let address = User.shared.addresses![indexOfAddressToShow]
            addressTextField.text = address[User.address]
            cityTextField.text = address[User.city]
            postcodeTextField.text = address[User.postcode]
            countryTextField.text = address[User.country]
            countryName = address[User.country]
            countryCode = address[User.countryCode]
            
            if indexOfAddressToShow == 0 {
                addressHeadingLabel.text = "Home Address"
            } else {
                addressHeadingLabel.text = "Shipping Address \(indexOfAddressToShow ?? 1)"
            }
        }
    }

}

extension HomeAddressViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        responderTextField = textField
        saveButton.isSelected = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        _ = self.checkIfEntriesValid()
        if textField == addressTextField {
            cityTextField.becomeFirstResponder()
        } else if textField == cityTextField {
            postcodeTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        _ = self.checkIfEntriesValid()
    }
    
}

extension HomeAddressViewController: CountrySelectionDelegate {
    
    func performActionWith(countryName: String, countryCode: String) {
        self.countryName = countryName
        self.countryCode = countryCode
        
        countryTextField.text = countryName
    }
    
}
