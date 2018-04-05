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
    
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var postcodeTextField: UITextField!
    
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    var defaultScrollViewHeight: CGFloat!
    
    var indexOfAddressToShow: Int! = -1
    
    var responderTextField: UITextField?

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
    
    @IBAction func saveButtonTapped() {
        
        if indexOfAddressToShow == -1 {
            //Create and add new address
            var addressDict = Dictionary<String,String>()
            addressDict[User.address1] = self.address1TextField.text ?? ""
            addressDict[User.address2] = self.address2TextField.text ?? ""
            addressDict[User.city] = self.cityTextField.text ?? ""
            addressDict[User.postcode] = self.postcodeTextField.text ?? ""
            addressDict[User.country] = self.countryTextField.text ?? ""
            addressDict[User.isDefault] = "false"
            
            User.shared.addresses?.append(addressDict)
            User.shared.save()
        } else {
            //Save to existing address
            var addressDict = User.shared.addresses![indexOfAddressToShow]
            addressDict[User.address1] = self.address1TextField.text ?? ""
            addressDict[User.address2] = self.address2TextField.text ?? ""
            addressDict[User.city] = self.cityTextField.text ?? ""
            addressDict[User.postcode] = self.postcodeTextField.text ?? ""
            addressDict[User.country] = self.countryTextField.text ?? ""
            
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
        
        if (address1TextField.text == nil || address1TextField.text!.count == 0) ||
            (address2TextField.text == nil || address2TextField.text!.count == 0) ||
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
            address1TextField.text = address[User.address1]
            address2TextField.text = address[User.address2]
            cityTextField.text = address[User.city]
            countryTextField.text = address[User.country]
            postcodeTextField.text = address[User.postcode]
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
        if textField == address1TextField {
            address2TextField.becomeFirstResponder()
        } else if textField == address2TextField {
            cityTextField.becomeFirstResponder()
        } else if textField == cityTextField {
            countryTextField.becomeFirstResponder()
        } else if textField == countryTextField {
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
