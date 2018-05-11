//
//  Constants.swift
// WordPower
//
//  Created by Zoeb  on 11/12/17.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//

import Foundation
import UIKit

let ApplicationDelegate = UIApplication.shared.delegate as! AppDelegate

typealias CompletionHandler = (_ success: Bool, _ response: Any?) -> Void

let isiPad: Bool = UIDevice.current.userInterfaceIdiom == .pad

let screenHeight = UIScreen.main.bounds.size.height
let screenWidth = UIScreen.main.bounds.size.width

//let isTestEnvironment = false
let isTestEnvironment = true

struct VerificationStatus {
    static let verified = "VERIFIED"
    static let inProgress = "IN_PROGRESS"
    static let pending = "PENDING"
}

struct Constants {
    
    static let kHadAppRunBeforeAtleastOnce = "hadAppRunBeforeAtleastOnce"
    
    // MARK: - General Constants
    static let deviceIdentifier = "DeviceIdentifier"
    static let kIsLoggedIn = "IsLoggedIn"
    static let DeviceInfoKey = "device_info"
    static let DeviceTypeKey = "DeviceType"
    static let EmptyString = ""
    static let kErrorMessage = "Something went wrong while processing your request"
    static let kNoNetworkMessage = "No network available"
    static let kContentTypeKey = "Content-Type"
    static let kContentTypeValue = "application/json"
    static let kApiKey = "ApiKey"
    static let kApiKeyValue = "eX2DEXCjXbWVP54iehZmTq95NBS2B8zVyHUQHJNM52Q="
    
    static let kAccessTokenKey = "AccessToken"
    static let kAccessTokenExpiryKey = "AccessTokenExpiry"
    
    static let kRefreshTokenKey = "RefreshToken"
    static let kRefreshTokenLifeKey = "RefreshTokenLife"
    
    static let kAuthorizationkey = "Authorization"
    static let kBearerkey = "Bearer "
    
    static let kAppName = "SpiralPay"
    
    // MARK: - User Defaults
    
    // MARK: - Enums
    enum RequestType: NSInteger {
        case GET
        case POST
        case MultiPartPost
        case DELETE
        case PUT
    }
    
    // MARK: - Numerical Constants
    static let StatusSuccess = 1
    static let ResponseStatusSuccess = 200
    static let ResponseStatusCreated = 201
    static let ResponseStatusAccepted = 202
    static let ResponseStatusForbidden = 401
    
    // MARK: - Network Keys
    static let InsecureProtocol = "http://"
    static let SecureProtocol = "https://"
    static let LocalEnviroment = "LOCAL"
    static let StagingEnviroment = "STAGING"
    static let LiveEnviroment = "LIVE"
    
    
    static let kShouldRunOnlyOnLive = "shouldRunOnlyOnLive"
    
}

struct Secret {
    static let accountID = "envision"
    static let password = "PBf-YHd-sQf-DNg"
    static let apiCode = "Kh4-ccV-H27-V8A"
    static let customCssPath = "https://rawgit.com/szarowski/greenid/master/envision.css"
}

struct Identifiers {
   
    
}

struct Colors {
    static let lightBlue = UIColor(displayP3Red: 139/255, green: 219/255, blue: 231/255, alpha: 1)
    static let mediumBlue = UIColor(displayP3Red: 0/255, green: 164/255, blue: 197/255, alpha: 1)
    static let darkBlue = UIColor(displayP3Red: 0/255, green: 149/255, blue: 178/255, alpha: 1)
    static let orange = UIColor(displayP3Red: 243/255, green: 156/255, blue: 55/255, alpha: 1)
    static let red = UIColor(displayP3Red: 247/255, green: 118/255, blue: 109/255, alpha: 1)
    static let black = UIColor(displayP3Red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
    static let grey = UIColor(displayP3Red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
    static let lightGrey = UIColor(displayP3Red: 195/255, green: 204/255, blue: 211/255, alpha: 1)
    
    static let pink = UIColor(red: 1, green: 0, blue: 133/255, alpha: 1)
}
