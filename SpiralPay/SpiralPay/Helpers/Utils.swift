//
//  Utils.swift
//  SpiralPay
//
//  Created by Zoeb on 16/12/17.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    static var currentProgressBarValue: CGFloat = 0.0
    
    static var shared = {
        return Utils()
    }()
    
    var accessTokenExpiryTimer: Timer?
    var accessTokenExpiryTime: TimeInterval = 15*60
    
    func startAccessTokenExpiryTimer() {
        accessTokenExpiryTimer?.invalidate()
        accessTokenExpiryTimer = Timer.scheduledTimer(withTimeInterval: accessTokenExpiryTime, repeats: false, block: { (timer) in
            DispatchQueue.main.async {
                ApplicationDelegate.showLoginScreenIfShould()
            }
        })
    }
    
    func stopAccessTokenExpiryTimer() {
        accessTokenExpiryTimer?.invalidate()
    }
    
    func getFormattedAmountStringWith(currency: String?, amount: CGFloat?) -> String! {
        if currency == "GBP" || currency == "£" {
            return "£\((amount ?? 0)/100)"
        } else {
            return "\((amount ?? 0)/100) \(currency ?? "")"
        }
    }
    
    func getCurrencyStringWith(currency: String?) -> String! {
        if currency == "GBP" {
            return "£"
        }
        return currency
    }
    
    class func deviceIdentifier() -> String {
        return UserDefaults.standard.string(forKey: Constants.deviceIdentifier) ?? (UIDevice.current.identifierForVendor?.uuidString)!
    }
    
    class func deviceType() -> Int {
        return 1 // 1 for mobile
    }
    
    // Return IP address of WiFi interface (en0) as a String, or `nil`
    func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
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
