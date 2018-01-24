//
//  Utils.swift
//  SpiralPay
//
//  Created by Zoeb on 16/12/17.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    class func deviceIdentifier() -> String {
        return UserDefaults.standard.string(forKey: Constants.deviceIdentifier) ?? (UIDevice.current.identifierForVendor?.uuidString)!
    }
    
    class func deviceType() -> Int {
        return 1 // 1 for mobile
    }
   
    //MARK: - Validation Methods
    public class func isValid(email:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    public class func isValid(password:String) -> Bool {
        // Password restriction : password should atleast be 6 characters long and should contain characters with one number or special character.
        
        let charactersRegEx = ".*[A-Za-z]+.*"
        let numberRegEx = ".*[0-9]+.*"
        let specialRegEx = ".*[!@#$%^~&*()-].*"
        
        let characterTest = NSPredicate(format:"SELF MATCHES %@", charactersRegEx)
        let numberTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let specialCharacterTest = NSPredicate(format:"SELF MATCHES %@", specialRegEx)
        
        return (password.count > 5 && characterTest.evaluate(with: password) && (numberTest.evaluate(with: password) || specialCharacterTest.evaluate(with: password)))
    }
    
    //MARK: - Show Alert
    public class func showAlertWith(message:String, inController:UIViewController) -> Void
    {
        Utils.showAlertWith(title: Constants.kAppName
            , message: message, inController: inController)
       
    }
    
    public class func showAlertWith(title:String, message:String, inController:UIViewController) -> Void {
        
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        inController.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - UIView methods
    
    class func set(semantic: UISemanticContentAttribute, to view: UIView) {
        view.semanticContentAttribute = semantic
        for subView in view.subviews {
            Utils.set(semantic: semantic, to: subView)
        }
    }
}
