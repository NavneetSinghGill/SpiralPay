//
//  SecurityStorageWorker.swift
//  EnvisionWorld
//
//  Created by Zoeb.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class SecurityStorageWorker: NSObject {

    public static var shared = SecurityStorageWorker()

    // Mark:- Set Keychain Value
    public func setTokenValue(_ value: String, key: String) -> Bool {
        return KeychainWrapper.standard.set(value, forKey: key)
    }
    
    public func setArrayUserDefaults(_ value: Array<Dictionary<String,String>>, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    public func setRegularArray(_ value: Array<AnyObject>, key: String) -> Bool {
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        return KeychainWrapper.standard.set(data, forKey: key)
    }

    //MARK:- Get Keychain Value
    public func getKeychainValue(key: String) -> String? {
        return KeychainWrapper.standard.string(forKey: key)
    }
    
    public func getKeychainArrayValue(key: String) -> Array<AnyObject> {
        let data = KeychainWrapper.standard.data(forKey: key)
        if let data = data, let array = NSKeyedUnarchiver.unarchiveObject(with: data) as? Array<AnyObject> {
            return array
        }
        return Array<AnyObject>()
    }
    
    public func getUserDefaultsArrayValue(key: String) -> Array<AnyObject> {
        if let value = UserDefaults.standard.value(forKey: key) as? Array<AnyObject> {
            return value
        }
        return Array<AnyObject>()
    }
    
}
