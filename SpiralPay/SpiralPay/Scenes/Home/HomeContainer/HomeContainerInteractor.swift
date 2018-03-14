//
//  HomeContainerInteractor.swift
//  SpiralPay
//
//  Created by Zoeb on 09/03/18.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol HomeContainerBusinessLogic
{
    func getPaymentDetails(request: Home.PaymentDetail.Request)
    func getCampaign(request: Home.GetCampaigns.Request)
}

protocol HomeContainerDataStore
{
  //var name: String { get set }
}

class HomeContainerInteractor: HomeContainerBusinessLogic, HomeContainerDataStore
{
  var presenter: HomeContainerPresentationLogic?
  var worker: HomeContainerWorker?
    
    // MARK: Get Payment Detail
    
    func getPaymentDetails(request: Home.PaymentDetail.Request)
    {
        worker = HomeContainerWorker()
        worker?.getPaymentDetailWith(request: request, successCompletionHandler: { (response) in
            self.presenter?.getPaymentDetailSuccessWith(response: response)
        }, failureCompletionHandler: { (response) in
            self.presenter?.getPaymentDetailFailureWith(response: response)
        })
        
    }
    
    func getCampaign(request: Home.GetCampaigns.Request) {
        worker = HomeContainerWorker()
        worker?.getCampaignsWith(request: request, successCompletionHandler: { (response) in
            self.presenter?.getCampaignsSuccessWith(response: response)
        }, failureCompletionHandler: { (response) in
            self.presenter?.getCampaignsFailureWith(response: response)
        })
    }
}
