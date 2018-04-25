//
//  Card.swift
//  SpiralPay
//
//  Created by Zoeb on 16/02/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import Foundation

class Card: NSObject {
    
    static let number = "number"
    static let expiry = "expiry"
    static let cvv = "cvv"
    static let isDefault = "isDefault"
    
    static var shared = Card()
    
    var number: String?
    var expiry: String?
    var cvv: String?
    var cards: Array<Dictionary<String,String>>?
    
    func reset() {
        Card.shared = Card()
        Card.resetSavedValues()
    }
    
    func save() {
        _ = SecurityStorageWorker.shared.setTokenValue(number ?? "", key: "cardNumber")
        _ = SecurityStorageWorker.shared.setTokenValue(expiry ?? "", key: "cardExpiry")
        _ = SecurityStorageWorker.shared.setTokenValue(cvv ?? "", key: "cardCvv")
        _ = SecurityStorageWorker.shared.setArray((cards as Array<AnyObject>?) ?? Array<AnyObject>(), key: "cards")
    }
    
    func restore() {
        number = SecurityStorageWorker.shared.getKeychainValue(key: "cardNumber") ?? ""
        expiry = SecurityStorageWorker.shared.getKeychainValue(key: "cardExpiry") ?? ""
        cvv = SecurityStorageWorker.shared.getKeychainValue(key: "cardCvv") ?? ""
        cards = SecurityStorageWorker.shared.getKeychainArrayValue(key: "cards") as? Array<Dictionary<String, String>>
    }
    
    static func resetSavedValues() {
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "cardNumber")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "cardExpiry")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "cardCvv")
        _ = SecurityStorageWorker.shared.setArray(Array<AnyObject>(), key: "cards")
    }
    
    func getCurrentCardDict() -> Dictionary<String,String> {
        var dict = Dictionary<String,String>()
        dict[Card.number] = Card.shared.number ?? ""
        dict[Card.expiry] = Card.shared.expiry ?? ""
        dict[Card.cvv] = Card.shared.cvv ?? ""
        
        return dict
    }
    
    func defaultCard() -> Dictionary<String,String> {
        if let cards = Card.shared.cards, cards.count != 0 {
            for card in cards {
                if card[Card.isDefault] == "true" {
                    var dict = Dictionary<String,String>()
                    dict[Card.number] = card[Card.number] ?? ""
                    dict[Card.cvv] = card[Card.cvv] ?? ""
                    dict[Card.expiry] = card[Card.expiry] ?? ""
                    
                    return dict
                }
            }
            //If none default then return first address
            var dict = Dictionary<String,String>()
            dict[Card.number] = cards.first![Card.number] ?? ""
            dict[Card.cvv] = cards.first![Card.cvv] ?? ""
            dict[Card.expiry] = cards.first![Card.expiry] ?? ""
            
            return dict
        }
        return Dictionary<String,String>()
    }
    
}

