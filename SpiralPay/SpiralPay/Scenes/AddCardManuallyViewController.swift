//
//  AddCardManuallyViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 15/02/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class AddCardManuallyViewController: SpiralPayViewController {
    
    @IBOutlet weak var cardNumberTextField: FloatingHeaderTextField!
    @IBOutlet weak var expiryTextField: FloatingHeaderTextField!
    @IBOutlet weak var cvvTextField: FloatingHeaderTextField!
    @IBOutlet weak var cardTypeImageView: UIImageView!
    @IBOutlet weak var confirmButton: SpiralPayButton!
    
    let dateFormat = "MM/yy"
    
    let visaImage = UIImage(named: "visaLogo")
    let masterImage = UIImage(named: "masterLogo")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addKeyboardObservers()
    }
    
    //MARK:- IBAction methods
    
    @IBAction func cardCaptureButtonTapped() {
        
    }
    
    @IBAction func confirmButtonTapped() {
        Card.shared.number = cardNumberTextField.text
        Card.shared.expiry = expiryTextField.text
        Card.shared.cvv = cvvTextField.text
        
        Card.shared.save()
        
        User.shared.savedState = .CardAdded
        User.shared.save()
        
        let cardAddScreen = CardAddedViewController.create()
        self.navigationController?.pushViewController(cardAddScreen, animated: true)
    }
    
    @IBAction func dateButtonTapped() {
        let dateAndTimeVC: DateAndTimeViewController = DateAndTimeViewController.create()
        
        dateAndTimeVC.modalTransitionStyle = .crossDissolve
        dateAndTimeVC.modalPresentationStyle = .overCurrentContext
        dateAndTimeVC.dateAndTimeDelegate = self
        dateAndTimeVC.pickerType = .MonthYear
        
        self.navigationController?.present(dateAndTimeVC,
                                                      animated: true,
                                                      completion: nil)
    }
    
    //MARK:- Private methods
    
    private func checkValidity() {
        var areEntriesValid = true
        if cardNumberTextField.text == nil || cardNumberTextField.text!.count < 12 {
            cardNumberTextField.setErrorColor()
            areEntriesValid = false
        }
        if expiryTextField.text == nil || expiryTextField.text!.count == 0 {
            expiryTextField.setErrorColor()
            areEntriesValid = false
        } else {
            expiryTextField.setDefaultColor()
        }
        if cvvTextField.text == nil || cvvTextField.text!.count < 3 {
            cvvTextField.setErrorColor()
            areEntriesValid = false
        }
        
        confirmButton.isSelected = areEntriesValid
    }
    
    override func keyboardWillShow(keyboardFrame: CGRect) {
        confirmButton.isSelected = false
    }
    
    override func keyboardWillHide(keyboardFrame: CGRect) {
        checkValidity()
    }

}

extension AddCardManuallyViewController: DateAndTimeDelegate {
    
    func getFinal(date: Date) {       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        expiryTextField.text = dateFormatter.string(from: date)
        
        checkValidity()
    }

}

extension AddCardManuallyViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let updatedText = textField.text!.replacingCharacters(in: Range(range, in: textField.text ?? "")!, with: string)
        
        let charSet = CharacterSet(charactersIn: "1234567890").inverted
        
        if updatedText.rangeOfCharacter(from: charSet) != nil {
            return false
        }
        
        if (textField == cardNumberTextField && updatedText.count >= 17) ||
            (textField == cvvTextField && updatedText.count >= 5) {
            return false
        }
        
        if textField == cardNumberTextField {
            if updatedText.count != 0 {
                if Utils.shared.isVisa(text: updatedText) {
                    cardTypeImageView.image = visaImage
                } else if Utils.shared.isMasterCard(text: updatedText) {
                    cardTypeImageView.image = masterImage
                } else {
                    cardTypeImageView.image = nil
                }
            } else {
                cardTypeImageView.image = nil
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkValidity()
        return true
    }
    
}
