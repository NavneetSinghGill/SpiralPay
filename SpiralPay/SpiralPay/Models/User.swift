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
    case CardNotAdded
    
    func rawValue() -> String {
        switch self {
        case SavedState.None:
            return "None"
        case SavedState.PinCreated:
            return "PinCreated"
        case SavedState.PhoneVerified:
            return "PhoneVerified"
        case SavedState.CustomerDetailsEntered:
            return "CustomerDetailsEntered"
        case SavedState.CardAdded:
            return "CardAdded"
        case SavedState.CardNotAdded:
            return "CardNotAdded"
        }
    }
}

class User: NSObject {
    
    static var shared = User()
    
    static let address = "address"
    static let city = "city"
    static let postcode = "postcode"
    static let country = "country"
    static let countryPhoneCode = "countryPhoneCode"
    static let isDefault = "isDefault"
    static let originatedFromVerificationProcess = "originatedFromVerificationProcess"
    
    var phone: String?
    var email: String?
    var countryName: String?
    var countryPhoneCode: String?
    var accessToken: String?
    var customerID: String?
    var name: String?
    var firstName: String?
    var middleName: String?
    var lastName: String?
    var birthDay: String?
    var birthMonth: String?
    var birthYear: String?
    var address: String?
    var city: String?
    var postcode: String?
    var addresses: Array<Dictionary<String,String>>?
    var savedState: SavedState = SavedState.None
    var currentLoyaltyPoints: Float = 0

    var phoneWithCode: String? {
        get {
            return "+\(self.countryPhoneCode ?? "")\(self.phone ?? "")".replacingOccurrences(of: " ", with: "")
        }
    }
    
    func reset() {
        User.shared = User()
        User.resetSavedValues()
    }
    
    func save() {
//        let addresses = self.addresses ?? Array<Dictionary<String,String>>()
//        SecurityStorageWorker.shared.setArrayUserDefaults(addresses, key: "addresses")
        
        _ = SecurityStorageWorker.shared.setTokenValue(self.phone ?? "", key: "phone")
        _ = SecurityStorageWorker.shared.setTokenValue(self.email ?? "", key: "email")
        _ = SecurityStorageWorker.shared.setTokenValue(self.countryName ?? "", key: "countryName")
        _ = SecurityStorageWorker.shared.setTokenValue(self.countryPhoneCode ?? "", key: "countryPhoneCode")
        _ = SecurityStorageWorker.shared.setTokenValue(self.accessToken ?? "", key: "accessToken")
        _ = SecurityStorageWorker.shared.setTokenValue(self.customerID ?? "", key: "customerID")
        _ = SecurityStorageWorker.shared.setTokenValue(self.name ?? "", key: "name")
        _ = SecurityStorageWorker.shared.setTokenValue(self.firstName ?? "", key: "firstName")
        _ = SecurityStorageWorker.shared.setTokenValue(self.middleName ?? "", key: "middleName")
        _ = SecurityStorageWorker.shared.setTokenValue(self.lastName ?? "", key: "lastName")
        _ = SecurityStorageWorker.shared.setTokenValue(self.birthDay ?? "", key: "birthDay")
        _ = SecurityStorageWorker.shared.setTokenValue(self.birthMonth ?? "", key: "birthMonth")
        _ = SecurityStorageWorker.shared.setTokenValue(self.birthYear ?? "", key: "birthYear")
        _ = SecurityStorageWorker.shared.setTokenValue(self.address ?? "", key: "address")
        _ = SecurityStorageWorker.shared.setTokenValue(self.city ?? "", key: "city")
        _ = SecurityStorageWorker.shared.setTokenValue(self.postcode ?? "", key: "postcode")
        _ = SecurityStorageWorker.shared.setTokenValue(self.savedState.rawValue(), key: "savedState")
        
        //Dont save loyalty points here
    }
    
    func setCurrentLoyaltyPoints(value: Float) {
        User.shared.currentLoyaltyPoints = value
        _ = SecurityStorageWorker.shared.setTokenValue("\(value)", key: "currentLoyaltyPoints")
    }
    
    func addLoyaltyPoints(value: Float) {
        setCurrentLoyaltyPoints(value: User.shared.currentLoyaltyPoints + value)
    }
    
