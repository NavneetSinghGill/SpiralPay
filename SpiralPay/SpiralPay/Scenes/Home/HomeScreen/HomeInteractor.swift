//
//  HomeInteractor.swift
//  SpiralPay
//
//  Created by Zoeb on 22/02/18.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol HomeBusinessLogic
{
    func getPaymentHistory(request: Home.PaymentHistory.Request)
}

protocol HomeDataStore
{
    //var name: String { get set }
}

class HomeInteractor: HomeBusinessLogic, HomeDataStore
{
    var presenter: HomePresentationLogic?
    var worker: HomeWorker?
    
    // MARK: Get Payment History
    
    func getPaymentHistory(request: Home.PaymentHistory.Request)
    {
        worker = HomeWorker()
        worker?.getPaymentHistoryWith(request: request, successCompletionHandler: { (response) in
            self.presenter?.getPaymentHistorySuccessWith(response: response)
        }, failureCompletionHandler: { (response) in
            self.presenter?.getPaymentHistoryFailureWith(response: response)
        })
        
    }
}