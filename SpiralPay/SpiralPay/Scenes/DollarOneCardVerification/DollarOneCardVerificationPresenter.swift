//
//  DollarOneCardVerificationPresenter.swift
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

protocol DollarOneCardVerificationPresentationLogic
{
    func dollarOneCardVerificationAPIsuccess(response: DollarOneCardVerification.DollarOneCardVerification.Response)
    func dollarOneCardVerificationAPIfailure(response: DollarOneCardVerification.DollarOneCardVerification.Response)
}

class DollarOneCardVerificationPresenter: DollarOneCardVerificationPresentationLogic
{
  weak var viewController: DollarOneCardVerificationDisplayLogic?
  
  // MARK: Do something
    
    func dollarOneCardVerificationAPIsuccess(response: DollarOneCardVerification.DollarOneCardVerification.Response) {
        viewController?.dollarOneCardVerificationAPIsuccess(response: response)
    }
    
    func dollarOneCardVerificationAPIfailure(response: DollarOneCardVerification.DollarOneCardVerification.Response) {
        viewController?.dollarOneCardVerificationAPIfailure(response: response)
    }
    
}
