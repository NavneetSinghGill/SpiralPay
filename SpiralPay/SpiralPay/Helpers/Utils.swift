//
//  Utils.swift
//  SpiralPay
//
//  Created by Zoeb on 16/12/17.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit
import CoreData
import GIDSDK

class Utils: NSObject {
    
    static var currentProgressBarValue: CGFloat = 0.0
    
    static var shared = {
        return Utils()
    }()
    
    var accessTokenExpiryTimer: Timer?
    var accessTokenExpiryTime: TimeInterval = 13*60
    
    var getVerificationResultTimer: Timer?
    var getVerificationResultTime: TimeInterval = 10*60
    
    let imageCache = NSCache<NSString, AnyObject>()
    
    var productionURL: String {
        get {
            return "\(AppSettingsManager.sharedInstance.appSettings.EnableSecureConnection ? Constants.SecureProtocol : Constants.InsecureProtocol)\(AppSettingsManager.sharedInstance.appSettings.ProductionURL)"
        }
    }
    
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
    
    func startGetVerificationResultTimer(shouldCallApiAtStartOnce: Bool) {
        getVerificationResultTimer?.invalidate()
        
        let apiCode = {
            let getVerificationResult = GetVerificationResult()
            getVerificationResult.accountId = Secret.accountID
            getVerificationResult.password = Secret.password
            
            if let token = VixVerify.shared.verificationToken, let vID = VixVerify.shared.verificationID, token.count != 0, vID.count != 0 {
//                getVerificationResult.verificationToken = token
                getVerificationResult.verificationId = vID
                
                Utils.shared.getVerificationResult(getVerificationResult: getVerificationResult)
            }
        }
        
        if shouldCallApiAtStartOnce {
            apiCode()
        }
        
        if VixVerify.shared.verificationStatus != VerificationStatus.verified &&
            (User.shared.savedState == .CustomerDetailsEntered || User.shared.savedState == .CardAdded) {
            
            getVerificationResultTimer = Timer.scheduledTimer(withTimeInterval: getVerificationResultTime, repeats: true, block: { (timer) in
                
                apiCode()
                
            })
        }
    }
    
