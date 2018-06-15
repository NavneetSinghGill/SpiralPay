//
//  VixVerify.swift
//  SpiralPay
//
//  Created by Zoeb on 07/05/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import Foundation

class VixVerify: NSObject {
    
    static var shared = VixVerify()
    
    var verificationID: String?
    var verificationToken: String?
    var verificationStatus: VerificationStatus?
    
    func reset() {
        VixVerify.shared = VixVerify()
        VixVerify.resetSavedValues()
    }
    
    func save() {
        _ = SecurityStorageWorker.shared.setTokenValue(verificationID ?? "", key: "verificationID")
        _ = SecurityStorageWorker.shared.setTokenValue(verificationToken ?? "", key: "verificationToken")
        _ = SecurityStorageWorker.shared.setTokenValue(verificationStatus?.rawValue ?? "", key: "verificationStatus")
    }
    
    func restore() {
        verificationID = SecurityStorageWorker.shared.getKeychainValue(key: "verificationID") ?? ""
        verificationToken = SecurityStorageWorker.shared.getKeychainValue(key: "verificationToken") ?? ""
        verificationStatus = VerificationStatus.getStatus(string: SecurityStorageWorker.shared.getKeychainValue(key: "verificationStatus") ?? "")
    }
    
    static func resetSavedValues() {
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "verificationID")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "verificationToken")
        _ = SecurityStorageWorker.shared.setTokenValue("", key: "verificationStatus")
    }
    
    func isBuyRestricted() -> Bool {
        if verificationStatus == VerificationStatus.verified ||
            verificationStatus == VerificationStatus.verifiedAdmin {
            return false
        }
        return true

    }
    
}
