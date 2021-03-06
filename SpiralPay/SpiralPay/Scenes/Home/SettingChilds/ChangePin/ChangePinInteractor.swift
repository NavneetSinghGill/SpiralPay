//
//  ChangePinInteractor.swift
//  SpiralPay
//
//  Created by Zoeb on 02/04/18.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ChangePinBusinessLogic
{
    func changePin(request: ChangePin.ChangePin.Request)
}

protocol ChangePinDataStore
{
    //var name: String { get set }
}

class ChangePinInteractor: ChangePinBusinessLogic, ChangePinDataStore
{
    var presenter: ChangePinPresentationLogic?
    var worker: ChangePinWorker?
    
    func changePin(request: ChangePin.ChangePin.Request) {
        worker = ChangePinWorker()
        worker?.postCustomerRegistrationWith(request: request, successCompletionHandler: { (response) in
            self.presenter?.changePinSuccess(response: response)
        }, failureCompletionHandler: { (response) in
            self.presenter?.changePinFailed(response: response)
        })
    }
    
}
