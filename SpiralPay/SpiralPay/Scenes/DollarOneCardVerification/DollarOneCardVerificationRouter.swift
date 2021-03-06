//
//  DollarOneCardVerificationRouter.swift
//  SpiralPay
//
//  Created by Zoeb on 04/06/18.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol DollarOneCardVerificationRoutingLogic
{

}

protocol DollarOneCardVerificationDataPassing
{
  var dataStore: DollarOneCardVerificationDataStore? { get }
}

class DollarOneCardVerificationRouter: NSObject, DollarOneCardVerificationRoutingLogic, DollarOneCardVerificationDataPassing
{
  weak var viewController: DollarOneCardVerificationViewController?
  var dataStore: DollarOneCardVerificationDataStore?
  
  // MARK: Routing
}
