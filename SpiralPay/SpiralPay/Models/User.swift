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
    
    var mobile: String?
    var email: String?
    var countryName: String?
    var countryCode: String?

}
