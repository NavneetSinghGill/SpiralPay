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
    
    let visaImage = UIImage(named: "visaLogo")
    let masterImage = UIImage(named: "masterLogo")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- IBAction methods
    
    @IBAction func cardCaptureButtonTapped() {
        
    }
    
    @IBAction func confirmButtonTapped() {
        
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
    
    func checkValidity() {
        
    }

}

extension AddCardManuallyViewController: DateAndTimeDelegate {
    
    func getFinal(date: Date) {       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        expiryTextField.text = dateFormatter.string(from: date)
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
            let index = updatedText.index(updatedText.startIndex, offsetBy: 1)
            if updatedText[..<index] == "4" {
                cardTypeImageView.image = visaImage
            } else if updatedText[..<index] == "5" {
                cardTypeImageView.image = masterImage
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
