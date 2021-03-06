//
//  ConfirmDetailsRouter.swift
//  SpiralPay
//
//  Created by Zoeb on 09/02/18.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol ConfirmDetailsRoutingLogic
{
    func routeToShowDateAndTimeScreen()
    func routeToWelcomeScreen()
}

protocol ConfirmDetailsDataPassing
{
    var dataStore: ConfirmDetailsDataStore? { get }
}

class ConfirmDetailsRouter: NSObject, ConfirmDetailsRoutingLogic, ConfirmDetailsDataPassing
{
    weak var viewController: ConfirmDetailsViewController?
    var dataStore: ConfirmDetailsDataStore?
    
    // MARK: Routing
    
    func routeToShowDateAndTimeScreen() {
        let dateAndTimeVC: DateAndTimeViewController = DateAndTimeViewController.create()
        
        dateAndTimeVC.modalTransitionStyle = .crossDissolve
        dateAndTimeVC.modalPresentationStyle = .overCurrentContext
        dateAndTimeVC.dateAndTimeDelegate = viewController
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = viewController?.dateFormatString
        dateAndTimeVC.initialDate = dateFormatter.date(from: viewController?.birthdayTextField.text ?? "")
        
        viewController?.navigationController?.present(dateAndTimeVC,
                                                      animated: true,
                                                      completion: nil)
    }
    
    func routeToWelcomeScreen() {
        let welcomeScreen: WelcomeViewController = WelcomeViewController.create()
        viewController?.navigationController?.setViewControllers([welcomeScreen], animated: true)
    }
    
}
