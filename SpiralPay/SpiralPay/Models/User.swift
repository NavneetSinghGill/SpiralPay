//
//  User.swift
//  SpiralPay
//
//  Created by Zoeb on 02/02/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static var shared = User()
    
    var phone: String?
    var email: String?
    var countryName: String?
    var countryCode: String?
    var accessToken: String?
    var customerID: String?

    var phoneWithCode: String? {
        get {
            return "+\(self.countryCode ?? "")\(self.phone ?? "")".replacingOccurrences(of: " ", with: "")
        }
    }
    
    func reset() {
        User.shared = User()
    }
}
