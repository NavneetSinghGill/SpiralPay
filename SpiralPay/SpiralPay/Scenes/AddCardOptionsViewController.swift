//
//  AddCardOptionsViewController.swift
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

class AddCardOptionsViewController: SpiralPayViewController, CardIOViewDelegate {
    
    @IBOutlet weak var cardSuperView: UIView!
    @IBOutlet weak var cardIOView: CardIOView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var cardNumberTextField: FloatingHeaderTextField!
    @IBOutlet weak var expiryTextField: FloatingHeaderTextField!
    @IBOutlet weak var cvvTextField: FloatingHeaderTextField!
    @IBOutlet weak var cardTypeImageView: UIImageView!
    @IBOutlet weak var confirmButton: SpiralPayButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var manualCardViewButton: UIButton!
    @IBOutlet weak var notNowAndCardCaptureButton: UIButton!
    @IBOutlet weak var cardTypeViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewHeightConstraint: NSLayoutConstraint!
    var cardTypeViewTopConstraintDefaultValue: CGFloat!
    
    let dateFormat = "MM/yy"
    
    let visaImage = UIImage(named: "visaLogo")
    let masterImage = UIImage(named: "masterLogo")
    
    var indexOfCardToShow: Int!
    var appFlowType = AppFlowType.Onboard
    var screenMode = ScreenMode.AddNew
    
    var dictOfCardToCheck: Dictionary<String,String>?
    var saveCardClosure = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !CardIOUtilities.canReadCardWithCamera() {
            //TODO: Hide your "Scan Card" button, or take other appropriate action...
        } else {
            cardIOView.delegate = self
            cardIOView.guideColor = .white
            cardIOView.hideCardIOLogo = true
        }
        
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
        
        cardTypeViewTopConstraintDefaultValue = cardTypeViewTopConstraint.constant
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CardIOUtilities.preloadCardIO()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cardViewHeightConstraint.constant = cardIOView.cameraPreviewFrame.size.height
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK:- IBAction methods
    
    @IBAction func notNowAndCardCaptureButtonTapped() {
        if notNowAndCardCaptureButton.isSelected { //Capture card
            self.view.endEditing(true)
            UIView.transition(with: notNowAndCardCaptureButton, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                self.notNowAndCardCaptureButton.isSelected = false
            }, completion: nil)
            
            cardTypeViewTopConstraint.constant = cardTypeViewTopConstraintDefaultValue
            UIView.animate(withDuration: 0.3) {
                self.topView.alpha = 1
                self.view.layoutIfNeeded()
            }
            
            manualCardViewButton.isHidden = false
            
            captureCardButtonTapped()
        } else { //Not now
            if appFlowType == .Onboard {
                User.shared.savedState = .CardNotAdded
                User.shared.save()
                
                Utils.shared.showHomeTabBarScreen()
            } else if appFlowType == .Home {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func manualCardViewButtonTapped() {
        cardTypeViewTopConstraint.constant = 0
        UIView.transition(with: notNowAndCardCaptureButton, duration: 0.3, options: .transitionFlipFromTop, animations: {
            self.notNowAndCardCaptureButton.isSelected = true
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3) {
            self.topView.alpha = 0
            self.view.layoutIfNeeded()
        }
        
        manualCardViewButton.isHidden = true
    }
    
    @IBAction func confirmButtonTapped() {
        if appFlowType == .Onboard || appFlowType == .Home {
            var dict = Dictionary<String,String>()
            dict[Card.number] = cardNumberTextField.text?.replacingOccurrences(of: " ", with: "") ?? ""
            dict[Card.expiry] = expiryTextField.text ?? ""
            dict[Card.cvv] = cvvTextField.text ?? ""
            dict[Card.isDefault] = "true"
            
            dictOfCardToCheck = dict
            
            saveCardClosure = {
                Card.shared.cards = [dict]
                Card.shared.save()
                
                User.shared.savedState = .CardAdded
                User.shared.save()
                
                let cardAddScreen = CardAddedViewController.create()
                cardAddScreen.appFlowType = self.appFlowType
                self.navigationController?.pushViewController(cardAddScreen, animated: true)
            }
        } else if appFlowType == .Setting {
            if screenMode == .AddNew {
                var dict = Dictionary<String,String>()
                dict[Card.number] = cardNumberTextField.text
                dict[Card.expiry] = expiryTextField.text
                dict[Card.cvv] = cvvTextField.text
                dict[Card.isDefault] = "false"
                
                dictOfCardToCheck = dict
                
                saveCardClosure = {
                    Card.shared.cards?.append(dict)
                    Card.shared.save()
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                var dict = Card.shared.cards![indexOfCardToShow]
                dict[Card.number] = cardNumberTextField.text
                dict[Card.expiry] = expiryTextField.text
                dict[Card.cvv] = cvvTextField.text
                
                dictOfCardToCheck = dict
                
                saveCardClosure = {
                    Card.shared.cards![self.indexOfCardToShow] = dict
                    Card.shared.save()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        
        if let dictOfCardToCheck = self.dictOfCardToCheck {
            let dollarOneScreen = DollarOneCardVerificationViewController.create()
            dollarOneScreen.modalTransitionStyle = .crossDissolve
            dollarOneScreen.modalPresentationStyle = .overCurrentContext
            dollarOneScreen.dictOfCardToCheck = dictOfCardToCheck
            dollarOneScreen.saveCardClosure = saveCardClosure
            self.present(dollarOneScreen, animated: true, completion: nil)
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
    
    @IBAction func captureCardBackButtonTapped() {
        hideCardView()
    }
    
    @IBAction func captureCardButtonTapped() {
        showCardView()
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
    
    func hideCardView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.cardSuperView.alpha = 0
        }) { (complete) in
            self.cardSuperView.isHidden = true
        }
    }
    
    func showCardView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.cardSuperView.alpha = 1
        }) { (complete) in
            self.cardSuperView.isHidden = false
        }
    }
    
    func openDollarOneScreenPopup() {
        let dollarOneScreen = DollarOneCardVerificationViewController.create()
        dollarOneScreen.modalTransitionStyle = .crossDissolve
        dollarOneScreen.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(dollarOneScreen, animated: true, completion: nil)
    }
    
    //MARK:- Card delegate
    
    func cardIOView(_ cardIOView: CardIOView!, didScanCard cardInfo: CardIOCreditCardInfo!) {
        openDollarOneScreenPopup() 
        hideCardView()
        
        if let cardNumber = cardInfo.cardNumber {
            cardNumberTextField.text = Utils.shared.addSpacesToCard(text: "\(cardNumber)")
        } else {
            cardNumberTextField.text = ""
        }
        if cardInfo.expiryMonth != 0, cardInfo.expiryYear != 0 {
            let expiryYear = Int(cardInfo.expiryYear) - Int(Int(cardInfo.expiryYear/100) * 100)
            expiryTextField.text = "\(cardInfo.expiryMonth)/\(expiryYear)"
        } else {
            expiryTextField.text = ""
        }
        cvvTextField.text = ""
        
        manualCardViewButtonTapped()
    }

}

extension AddCardOptionsViewController: DateAndTimeDelegate {
    
    func getFinal(date: Date) {       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        expiryTextField.text = dateFormatter.string(from: date)
        
        checkValidity()
    }

}

extension AddCardOptionsViewController: UITextFieldDelegate {
    
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
