//
//  Card.swift
//  SpiralPay
//
//  Created by Zoeb on 16/02/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import Foundation

class Card: NSObject {
    
    static var shared = Card()
    
    var number: String?
    var expiry: String?
    var cvv: String?
    
    func reset() {
        Card.shared = Card()
        Card.resetSavedValues()
    }
    
    func save() {
        _ = SecurityStorageWorker.shared.setTokenValue(number ?? "", key: "cardNumber")
        _ = SecurityStorageWorker.shared.setTokenValue(expiry ?? "", key: "cardExpiry")
        _ = SecurityStorageWorker.shared.setTokenValue(cvv ?? "", key: "cardCvv")
    }
    
    func restore() {
        number = SecurityStorageWorker.shared.getKeychainValue(key: "cardNumber")
        expiry = SecurityStorageWorker.shared.getKeychainValue(key: "cardExpiry")
        cvv = SecurityStorageWorker.shared.getKeychainValue(key: "cardCvv")
    }
    
    static func resetSavedValues() {
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "cardNumber")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "cardExpiry")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "cardCvv")
    }
    
}