    func restore() {
        phone = SecurityStorageWorker.shared.getKeychainValue(key: "phone") ?? ""
        email = SecurityStorageWorker.shared.getKeychainValue(key: "email") ?? ""
        countryName = SecurityStorageWorker.shared.getKeychainValue(key: "countryName") ?? ""
        countryPhoneCode = SecurityStorageWorker.shared.getKeychainValue(key: "countryPhoneCode") ?? ""
        accessToken = SecurityStorageWorker.shared.getKeychainValue(key: "accessToken") ?? ""
        customerID = SecurityStorageWorker.shared.getKeychainValue(key: "customerID") ?? ""
        name = SecurityStorageWorker.shared.getKeychainValue(key: "name") ?? ""
        firstName = SecurityStorageWorker.shared.getKeychainValue(key: "firstName") ?? ""
        middleName = SecurityStorageWorker.shared.getKeychainValue(key: "middleName") ?? ""
        lastName = SecurityStorageWorker.shared.getKeychainValue(key: "lastName") ?? ""
        birthDay = SecurityStorageWorker.shared.getKeychainValue(key: "birthDay") ?? ""
        birthMonth = SecurityStorageWorker.shared.getKeychainValue(key: "birthMonth") ?? ""
        birthYear = SecurityStorageWorker.shared.getKeychainValue(key: "birthYear") ?? ""
        address = SecurityStorageWorker.shared.getKeychainValue(key: "address") ?? ""
        city = SecurityStorageWorker.shared.getKeychainValue(key: "city") ?? ""
        postcode = SecurityStorageWorker.shared.getKeychainValue(key: "postcode") ?? ""
        addresses = SecurityStorageWorker.shared.getUserDefaultsArrayValue(key: "addresses") as? Array<Dictionary<String, String>>
        
        if let sS = SecurityStorageWorker.shared.getKeychainValue(key: "savedState") {
            switch sS {
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
            case SavedState.CardNotAdded.rawValue():
                savedState = SavedState.CardNotAdded
            default:
                savedState = SavedState.None
            }
        } else {
            savedState = SavedState.None
        }
        
        currentLoyaltyPoints = (SecurityStorageWorker.shared.getKeychainValue(key: "currentLoyaltyPoints") ?? "0").toFloat() ?? 0
    }
    
    static func resetSavedValues() {
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "phone")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "email")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "countryName")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "countryPhoneCode")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "accessToken")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "customerID")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "name")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "firstName")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "middleName")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "lastName")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "birthDay")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "birthMonth")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "birthYear")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "address")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "city")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "postcode")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "savedState")
        _ = SecurityStorageWorker.shared.setArrayUserDefaults(Array<Dictionary<String,String>>(), key: "addresses")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "currentLoyaltyPoints")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "__pin__")
    }
    
    func save(pin: String) {
        _ = SecurityStorageWorker.shared.setTokenValue(pin, key: "__pin__")
    }
    
    func getPin() -> String {
        return SecurityStorageWorker.shared.getKeychainValue(key: "__pin__") ?? ""
    }
    
    func getCurrentAddressDict() -> Dictionary<String,String> {
        var dict = Dictionary<String,String>()
        dict[User.address] = User.shared.address ?? ""
        dict[User.city] = User.shared.city ?? ""
        dict[User.postcode] = User.shared.postcode ?? ""
        dict[User.country] = User.shared.countryName ?? ""
        dict[User.countryPhoneCode] = User.shared.countryPhoneCode ?? ""
        dict[User.originatedFromVerificationProcess] = "true"
        dict[User.isDefault] = "true"
        
        return dict
    }
    
    func defaultAddress() -> Dictionary<String,String> {
        if let addresses = User.shared.addresses, addresses.count != 0 {
            for address in addresses {
                if address[User.isDefault] == "true" {
                    var dict = Dictionary<String,String>()
                    dict[User.address] = address[User.address] ?? ""
                    dict[User.city] = address[User.city] ?? ""
                    dict[User.postcode] = address[User.postcode] ?? ""
                    dict[User.country] = address[User.country] ?? ""
                    dict[User.countryPhoneCode] = address[User.countryPhoneCode] ?? ""
                    dict[User.originatedFromVerificationProcess] = address[User.originatedFromVerificationProcess] ?? ""
                    
                    return dict
                }
            }
            //If none default then return first address
            var dict = Dictionary<String,String>()
            dict[User.address] = addresses.first![User.address] ?? ""
            dict[User.city] = addresses.first![User.city] ?? ""
            dict[User.postcode] = addresses.first![User.postcode] ?? ""
            dict[User.country] = addresses.first![User.country] ?? ""
            dict[User.countryPhoneCode] = addresses.first![User.countryPhoneCode] ?? ""
            dict[User.originatedFromVerificationProcess] = addresses.first![User.originatedFromVerificationProcess] ?? ""
            
            return dict
        }
        return Dictionary<String,String>()
    }
    
}
