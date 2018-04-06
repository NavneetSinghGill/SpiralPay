//
//  ChangeEmailPresenter.swift
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

protocol ChangeEmailPresentationLogic
{
    func updateMobileAndEmailAPIsuccess(response: PhoneVerification.UpdateMobileAndEmail.Response)
    func updateMobileAndEmailAPIfailure(response: PhoneVerification.UpdateMobileAndEmail.Response)
}

class ChangeEmailPresenter: ChangeEmailPresentationLogic
{
    weak var viewController: ChangeEmailDisplayLogic?
    
    func updateMobileAndEmailAPIsuccess(response: PhoneVerification.UpdateMobileAndEmail.Response) {
        viewController?.updateMobileAndEmailSuccess(response: response)
    }
    
    func updateMobileAndEmailAPIfailure(response: PhoneVerification.UpdateMobileAndEmail.Response) {
        viewController?.updateMobileAndEmailFailure(response: response)
    }
    
}