//
//  PhoneVerificationPresenter.swift
//  SpiralPay
//
//  Created by Zoeb on 07/02/18.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol PhoneVerificationPresentationLogic
{
    func sendSmsForPhoneVerificationAPIsuccess(response: PhoneVerification.SmsPhoneVerification.Response)
    func sendSmsForPhoneVerificationAPIfailure(response: PhoneVerification.SmsPhoneVerification.Response)
    
    func updateMobileAndEmailAPIsuccess(response: PhoneVerification.UpdateMobileAndEmail.Response)
    func updateMobileAndEmailAPIfailure(response: PhoneVerification.UpdateMobileAndEmail.Response)
    
    func updateCustomerVerificationDataAPIsuccess(response: PhoneVerification.UpdateCustomerVerificationData.Response)
    func updateCustomerVerificationDataAPIfailure(response: PhoneVerification.UpdateCustomerVerificationData.Response)
    
}

class PhoneVerificationPresenter: PhoneVerificationPresentationLogic
{
    weak var viewController: PhoneVerificationDisplayLogic?
    
    func sendSmsForPhoneVerificationAPIsuccess(response: PhoneVerification.SmsPhoneVerification.Response) {
        viewController?.sendSmsForPhoneVerificationAPIsuccess(response: response)
    }
    
    func sendSmsForPhoneVerificationAPIfailure(response: PhoneVerification.SmsPhoneVerification.Response) {
        viewController?.sendSmsForPhoneVerificationAPIfailure(response: response)
    }
    
    
    
    func updateMobileAndEmailAPIsuccess(response: PhoneVerification.UpdateMobileAndEmail.Response) {
        viewController?.updateMobileAndEmailSuccess(response: response)
    }
    
    func updateMobileAndEmailAPIfailure(response: PhoneVerification.UpdateMobileAndEmail.Response) {
        viewController?.updateMobileAndEmailFailure(response: response)
    }
    
    
    
    func updateCustomerVerificationDataAPIsuccess(response: PhoneVerification.UpdateCustomerVerificationData.Response) {
        
    }
    
    func updateCustomerVerificationDataAPIfailure(response: PhoneVerification.UpdateCustomerVerificationData.Response) {
        
    }
    
}
