//
//  FloatingHeaderTextField.swift
//  ViewAnimation
//
//  Created by Zoeb  on 24/01/18.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class FloatingHeaderTextField: UITextField {
    
    @IBInspectable
    open var firstResponderColor: UIColor = UIColor(displayP3Red: 0, green: 163/255, blue: 203/255, alpha: 1) {
        didSet {
            if isActive {
                setActiveState()
            }
        }
    }
    
    @IBInspectable
    open var notaResponderWithTextColor: UIColor = UIColor(displayP3Red: 170/255, green: 170/255, blue: 170/255, alpha: 1) {
        didSet {
            if !isActive {
                setInActiveState()
            }
        }
    }
    
    @IBInspectable
    open var notaResponderWithoutTextColor: UIColor = UIColor(displayP3Red: 205/255, green: 210/255, blue: 220/255, alpha: 1) {
        didSet {
            if !isActive {
                setInActiveState()
            }
        }
    }
    
    @IBInspectable
    open var errorTextColor: UIColor = UIColor(displayP3Red: 255/255, green: 187/255, blue: 65/255, alpha: 1) {
        didSet {
            if !isActive {
                setInActiveState()
            }
        }
    }
    
    open var placeholderFontScale: CGFloat = 0.7
    
    open var isActive: Bool = false {
        didSet {
            isActive ? setActiveState() : setInActiveStateIfShould()
        }
    }
    
    var placeholderLabel = UILabel()
    var underLineLayer: CAShapeLayer!
    var defualtTextColor: UIColor?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        refreshUnderLineLayerFrame()
    }
    
    func refreshUnderLineLayerFrame() {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: bounds.size.height))
        path.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height))
        
        underLineLayer.path = path.cgPath
    }
    
    @objc func showHidePassword(button: UIButton) {
        self.isSecureTextEntry = !self.isSecureTextEntry
        button.isSelected = !self.isSecureTextEntry
    }
    
    func setup() {
        if self.isSecureTextEntry {
            rightViewMode = .always
            let buttonPassword = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            buttonPassword.addTarget(self, action: #selector(self.showHidePassword), for: .touchUpInside)
            buttonPassword.setImage(UIImage(named: "hidePassword"), for: .normal)
            buttonPassword.setImage(UIImage(named: "showPassword"), for: .selected)
            rightView = buttonPassword
        }
        self.defualtTextColor = self.textColor
        
        underLineLayer = CAShapeLayer()
        refreshUnderLineLayerFrame()
        self.layer.addSublayer(underLineLayer)
        
        placeholderLabel = UILabel()
        if !(self.text?.isEmpty)! {
            isActive = true
            placeholderLabel.text = placeholder
        }
        isActive = false
        addSubview(placeholderLabel)
    }
    
    override open func drawPlaceholder(in rect: CGRect) {
        super.drawPlaceholder(in: rect)
        placeholderLabel.text = placeholder
        placeholder = nil
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: Notification.Name.UITextFieldTextDidEndEditing, object: self)
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    @objc func textFieldDidBeginEditing() {
        
        UIView.animate(withDuration: 0.25) {
            self.isActive = true
        }
    }
    
    @objc func textFieldDidEndEditing() {
        UIView.animate(withDuration: 0.25, animations: {
            self.isActive = false
        })
    }
    
    func setInActiveState()  {
        underLineLayer.fillColor = UIColor.clear.cgColor
        if self.text == nil || self.text!.isEmpty {
            underLineLayer.strokeColor = notaResponderWithoutTextColor.cgColor
            placeholderLabel.textColor = notaResponderWithoutTextColor
        } else {
            underLineLayer.strokeColor = notaResponderWithTextColor.cgColor
            placeholderLabel.textColor = notaResponderWithTextColor
        }
        
        let isEmpty = text?.isEmpty ?? true
        if isEmpty {
            self.placeholderLabel.transform = CGAffineTransform.identity
            self.placeholderLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.height)
        }
    }
    
    func setActiveState() {
        underLineLayer.fillColor = UIColor.clear.cgColor
        underLineLayer.strokeColor = firstResponderColor.cgColor
        placeholderLabel.textColor = firstResponderColor
        self.textColor = defualtTextColor
        
        self.placeholderLabel.frame = CGRect(x: 0, y: -25, width: self.bounds.size.width, height: self.bounds.size.height)
        self.placeholderLabel.transform = CGAffineTransform(scaleX: self.placeholderFontScale, y: self.placeholderFontScale)
        self.placeholderLabel.frame.origin = CGPoint(x: 0, y: self.placeholderLabel.frame.origin.y)
        if self.placeholderLabel.effectiveUserInterfaceLayoutDirection == .rightToLeft {
            self.placeholderLabel.frame.origin = CGPoint(x: self.frame.size.width - self.placeholderLabel.frame.size.width, y: self.placeholderLabel.frame.origin.y)
        }
    }
    
    func setInActiveStateIfShould() {
        self.setInActiveState()
    }
    
    func setErrorColor() {
        self.textColor = errorTextColor
    }
    
    //MARK:- Validations
    
    func isValidEmail() -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: self.text) {
            return true
        }
        setErrorColor()
        return false
    }
    
    func isValidPhoneNumber() -> Bool {
        if self.text == nil || self.text!.count < 6 || self.text!.count > 10 {
            setErrorColor()
            return false
        }
        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self.text!)) {
            return true
        } else {
            setErrorColor()
            return false
        }
    }
    
}
