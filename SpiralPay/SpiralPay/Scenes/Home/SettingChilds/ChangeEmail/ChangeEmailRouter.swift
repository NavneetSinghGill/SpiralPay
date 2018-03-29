//
//  ChangeEmailRouter.swift
//  SpiralPay
//
//  Created by Zoeb on 03/04/18.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol ChangeEmailRoutingLogic
{
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol ChangeEmailDataPassing
{
    var dataStore: ChangeEmailDataStore? { get }
}

class ChangeEmailRouter: NSObject, ChangeEmailRoutingLogic, ChangeEmailDataPassing
{
    weak var viewController: ChangeEmailViewController?
    var dataStore: ChangeEmailDataStore?
    
}
