//
//  AddCardManuallyViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 15/02/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

enum ScreenMode {
    case AddNew
    case Edit
}

class AddCardManuallyViewController: SpiralPayViewController {
    
    @IBOutlet weak var cardNumberTextField: FloatingHeaderTextField!
    @IBOutlet weak var expiryTextField: FloatingHeaderTextField!
    @IBOutlet weak var cvvTextField: FloatingHeaderTextField!
    @IBOutlet weak var cardTypeImageView: UIImageView!
    @IBOutlet weak var confirmButton: SpiralPayButton!
    @IBOutlet weak var backButton: UIButton!
    
    let dateFormat = "MM/yy"
    
    let visaImage = UIImage(named: "visaLogo")
    let masterImage = UIImage(named: "masterLogo")
    
    var indexOfCardToShow: Int!
    var appFlowType = AppFlowType.Onboard
    var screenMode = ScreenMode.AddNew
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addKeyboardObservers()
        
        if appFlowType == .Setting {
            if screenMode == .Edit {
                let card = Card.shared.cards![indexOfCardToShow]
                cardNumberTextField.text = Utils.shared.addSpacesToCard(text: card[Card.number] ?? "")
                expiryTextField.text = card[Card.expiry]
                cvvTextField.text = card[Card.cvv]
            }
            confirmButton.setTitle("Save", for: .normal)
            backButton.isHidden = false
        } else {
            backButton.isHidden = true
        }
    }
    
    //MARK:- IBAction methods
    
    @IBAction func cardCaptureButtonTapped() {
        
    }
    
    @IBAction func confirmButtonTapped() {
        if appFlowType == .Onboard {
            Card.shared.number = cardNumberTextField.text?.replacingOccurrences(of: " ", with: "")
            Card.shared.expiry = expiryTextField.text
            Card.shared.cvv = cvvTextField.text
            
            let dict = Card.shared.getCurrentCardDict()
            Card.shared.cards = [dict]
            
            Card.shared.number = ""
            Card.shared.expiry = ""
            Card.shared.cvv = ""
            
            Card.shared.save()
            
            User.shared.savedState = .CardAdded
            User.shared.save()
            
            let cardAddScreen = CardAddedViewController.create()
            self.navigationController?.pushViewController(cardAddScreen, animated: true)
        } else if appFlowType == .Setting {
            if screenMode == .AddNew {
                var dict = Dictionary<String,String>()
                dict[Card.number] = cardNumberTextField.text
                dict[Card.expiry] = expiryTextField.text
                dict[Card.cvv] = cvvTextField.text
                dict[Card.isDefault] = "false"
                
                Card.shared.cards?.append(dict)
                Card.shared.save()
            } else {
                var dict = Card.shared.cards![indexOfCardToShow]
                dict[Card.number] = cardNumberTextField.text
                dict[Card.expiry] = expiryTextField.text
                dict[Card.cvv] = cvvTextField.text
                
                Card.shared.cards![indexOfCardToShow] = dict
                Card.shared.save()
            }
            self.navigationController?.popViewController(animated: true)
        }
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
    
    @IBAction func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
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
        
        if textField == cardNumberTextField {
            let charSet = CharacterSet(charactersIn: "1234567890 ").inverted
            
            if updatedText.rangeOfCharacter(from: charSet) != nil {
                return false
            }
        } else if textField == cvvTextField {
            let charSet = CharacterSet(charactersIn: "1234567890").inverted
            
            if updatedText.rangeOfCharacter(from: charSet) != nil {
                return false
            }
        }
        
        if (textField == cardNumberTextField && updatedText.replacingOccurrences(of: " ", with: "").count >= 20) ||
            (textField == cvvTextField && updatedText.replacingOccurrences(of: " ", with: "").count >= 5) {
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
            
            textField.text = Utils.shared.addSpacesToCard(text: updatedText)
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkValidity()
        return true
    }
    
}
