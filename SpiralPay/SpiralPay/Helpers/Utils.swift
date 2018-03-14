//
//  Utils.swift
//  SpiralPay
//
//  Created by Zoeb on 16/12/17.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    static var currentProgressBarValue: CGFloat = 0.0
    
    static var shared = {
        return Utils()
    }()
    
    var accessTokenExpiryTimer: Timer?
    var accessTokenExpiryTime: TimeInterval = 15*60
    
    func startAccessTokenExpiryTimer() {
        accessTokenExpiryTimer?.invalidate()
        accessTokenExpiryTimer = Timer.scheduledTimer(withTimeInterval: accessTokenExpiryTime, repeats: false, block: { (timer) in
            DispatchQueue.main.async {
                ApplicationDelegate.showLoginScreenIfShould()
            }
        })
    }
    
    func stopAccessTokenExpiryTimer() {
        accessTokenExpiryTimer?.invalidate()
    }
    
    func getFormattedAmountStringWith(currency: String?, amount: CGFloat?) -> String! {
        if currency == "GBP" || currency == "£" {
            return "£\((amount ?? 0)/100)"
        } else {
            return "\((amount ?? 0)/100) \(currency ?? "")"
        }
    }
    
    func getCurrencyStringWith(currency: String?) -> String! {
        if currency == "GBP" {
            return "£"
        }
        return currency
    }
    
    class func deviceIdentifier() -> String {
        return UserDefaults.standard.string(forKey: Constants.deviceIdentifier) ?? (UIDevice.current.identifierForVendor?.uuidString)!
    }
    
    class func deviceType() -> Int {
        return 1 // 1 for mobile
    }
    
    // Return IP address of WiFi interface (en0) as a String, or `nil`
    func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
   
    //MARK: - Validation Methods
    public class func isValid(email:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    public class func isValid(password:String) -> Bool {
        // Password restriction : password should atleast be 6 characters long and should contain characters with one number or special character.
        
        let charactersRegEx = ".*[A-Za-z]+.*"
        let numberRegEx = ".*[0-9]+.*"
        let specialRegEx = ".*[!@#$%^~&*()-].*"
        
        let characterTest = NSPredicate(format:"SELF MATCHES %@", charactersRegEx)
        let numberTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let specialCharacterTest = NSPredicate(format:"SELF MATCHES %@", specialRegEx)
        
        return (password.count > 5 && characterTest.evaluate(with: password) && (numberTest.evaluate(with: password) || specialCharacterTest.evaluate(with: password)))
    }
    
    func isVisa(text: String) -> Bool {
        let index = text.index(text.startIndex, offsetBy: 1)
        if text[..<index] == "4" {
            return true
        }
        return false
    }
    
    func isMasterCard(text: String) -> Bool {
        let index = text.index(text.startIndex, offsetBy: 1)
        if text[..<index] == "5" {
            return true
        }
        return false
    }
    
    //MARK: - Show Alert
    public class func showAlertWith(message:String, inController:UIViewController) -> Void
    {
        Utils.showAlertWith(title: Constants.kAppName
            , message: message, inController: inController)
       
    }
    
    public class func showAlertWith(title:String, message:String, inController:UIViewController) -> Void {
        
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        inController.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - UIView methods
    
    class func set(semantic: UISemanticContentAttribute, to view: UIView) {
        view.semanticContentAttribute = semantic
        for subView in view.subviews {
            Utils.set(semantic: semantic, to: subView)
        }
    }
    
    func getCountryCodeFor(country: String) -> String? {
        
        let dict = ["Afghanistan": "AFG",
                    "Aland Islands": "ALA",
                    "Albania": "ALB",
                    "Algeria": "DZA",
        "American Samoa": "ASM",
        "Andorra": "AND",
        "Angola": "AGO",
        "Anguilla": "AIA",
        "Antarctica": "ATA",
        "Antigua and Barbuda": "ATG",
        "Argentina": "ARG",
        "Armenia": "ARM",
        "Aruba": "ABW",
        "Australia": "AUS",
        "Austria": "AUT",
        "Azerbaijan": "AZE",
        "Bahamas": "BHS",
        "Bahrain": "BHR",
        "Bangladesh": "BGD",
        "Barbados": "BRB",
        "Belarus": "BLR",
        "Belgium": "BEL",
        "Belize": "BLZ",
        "Benin": "BEN",
        "Bermuda": "BMU",
        "Bhutan": "BTN",
        "Bolivia": "BOL",
        "Bonaire": "BES",
        "Bosnia and Herzegovina": "BIH",
        "Botswana": "BWA",
        "Bouvet Island": "BVT",
        "Brazil": "BRA",
        "British Virgin Islands": "VGB",
        "British Indian Ocean Territory": "IOT",
        "Brunei": "BRN",
        "Bulgaria": "BGR",
        "Burkina Faso": "BFA",
        "Burundi": "BDI",
        "Cambodia": "KHM",
        "Cameroon": "CMR",
        "Canada": "CAN",
        "Cape Verde": "CPV",
        "Cayman Islands": "CYM",
        "Central African Republic": "CAF",
        "Chad": "TCD",
        "Chile": "CHL",
        "China": "CHN",
        "Hong Kong": "HKG",
        "Macao": "MAC",
        "Christmas Island": "CXR",
        "Cocos Islands": "CCK",
        "Colombia": "COL",
        "Comoros": "COM",
        "Cook Islands": "COK",
        "Costa Rica": "CRI",
        "Croatia": "HRV",
        "Cuba": "CUB",
        "Curacao": "CUW",
        "Cyprus": "CYP",
        "Czech Republic": "CZE",
        "Democratic Republic of the Congo": "COD",
        "Denmark": "DNK",
        "Djibouti": "DJI",
        "Dominica": "DMA",
        "Dominican Republic (1 809)": "DOM",
        "Dominican Republic (1 829)": "DOM",
        "Dominican Republic (1 849)": "DOM",
        "Ecuador": "ECU",
        "Egypt": "EGY",
        "El Salvador": "SLV",
        "Equatorial Guinea": "GNQ",
        "Eritrea": "ERI",
        "Estonia": "EST",
        "Ethiopia": "ETH",
        "Falkland Islands": "FLK",
        "Faroe Islands": "FRO",
        "Fiji": "FJI",
        "Finland": "FIN",
        "France": "FRA",
        "French Guiana": "GUF",
        "French Polynesia": "PYF",
        "French Southern Territories": "ATF",
        "Gabon": "GAB",
        "Gambia": "GMB",
        "Georgia": "GEO",
        "Germany": "DEU",
        "Ghana": "GHA",
        "Gibraltar": "GIB",
        "Greece": "GRC",
        "Greenland": "GRL",
        "Grenada": "GRD",
        "Guadeloupe": "GLP",
        "Guam": "GUM",
        "Guatemala": "GTM",
        "Guernsey": "GGY",
        "Guinea": "GIN",
        "Guinea-Bissau": "GNB",
        "Guyana": "GUY",
        "Haiti": "HTI",
        "Heard and Mcdonald Islands": "HMD",
        "Honduras": "HND",
        "Hungary": "HUN",
        "Iceland": "ISL",
        "India": "IND",
        "Indonesia": "IDN",
        "Iran": "IRN",
        "Iraq": "IRQ",
        "Ireland": "IRL",
        "Isle of Man": "IMN",
        "Israel": "ISR",
        "Italy": "ITA",
        "Jamaica": "JAM",
        "Japan": "JPN",
        "Jersey": "JEY",
        "Jordan": "JOR",
        "Kazakhstan": "KAZ",
        "Kenya": "KEN",
        "Kiribati": "KIR",
        "Kuwait": "KWT",
        "Kyrgyzstan": "KGZ",
        "Laos": "LAO",
        "Latvia": "LVA",
        "Lebanon": "LBN",
        "Lesotho": "LSO",
        "Liberia": "LBR",
        "Libya": "LBY",
        "Liechtenstein": "LIE",
        "Lithuania": "LTU",
        "Luxembourg": "LUX",
        "Macedonia": "MKD",
        "Madagascar": "MDG",
        "Malawi": "MWI",
        "Malaysia": "MYS",
        "Maldives": "MDV",
        "Mali": "MLI",
        "Malta": "MLT",
        "Marshall Islands": "MHL",
        "Martinique": "MTQ",
        "Mauritania": "MRT",
        "Mauritius": "MUS",
        "Mayotte": "MYT",
        "Mexico": "MEX",
        "Micronesia": "FSM",
        "Moldova": "MDA",
        "Monaco": "MCO",
        "Mongolia": "MNG",
        "Montenegro": "MNE",
        "Montserrat": "MSR",
        "Morocco": "MAR",
        "Mozambique": "MOZ",
        "Myanmar": "MMR",
        "Namibia": "NAM",
        "Nauru": "NRU",
        "Nepal": "NPL",
        "Netherlands": "NLD",
        "Netherlands Antilles": "ANT",
        "New Caledonia": "NCL",
        "New Zealand": "NZL",
        "Nicaragua": "NIC",
        "Niger": "NER",
        "Nigeria": "NGA",
        "Niue": "NIU",
        "Norfolk Island": "NFK",
        "North Korea": "PRK",
        "Northern Mariana Islands": "MNP",
        "Norway": "NOR",
        "Oman": "OMN",
        "Pakistan": "PAK",
        "Palau": "PLW",
        "Palestine": "PSE",
        "Panama": "PAN",
        "Papua New Guinea": "PNG",
        "Paraguay": "PRY",
        "Peru": "PER",
        "Philippines": "PHL",
        "Pitcairn": "PCN",
        "Poland": "POL",
        "Portugal": "PRT",
        "Puerto Rico (1 787)": "PRI",
        "Puerto Rico (1 939)": "PRI",
        "Qatar": "QAT",
        "Republic of the Congo":"RCB",
        "Réunion": "REU",
        "Romania": "ROU",
        "Russia": "RUS",
        "Rwanda": "RWA",
        "Saint Barthelemy": "BLM",
        "Saint Helena": "SHN",
        "Saint Kitts and Nevis": "KNA",
        "Saint Lucia": "LCA",
        "Saint-Martin (French part)": "MAF",
        "Saint Pierre and Miquelon": "SPM",
        "Saint Vincent and the Grenadines": "VCT",
        "Sint Eustatius":"BES",
        "Sint Maarten":"SXM",
        "Samoa": "WSM",
        "San Marino": "SMR",
        "Sao Tome and Principe": "STP",
        "Saudi Arabia": "SAU",
        "Senegal": "SEN",
        "Serbia": "SRB",
        "Seychelles": "SYC",
        "Sierra Leone": "SLE",
        "Singapore": "SGP",
        "Slovakia": "SVK",
        "Slovenia": "SVN",
        "Solomon Islands": "SLB",
        "Somalia": "SOM",
        "South Africa": "ZAF",
        "South Korea": "KOR",
        "South Georgia and the South Sandwich Islands": "SGS",
        "South Sudan": "SSD",
        "Spain": "ESP",
        "Sri Lanka": "LKA",
        "Sudan": "SDN",
        "Suriname": "SUR",
        "Svalbard and Jan Mayen Islands": "SJM",
        "Swaziland": "SWZ",
        "Sweden": "SWE",
        "Switzerland": "CHE",
        "Syria": "SYR",
        "Taiwan": "TWN",
        "Tajikistan": "TJK",
        "Tanzania": "TZA",
        "Thailand": "THA",
        "East Timor": "TLS",
        "Togo": "TGO",
        "Tokelau": "TKL",
        "Tonga": "TON",
        "Trinidad and Tobago": "TTO",
        "Tunisia": "TUN",
        "Turkey": "TUR",
        "Turkmenistan": "TKM",
        "Turks and Caicos Islands": "TCA",
        "Tuvalu": "TUV",
        "Uganda": "UGA",
        "Ukraine": "UKR",
        "United Arab Emirates": "ARE",
        "United Kingdom": "GBR",
        "United States": "USA",
        "US Minor Outlying Islands": "UMI",
        "Uruguay": "URY",
        "Uzbekistan": "UZB",
        "Vanuatu": "VUT",
        "Vatican": "VAT",
        "Venezuela": "VEN",
        "Vietnam": "VNM",
        "United States Virgin Islands": "VIR",
        "Wallis and Futuna": "WLF",
        "Western Sahara": "ESH",
        "Yemen": "YEM",
        "Zambia": "ZMB",
        "Zimbabwe": "ZWE"]
        
        return dict[country]
    }
}
