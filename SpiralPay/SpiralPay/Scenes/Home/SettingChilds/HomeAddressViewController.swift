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
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    var defaultScrollViewHeight: CGFloat!
    
    var responderTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()

        addKeyboardObservers()
        defaultScrollViewHeight = scrollView.frame.size.height
    }
    
    //MARK:- IBAction methods
    
    @IBAction func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped() {
        //TODO: save and api
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Overridden methods
    
    override func keyboardWillShow(keyboardFrame: CGRect) {
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
        scrollViewHeightConstraint.constant = defaultScrollViewHeight
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

}

extension HomeAddressViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        responderTextField = textField
    }
    
}
