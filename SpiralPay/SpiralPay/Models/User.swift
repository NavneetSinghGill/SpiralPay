//
//  User.swift
//  SpiralPay
//
//  Created by Zoeb on 02/02/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import Foundation

enum SavedState {
    case None
    case PinCreated
    case PhoneVerified
    case CustomerDetailsEntered
    case CardAdded
    
    func rawValue() -> String {
        switch self {
        case .None:
            return "None"
        case .PinCreated:
            return "PinCreated"
        case .PhoneVerified:
            return "PhoneVerified"
        case .CustomerDetailsEntered:
            return "CustomerDetailsEntered"
        case .CardAdded:
            return "CardAdded"
        }
    }
}

class User: NSObject {
    
    static var shared = User()
    
    static let address = "address"
    static let city = "city"
    static let postcode = "postcode"
    static let country = "country"
    static let isDefault = "isDefault"
    
    var phone: String?
    var email: String?
    var countryName: String?
    var countryCode: String?
    var accessToken: String?
    var customerID: String?
    var name: String?
    var firstName: String?
    var lastName: String?
    var birthday: String?
    var address: String?
    var city: String?
    var postcode: String?
    var addresses: Array<Dictionary<String,String>>?
    var savedState: SavedState = .None

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
        _ = SecurityStorageWorker.shared.setTokenValue(firstName ?? "", key: "firstName")
        _ = SecurityStorageWorker.shared.setTokenValue(lastName ?? "", key: "lastName")
        _ = SecurityStorageWorker.shared.setTokenValue(birthday ?? "", key: "birthday")
        _ = SecurityStorageWorker.shared.setTokenValue(address ?? "", key: "address")
        _ = SecurityStorageWorker.shared.setTokenValue(city ?? "", key: "city")
        _ = SecurityStorageWorker.shared.setTokenValue(postcode ?? "", key: "postcode")
        _ = SecurityStorageWorker.shared.setArray((addresses as Array<AnyObject>?) ?? Array<AnyObject>(), key: "addresses")
        
        _ = SecurityStorageWorker.shared.setTokenValue(savedState.rawValue(), key: "savedState")
    }
    
    func restore() {
        phone = SecurityStorageWorker.shared.getKeychainValue(key: "phone")
        email = SecurityStorageWorker.shared.getKeychainValue(key: "email")
        countryName = SecurityStorageWorker.shared.getKeychainValue(key: "countryName")
        countryCode = SecurityStorageWorker.shared.getKeychainValue(key: "countryCode")
        accessToken = SecurityStorageWorker.shared.getKeychainValue(key: "accessToken")
        customerID = SecurityStorageWorker.shared.getKeychainValue(key: "customerID")
        name = SecurityStorageWorker.shared.getKeychainValue(key: "name")
        firstName = SecurityStorageWorker.shared.getKeychainValue(key: "firstName")
        lastName = SecurityStorageWorker.shared.getKeychainValue(key: "lastName")
        birthday = SecurityStorageWorker.shared.getKeychainValue(key: "birthday")
        address = SecurityStorageWorker.shared.getKeychainValue(key: "address")
        city = SecurityStorageWorker.shared.getKeychainValue(key: "city")
        postcode = SecurityStorageWorker.shared.getKeychainValue(key: "postcode")
        addresses = SecurityStorageWorker.shared.getKeychainArrayValue(key: "addresses") as? Array<Dictionary<String, String>>
        
        switch SecurityStorageWorker.shared.getKeychainValue(key: "savedState")! {
        case SavedState.None.rawValue():
            savedState = SavedState.None
        case SavedState.PinCreated.rawValue():
            savedState = SavedState.PinCreated
        case SavedState.PhoneVerified.rawValue():
            savedState = SavedState.PhoneVerified
        case SavedState.CustomerDetailsEntered.rawValue():
            savedState = SavedState.CustomerDetailsEntered
        case SavedState.CardAdded.rawValue():
            savedState = SavedState.CardAdded
        default:
            savedState = SavedState.None
        }
    }
    
    static func resetSavedValues() {
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "phone")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "email")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "countryName")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "countryCode")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "accessToken")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "customerID")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "name")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "firstName")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "lastName")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "birthday")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "address")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "city")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "postcode")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "savedState")
        _ = SecurityStorageWorker.shared.setArray(Array<AnyObject>(), key: "addresses")
    }
    
    func getCurrentAddressDict() -> Dictionary<String,String> {
        var dict = Dictionary<String,String>()
        dict[User.address] = User.shared.address ?? ""
        dict[User.city] = User.shared.city ?? ""
        dict[User.postcode] = User.shared.postcode ?? ""
        dict[User.country] = User.shared.countryName ?? ""
        dict[User.isDefault] = "true"
        
        return dict
    }
    
}
