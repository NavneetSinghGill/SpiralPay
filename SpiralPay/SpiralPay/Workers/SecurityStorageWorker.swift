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

    //MARK:- Get Keychain Value
    public func getKeychainValue(key: String) -> String? {
        return KeychainWrapper.standard.string(forKey: key)
    }
    
}
