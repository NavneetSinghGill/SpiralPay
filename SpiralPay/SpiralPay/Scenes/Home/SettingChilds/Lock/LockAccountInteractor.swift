//
//  LockAccountInteractor.swift
//  SpiralPay
//
//  Created by Zoeb on 06/04/18.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LockAccountBusinessLogic
{
    func lockAccount(request: LockAccount.LockAccount.Request)
}

protocol LockAccountDataStore
{

}

class LockAccountInteractor: LockAccountBusinessLogic, LockAccountDataStore
{
    var presenter: LockAccountPresentationLogic?
    var worker: LockAccountWorker?
    
    func lockAccount(request: LockAccount.LockAccount.Request) {
        worker = LockAccountWorker()
        worker?.postLockAccountWith(request: request, successCompletionHandler: { (response) in
            self.presenter?.lockAccountSuccess(response: response)
        }, failureCompletionHandler: { (response) in
            self.presenter?.lockAccountFailed(response: response)
        })
    }
    
}