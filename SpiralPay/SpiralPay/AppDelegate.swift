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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isNetworkAvailable: Bool = true
    let reachability = Reachability()!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if Utils.didCompleteOnboarding {
            showWelcomeScreen()
        }
        
        if !UserDefaults.standard.bool(forKey: Constants.kHadAppRunBeforeAtleastOnce) {
            User.resetSavedValues()
            UserDefaults.standard.set(true, forKey: Constants.kHadAppRunBeforeAtleastOnce)
            UserDefaults.standard.synchronize()
        }
        
        User.shared.restore()
        
        Fabric.with([Crashlytics.self])
        
        setupNetworkMonitoring()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        if Utils.canShowLoginScreen {
            showLoginScreen()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
                self.isNetworkAvailable = true
            }
        }
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                print("Not reachable")
                
                self.isNetworkAvailable = false
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: Notification.Name.reachabilityChanged,object: reachability)
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.connection != .none {
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
            self.isNetworkAvailable = true
            
        } else {
            print("Network not reachable")
            self.isNetworkAvailable = false
            
        }
    }
    
    func showLoginScreen() {
        let pinVC = PinViewController.create()
        pinVC.pinEntry = .Login
        let viewC = UIApplication.shared.keyWindow?.rootViewController
        if viewC != nil {
            viewC?.present(pinVC, animated: true, completion: nil)
        }
    }
    
    func showWelcomeScreen() {
        let welcomeScreen = WelcomeViewController.create()
        let navVC = UINavigationController(rootViewController: welcomeScreen)
        navVC.navigationBar.isHidden = true
        UIApplication.shared.windows.last!.rootViewController = navVC
    }

}

