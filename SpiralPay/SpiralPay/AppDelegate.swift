//
//  AppDelegate.swift
//  SpiralPay
//
//  Created by Zoeb on 24/01/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit
import Reachability
import Fabric
import Crashlytics
import CoreData
import GIDSDK
import SwiftKeychainWrapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isNetworkAvailable: Bool = true
    let reachability = Reachability()!
    
    var didOpenFromDidFinishLaunchingWithOptions: Bool = false
    var didOpenFromDidEnterForeground: Bool = false
    var universalLinkURLString: String?
    var universalLinkBlock : ((_ url: String?) -> Void)?
    
    var orientationLock = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Remove all previous saved data
        if !UserDefaults.standard.bool(forKey: Constants.kHadAppRunBeforeAtleastOnce) {
            User.shared.reset()
            Card.shared.reset()
            VixVerify.shared.reset()
            _ = KeychainWrapper.standard.removeAllKeys()
            UserDefaults.standard.set(true, forKey: Constants.kHadAppRunBeforeAtleastOnce)
            UserDefaults.standard.set(UIDevice.current.identifierForVendor?.uuidString, forKey: Constants.deviceIdentifier)
            UserDefaults.standard.synchronize()
        }
        
        User.shared.restore()
        Card.shared.restore()
        VixVerify.shared.restore()
        
        if User.shared.address == nil || User.shared.address!.count == 0 {
            //address is empty means that everything is already in array of dictionary
        } else if User.shared.addresses == nil || User.shared.addresses!.count == 0 {
            //Convert single address to array
            let dict = User.shared.getCurrentAddressDict()
            User.shared.addresses = [dict]
            User.shared.address = ""
            User.shared.city = ""
            User.shared.postcode = ""
            SecurityStorageWorker.shared.setArrayUserDefaults(User.shared.addresses!, key: "addresses")
            User.shared.save()
        }
        
        if Card.shared.number == nil || Card.shared.number!.count == 0 {
            //number is empty means that everything is already in array of dictionary
        } else if Card.shared.cards == nil || Card.shared.cards!.count == 0 {
            //Convert single address to array
            let dict = Card.shared.getCurrentCardDict()
            Card.shared.cards = [dict]
            Card.shared.number = ""
            Card.shared.expiry = ""
            Card.shared.cvv = ""
            Card.shared.save()
        }
        
        Utils.print(object: ("Coredata url: \(persistentContainer.persistentStoreCoordinator.persistentStores.first?.url)\n"))
        
        setupNetworkMonitoring()
        
        Fabric.with([Crashlytics.self])
        
        didOpenFromDidFinishLaunchingWithOptions = true
        showLoginScreenIfShould()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        Utils.shared.stopGetVerificationResultTimer()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        didOpenFromDidEnterForeground = true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        if didOpenFromDidFinishLaunchingWithOptions {
            didOpenFromDidFinishLaunchingWithOptions = false
        } else if didOpenFromDidEnterForeground {
            didOpenFromDidEnterForeground = false
            showLoginScreenIfShould()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        // 1
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let url = userActivity.webpageURL,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                return false
        }
        Utils.print(object: ("..... \(url)"))
        
