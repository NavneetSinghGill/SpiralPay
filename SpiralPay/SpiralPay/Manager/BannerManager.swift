//
//  BannerManager.swift
// WordPower
//
//  Created by Zoeb on 17/10/17.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//

import UIKit
//import NotificationBannerSwift

class BannerManager: NSObject {
    
//    static func showSuccessBanner(title:String = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String, subtitle:String){
//        let banner = NotificationBanner(title: title, subtitle: subtitle, style: .success)
//        banner.show()
//    }
//    
//    static func showFailureBanner(title:String = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String, subtitle:String){
//        let banner = NotificationBanner(title: title, subtitle: subtitle, style: .danger)
//        banner.show()
//    }


    static func showFailureBanner(title:String = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String, subtitle:String){
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(action)
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            topController.present(alert, animated: true, completion: nil)
        }
    }
    
}
