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
    var name: String?
    var birthday: String?
    var address: String?
    var city: String?
    var postcode: String?

    var phoneWithCode: String? {
        get {
            return "+\(self.countryCode ?? "")\(self.phone ?? "")".replacingOccurrences(of: " ", with: "")
        }
    }
    
    func reset() {
        User.shared = User()
        User.resetSavedValues()
    }
    
    func save() {
        _ = SecurityStorageWorker.shared.setTokenValue(phone ?? "", key: "phone")
        _ = SecurityStorageWorker.shared.setTokenValue(email ?? "", key: "email")
        _ = SecurityStorageWorker.shared.setTokenValue(countryName ?? "", key: "countryName")
        _ = SecurityStorageWorker.shared.setTokenValue(countryCode ?? "", key: "countryCode")
        _ = SecurityStorageWorker.shared.setTokenValue(accessToken ?? "", key: "accessToken")
        _ = SecurityStorageWorker.shared.setTokenValue(customerID ?? "", key: "customerID")
        _ = SecurityStorageWorker.shared.setTokenValue(name ?? "", key: "name")
        _ = SecurityStorageWorker.shared.setTokenValue(birthday ?? "", key: "birthday")
        _ = SecurityStorageWorker.shared.setTokenValue(address ?? "", key: "address")
        _ = SecurityStorageWorker.shared.setTokenValue(city ?? "", key: "city")
        _ = SecurityStorageWorker.shared.setTokenValue(postcode ?? "", key: "postcode")
    }
    
    func restore() {
        phone = SecurityStorageWorker.shared.getKeychainValue(key: "phone")
        email = SecurityStorageWorker.shared.getKeychainValue(key: "email")
        countryName = SecurityStorageWorker.shared.getKeychainValue(key: "countryName")
        countryCode = SecurityStorageWorker.shared.getKeychainValue(key: "countryCode")
        accessToken = SecurityStorageWorker.shared.getKeychainValue(key: "accessToken")
        customerID = SecurityStorageWorker.shared.getKeychainValue(key: "customerID")
        name = SecurityStorageWorker.shared.getKeychainValue(key: "name")
        birthday = SecurityStorageWorker.shared.getKeychainValue(key: "birthday")
        address = SecurityStorageWorker.shared.getKeychainValue(key: "address")
        city = SecurityStorageWorker.shared.getKeychainValue(key: "city")
        postcode = SecurityStorageWorker.shared.getKeychainValue(key: "postcode")
    }
    
    static func resetSavedValues() {
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "phone")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "email")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "countryName")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "countryCode")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "accessToken")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "customerID")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "name")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "birthday")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "address")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "city")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "postcode")
    }
    
}