//        if let value = components.queryItems?.first?.value {
//            universalLinkURLString = value
//        } else {
//            universalLinkURLString = ""
//        }
        universalLinkURLString = components.path
        universalLinkBlock = { (url) in
            //This is typically called when login is successful
            if url != nil, url!.count != 0, User.shared.savedState == .CardAdded, let base = ApplicationDelegate.getWindow().rootViewController as? UINavigationController {
                
                DispatchQueue.main.async {
                    if let homeContainer = base.viewControllers.first as? HomeContainerViewController {
                        if base.viewControllers.count != 1 {
                            base.popToRootViewController(animated: true)
                        }
                        homeContainer.getDetailsWith(code: url ?? "")
                    } else {
                        ApplicationDelegate.showHomeTabBarScreen()
                    }
                    self.universalLinkURLString = nil
                }
            } else {
                self.universalLinkURLString = nil
            }
        }
        
        return true
    }

    //MARK: - Public Methods
    
    public func isNetworkReachable() -> Bool {
        return self.isNetworkAvailable
    }
    
    func setupNetworkMonitoring() {
        
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                if reachability.connection == .wifi  {
                    Utils.print(object: ("Reachable via WiFi"))
                } else {
                    Utils.print(object: ("Reachable via Cellular"))
                }
                self.isNetworkAvailable = true
            }
        }
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                Utils.print(object: ("Not reachable"))
                
                self.isNetworkAvailable = false
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: Notification.Name.reachabilityChanged,object: reachability)
        
        do {
            try reachability.startNotifier()
        } catch {
            Utils.print(object: ("Unable to start notifier"))
        }
        
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.connection != .none {
            if reachability.connection == .wifi {
                Utils.print(object: ("Reachable via WiFi"))
            } else {
                Utils.print(object: ("Reachable via Cellular"))
            }
            self.isNetworkAvailable = true
            
        } else {
            Utils.print(object: ("Network not reachable"))
            self.isNetworkAvailable = false
            
        }
    }
    
    func openIntendedScreen() {
        switch User.shared.savedState {
        case .None:
            break
        case .PinCreated:
            showPhoneVerificationScreen()
        case .PhoneVerified:
            showConfirmDetailsScreen()
        case .CustomerDetailsEntered:
            showWelcomeOrVixVerifyStatusScreen()
        case .CardAdded:
            showHomeTabBarScreen()
        case .CardNotAdded:
            showHomeTabBarScreen()
        }
    }
    
    func showLoginScreenIfShould() {
        if User.shared.savedState == .None { //every state is accepted except None
            return
        }
        Utils.shared.refreshTemporaryLockState()
        
        let pinVC = PinViewController.create()
        pinVC.pinEntry = .Login
        let viewC = UIApplication.shared.keyWindow?.rootViewController
        let presentedVC = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController
        
        //Update if Login screen already opened
        var loginViewController: PinViewController?
        if let loginVC = (viewC as? UINavigationController)?.viewControllers.first as? PinViewController {
            if loginVC.pinEntry == .Login {
                loginViewController = loginVC
            }
        } else if let loginVC = (presentedVC as? UINavigationController)?.viewControllers.first as? PinViewController {
            if loginVC.pinEntry == .Login {
                loginViewController = loginVC
            }
        }
        
        if let loginVC = loginViewController {
            loginVC.refreshLoginState()
            return
        }
        
        //If not opened then open login screen
        let navC = UINavigationController(rootViewController: pinVC)
        navC.setNavigationBarHidden(true, animated: false)
        
        if UserDefaults.standard.bool(forKey: Constants.kIsLockedTemporarily) {
            //Add lock screen
            let tempLockScreen = TemporaryLockTimerViewController.create()
            navC.setViewControllers(navC.viewControllers + [tempLockScreen], animated: false)
        }
        
        if presentedVC != nil {
            presentedVC?.present(navC, animated: false, completion: nil)
        } else if viewC != nil {
            viewC?.present(navC, animated: false, completion: nil)
        } else {
            UIApplication.shared.windows.first?.rootViewController = navC
        }
    }
    
    func showPhoneVerificationScreen() {
        let phoneAndEmailScreen = PhoneAndEmailViewController.create()
        
        let phoneVerificationScreen = PhoneVerificationViewController.create()
        
        let navVC = UINavigationController(rootViewController: phoneAndEmailScreen)
        navVC.setViewControllers([phoneAndEmailScreen, phoneVerificationScreen], animated: false)
        self.getWindow().rootViewController = navVC
    }
    
    func showConfirmDetailsScreen() {
        let phoneVerificationSuccessScreen = PhoneVerificationViewController.create()
        phoneVerificationSuccessScreen.screenStatus = .Success
        
        let navVC = UINavigationController(rootViewController: phoneVerificationSuccessScreen)
        self.getWindow().rootViewController = navVC
    }
     
    func showWelcomeOrVixVerifyStatusScreen() {
        var vc: UIViewController?
        let status = VixVerify.shared.verificationStatus
        if status == .verified || status == .verifiedAdmin {
            let welcomeScreen: WelcomeViewController = WelcomeViewController.create()
            welcomeScreen.verificationStatus = status
            welcomeScreen.appFlowType = .Onboard
            vc = welcomeScreen
        } else {
            let vixVerifyStatusScreen: VixVerifyStatusViewController = VixVerifyStatusViewController.create()
            vixVerifyStatusScreen.verificationStatus = status
            vixVerifyStatusScreen.appFlowType = .Onboard
            vc = vixVerifyStatusScreen
        }
        let navVC = UINavigationController(rootViewController: vc!)
        navVC.setNavigationBarHidden(true, animated: false)
        self.getWindow().rootViewController = navVC
    }
    
    func showHomeTabBarScreen() {
        Utils.shared.showHomeTabBarScreen()
        
        self.executeUniversalLinkingBlock()
    }
    
    func getWindow() -> UIWindow {
        if UIApplication.shared.keyWindow == nil {
            return UIApplication.shared.windows.first!
        } else {
            return UIApplication.shared.keyWindow!
        }
    }
    
    func executeUniversalLinkingBlock() {
        if let block = ApplicationDelegate.universalLinkBlock {
            block(ApplicationDelegate.universalLinkURLString)
        }
    }
    
    // MARK: - Core Data stack
    var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "SpiralPay")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    var mainContext: NSManagedObjectContext
    {
        get {
            return ApplicationDelegate.persistentContainer.viewContext
        }
    }

}