    func stopGetVerificationResultTimer() {
        getVerificationResultTimer?.invalidate()
        getVerificationResultTimer = nil
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
    
    func getURLfor(id: String?) -> URL {
        let url = "\(productionURL)/v1/file/\(id ?? "")"
        return URL(string: url)!
    }
    
    func downloadImageFrom(url: URL, for imageView: UIImageView) {
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            imageView.image = cachedImage
        } else {
            var request = URLRequest(url: url)
            request.setValue("Bearer \(User.shared.accessToken ?? "")", forHTTPHeaderField: "Authorization")
            let completionHandler = {(data: Data?, response: URLResponse?, error: Error?) -> Void in
                guard let data = data, error == nil, data.count != 0 else { return }
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data)
                    if let imageToCache = imageToCache {
                        self.imageCache.setObject(imageToCache, forKey: url.absoluteString as NSString)
                        imageView.image = imageToCache
                    }
                }
            }
            URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
        }
    }
    
    //MARK:- Vix verify
    
    func getVixVerifyControllerWith(delegate: UIViewController) -> UIViewController {
        let config = [
            "apiCode" : Secret.apiCode,
            "accountId" : Secret.accountID,
            "baseUrl" : "https://simpleui-uat1.vixverify.com",
            "mode" : "onboarding",
            "customCssPath" : Secret.customCssPath,
            "enableProcessOverviewScreen": "true",
            "enableFaceCapture": "true",
            "enableOcrConfirmationScreen": "true",
            "enableIdentityVerification": "true",
            ];
        
        // The following are optional parameters, and greenID will assume default values if you do not set them.
        // "ruleId" : "default",
        // "enableProcessOverviewScreen" : "true",
        // "countryCode" : "AU",
        // "documentCaptureResetTimeout" : "10",
        // "customCssPath" : "https://your.server.here/your.css",
        
        // This should only be used with "mode" : "returningUser",
        // "verificationToken" : "verificationToken",
        
        let main: GIDMainViewController = GIDMainViewController(config:config)!
        main.delegate = delegate as? GIDDelegate
        main.setLoggingLevel(GIDLogLevel.UI)
        
        let logManager: GIDLogManager = GIDLogManager.sharedData()
        logManager.logger = delegate as? GIDLoggerDelegate
        
        return main
    }
    
    func getVerificationResult(getVerificationResult: GetVerificationResult, completionBlock: @escaping (GetVerificationResultResponse?) -> (Void) = {_ in}) {
        
        DynamicFormsServiceV3().getVerificationResult(getVerificationResult: getVerificationResult, completionHandler: { (getVerificationResultResponse) in
            
            let status = getVerificationResultResponse?.return_?.verificationResult?.overallVerificationStatus
            let verificationID = getVerificationResultResponse?.return_?.verificationResult?.verificationId
            let verificationToken = getVerificationResultResponse?.return_?.verificationToken
            
            //Save some data
            VixVerify.shared.verificationStatus = status
            VixVerify.shared.verificationID = verificationID
            VixVerify.shared.verificationToken = verificationToken
            VixVerify.shared.save()
            
            self.stopGetVerificationResultTimer()
            if status == VerificationStatus.verified {
                //Verification succeded
                
            } else {
                self.startGetVerificationResultTimer(shouldCallApiAtStartOnce: false)
            }
            
            completionBlock(getVerificationResultResponse)
            
            
            if let status = status, let verificationID = verificationID {
                //Send status to own sv
                var request = PhoneVerification.UpdateCustomerVerificationData.Request()
                request.status = status
                request.verificationID = verificationID
                
                DispatchQueue.main.async {
                    PhoneVerificationWorker().updateCustomerVerificationData(request: request, successCompletionHandler: { (response) in
                        
                    }, failureCompletionHandler: { (response) in
                        
                    })
                }
            }
            
        })
        
    }
    
    func saveCustomerDetailsWith(getVerificationResultResponse: GetVerificationResultResponse) {
        User.shared.savedState = SavedState.CustomerDetailsEntered
        
        User.shared.firstName = getVerificationResultResponse.return_?.registrationDetails?.name?.givenName ?? ""
        User.shared.middleName = getVerificationResultResponse.return_?.registrationDetails?.name?.middleNames ?? ""
        User.shared.lastName = getVerificationResultResponse.return_?.registrationDetails?.name?.surname ?? ""
        
        User.shared.birthDay = "\(getVerificationResultResponse.return_?.registrationDetails?.dob?.day ?? 0)"
        User.shared.birthMonth = "\(getVerificationResultResponse.return_?.registrationDetails?.dob?.month ?? 0)"
        User.shared.birthYear = "\(getVerificationResultResponse.return_?.registrationDetails?.dob?.year ?? 0)"
        
        User.shared.address = "\(getVerificationResultResponse.return_?.registrationDetails?.currentResidentialAddress?.flatNumber ?? "") \(getVerificationResultResponse.return_?.registrationDetails?.currentResidentialAddress?.streetNumber ?? "") \(getVerificationResultResponse.return_?.registrationDetails?.currentResidentialAddress?.streetName ?? "")".trimmingCharacters(in: .whitespacesAndNewlines)
        
        User.shared.city = getVerificationResultResponse.return_?.registrationDetails?.currentResidentialAddress?.townCity ?? ""
        
        User.shared.postcode = getVerificationResultResponse.return_?.registrationDetails?.currentResidentialAddress?.postcode ?? ""
        
        //TODO: Check if this line is needed
        //Get country name from country alpha3 code of vix
        let phoneCountry = User.shared.countryName
        let vixGeneratedCountryAlpha3Code = getVerificationResultResponse.return_?.registrationDetails?.currentResidentialAddress?.country ?? ""
        let countriesAndAlpha3Codes = getCountryToCodeDict()
        let indexOfCountryInOurList = Array(countriesAndAlpha3Codes.values).index(of: vixGeneratedCountryAlpha3Code)
        if indexOfCountryInOurList != nil {
            User.shared.countryName = Array(countriesAndAlpha3Codes.keys)[indexOfCountryInOurList ?? 0]
        } else {
            User.shared.countryName = vixGeneratedCountryAlpha3Code
        }
        
        let dict = User.shared.getCurrentAddressDict()
        User.shared.addresses = [dict]
        
        User.shared.address = ""
        User.shared.city = ""
        User.shared.postcode = ""
        
        User.shared.countryName = phoneCountry
        
        User.shared.save()
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
    
    func addSpacesToCard(text: String) -> String {
        var noSpacesText = text.replacingOccurrences(of: " ", with: "")
        var newText = ""
        var count = 1
        
        var allCharacters = noSpacesText.flatMap({ (character) -> String? in
            return "\(character) "
        })
        for char in allCharacters {
            if count % 4 == 1 && count != 1 {
                newText = "\(newText) \(char.components(separatedBy: " ").first!)"
            } else {
                newText = "\(newText)\(char.components(separatedBy: " ").first!)"
            }
            count = count + 1
        }
        return newText
    }
    
    //MARK:- Coredata
    
    func getPaymentObjectFor(payment: Home.PaymentDetail.Response, context: NSManagedObjectContext = ApplicationDelegate.mainContext) -> Payment {
        let paymentCoredataObject = Payment(context: context)
        
        paymentCoredataObject.paymentID = payment.paymentId ?? ""
        paymentCoredataObject.status = payment.status ?? ""
        paymentCoredataObject.merchantName = payment.merchantName ?? ""
        paymentCoredataObject.created = Int64(payment.created ?? 0)
        paymentCoredataObject.merchantLogoID = payment.merchantLogoId ?? ""
        paymentCoredataObject.customerItems = getCustomerItemsObjectFor(customerItems: payment.customerItems, withMerchantID: payment.merchantId, context: context)
        paymentCoredataObject.currency = payment.currency ?? ""
        paymentCoredataObject.amount = Int64(payment.amount ?? 0)
        paymentCoredataObject.merchantID = payment.merchantId ?? ""
        paymentCoredataObject.vat = Int64(payment.vat ?? 0)
        
        return paymentCoredataObject
    }
    
    func getCampaignObjectFor(campaign: Home.GetCampaigns.Response, context: NSManagedObjectContext = ApplicationDelegate.mainContext) -> Campaign {
        let campaignCoredataObject = Campaign(context: context)
        
        campaignCoredataObject.active = campaign.active ?? false
        campaignCoredataObject.name = campaign.name ?? ""
        campaignCoredataObject.campaignID = campaign.campaignId ?? ""
        campaignCoredataObject.merchantID = campaign.merchantId
        campaignCoredataObject.items = getCustomerItemsObjectFor(customerItems: campaign.items, withMerchantID: campaign.merchantId, context: context)
        
        return campaignCoredataObject
    }
    
    func getCustomerItemsObjectFor(customerItems: [Home.PaymentDetail.CustomerItems]?, withMerchantID: String?, context: NSManagedObjectContext = ApplicationDelegate.mainContext) -> NSSet? {
        guard let customerItems = customerItems else {
            return nil
        }
        var customerCoredataObjects = [Item]()
        
        for customerItem in customerItems {
            let customerCoredataObject = Item(context: context)
            customerCoredataObject.descriptionValue = customerItem.descriptionValue ?? ""
            customerCoredataObject.name = customerItem.name ?? ""
            customerCoredataObject.amount = Int64(customerItem.amount ?? 0)
            customerCoredataObject.currency = customerItem.currency ?? ""
            customerCoredataObject.count = Int64(customerItem.count ?? 0)
            customerCoredataObject.vat = Int64(customerItem.vat ?? 0)
            customerCoredataObject.imageID = customerItem.imageID ?? ""
            
            customerCoredataObject.combinedItem = getCombinedItemObjectFor(item: customerCoredataObject, withMerchantID: withMerchantID, context: context)
            
            customerCoredataObjects.append(customerCoredataObject)
        }
        
        return NSSet(array: customerCoredataObjects)
    }
    
    func getCombinedItemObjectFor(item: Item, withMerchantID: String?, context: NSManagedObjectContext = ApplicationDelegate.mainContext) -> CombinedItem? {
        
        var existingCombinedItems: [CombinedItem]? = nil
        do {
            let fetchRequest = NSFetchRequest<CombinedItem>(entityName: "CombinedItem")
            fetchRequest.predicate = NSPredicate(format: "merchantID == %@ AND name == %@", withMerchantID ?? "-", item.name ?? "-")
            existingCombinedItems = try context.fetch(fetchRequest)
        } catch {
            print("Fetching combined items Failed")
        }
        if let existingCombinedItem = existingCombinedItems?.first {
            if existingCombinedItem.items == nil {
                existingCombinedItem.items = NSSet(object: item)
            } else {
                existingCombinedItem.items = existingCombinedItem.items!.adding(item) as NSSet
            }
            existingCombinedItem.count = existingCombinedItem.count + item.count
            return existingCombinedItem
        }
        
        //Create new combined item
        
        let combinedItemCoredataObject = CombinedItem(context: context)
        combinedItemCoredataObject.descriptionValue = item.descriptionValue
        combinedItemCoredataObject.name = item.name
        combinedItemCoredataObject.amount = item.amount
        combinedItemCoredataObject.currency = item.currency
        combinedItemCoredataObject.count = item.count
        combinedItemCoredataObject.vat = item.vat
        combinedItemCoredataObject.imageID = item.imageID
        combinedItemCoredataObject.merchantID = withMerchantID
        
        if combinedItemCoredataObject.items == nil {
            combinedItemCoredataObject.items = NSSet(object: item)
        } else {
            combinedItemCoredataObject.items = combinedItemCoredataObject.items!.adding(item) as NSSet
        }
        return combinedItemCoredataObject
    }
    
    func fetchRecordsIn(context: NSManagedObjectContext) -> [NSManagedObject] {
        var paymentAndCampaigns = [NSManagedObject]()
        do {
            paymentAndCampaigns = try context.fetch(Payment.fetchRequest())
        } catch {
            print("Fetching payments Failed")
        }
        
        do {
            let campaigns: [NSManagedObject] = try context.fetch(Campaign.fetchRequest())
            paymentAndCampaigns.append(contentsOf: campaigns)
        } catch {
            print("Fetching campaigns Failed")
        }
        
        return paymentAndCampaigns
    }
    
    func deleteDanglingDataIn(context: NSManagedObjectContext) {
        deleteDanglingCombinedItemsIn(context: context)
        deleteDanglingItemsIn(context: context)
        
        let paymentAndCampaigns = fetchRecordsIn(context: context)
        var paymentAndCampaignsWithItems = [NSManagedObject]()
        
        for paymentAndCampaign in paymentAndCampaigns {
            if let payment = paymentAndCampaign as? Payment {
                if payment.customerItems == nil || payment.customerItems?.count == 0 {
                    context.delete(payment)
                    continue
                } else {
                    paymentAndCampaignsWithItems.append(payment)
                }
            } else if let campaign = paymentAndCampaign as? Campaign {
                if campaign.items == nil || campaign.items?.count == 0 {
                    context.delete(campaign)
                    continue
                } else {
                    paymentAndCampaignsWithItems.append(campaign)
                }
            }
        }
        
        save(context: context)
    }
    
    func deleteDanglingItemsIn(context: NSManagedObjectContext) {
        
        var items = [Item]()
        do {
            items = try context.fetch(Item.fetchRequest())
        } catch {
            print("Fetching items Failed")
        }
        
        for item in items {
            if ((item.payment == nil) && (item.campaign == nil)) ||
                item.combinedItem == nil {
                context.delete(item)
            }
        }
    }
    
    func deleteDanglingCombinedItemsIn(context: NSManagedObjectContext) {
        
        let combinedItems = getCombinedItemsIn(context: context)
        
        var filteredCombinedItems = [CombinedItem]()
        for combinedItem in combinedItems {
            if combinedItem.items == nil || combinedItem.items!.count == 0 {
                context.delete(combinedItem)
            } else {
                filteredCombinedItems.append(combinedItem)
            }
        }
    }
    
    func getCombinedItemsIn(context: NSManagedObjectContext) -> [CombinedItem] {
        var combinedItems = [CombinedItem]()
        do {
            combinedItems = try context.fetch(CombinedItem.fetchRequest())
        } catch {
            print("Fetching combined items Failed")
        }
        return combinedItems
    }
    
    func save(context: NSManagedObjectContext) {
        if context == ApplicationDelegate.mainContext {
            ApplicationDelegate.saveContext()
        } else {
            do {
                if context.hasChanges {
                    try context.save()
                }
            } catch {
                print("Failed to save general context")
            }
        }
    }
    
    func deleteCombinedItemsWith(merchantID: String?) {
        var combinedItems: [CombinedItem]? = nil
        do {
            let fetchRequest = NSFetchRequest<CombinedItem>(entityName: "CombinedItem")
            fetchRequest.predicate = NSPredicate(format: "merchantID == %@", merchantID ?? "-")
            combinedItems = try ApplicationDelegate.mainContext.fetch(fetchRequest)
        } catch {
            print("Fetching combined items Failed")
        }
        
        if let combinedItems = combinedItems {
            for combinedItem in combinedItems {
                ApplicationDelegate.mainContext.delete(combinedItem)
            }
        }
        
        ApplicationDelegate.saveContext()
        
        //Just to make this function delete all dangling data
        _ = fetchRecordsIn(context: ApplicationDelegate.mainContext)
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
        let dict = getCountryToCodeDict()
        return dict[country]
    }
    
    func getCountryToCodeDict() -> Dictionary<String,String> {
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
                    "United Kingdom": "GB",
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
        
        return dict
    }
}
