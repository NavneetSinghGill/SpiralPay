//
//  RequestManager.swift
//  SaitamaCycles
//
//  Created by Zoeb on 05/06/17.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class RequestManager: NSObject {
    
    //MARK: JWTToken API
    
//    func fetchJWTToken(request:BaseRequest, completion:@escaping CompletionHandler){
//        if ApplicationDelegate.isNetworkAvailable{
//            RealAPI().postObject(request:request, genericResponse: Token.JWTToken.Response.self, completion:completion)
//        }
//        else{
//            completion(false, Constants.kNoNetworkMessage)
//            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
//        }
//    }
//    
//    func fetchRefreshToken(request:BaseRequest, completion:@escaping CompletionHandler){
//        if ApplicationDelegate.isNetworkAvailable{
//            RealAPI().getObject(request:request, genericResponse: Token.JWTToken.Response.self, completion:completion)
//        }
//        else{
//            completion(false, Constants.kNoNetworkMessage)
//            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
//        }
//    }
    
    func postCustomerRegistration(request:BaseRequest, completion:@escaping CompletionHandler){
        if ApplicationDelegate.isNetworkAvailable{
            RealAPI().postObject(request:request, genericResponse: Pin.CustomerRegistration.Response.self, completion:completion)
        }
        else{
            completion(false, Constants.kNoNetworkMessage)
            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
    
    func sendSmsForPhoneVerification(request:BaseRequest, completion:@escaping CompletionHandler){
        if ApplicationDelegate.isNetworkAvailable{
            RealAPI().postObject(request:request, genericResponse: PhoneVerification.SmsPhoneVerification.Response.self, completion:completion)
        }
        else{
            completion(false, Constants.kNoNetworkMessage)
            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
    
    func updateMobileAndEmail(request:BaseRequest, completion:@escaping CompletionHandler){
        if ApplicationDelegate.isNetworkAvailable{
            RealAPI().putObject(request:request, genericResponse: PhoneVerification.UpdateMobileAndEmail.Response.self, completion:completion)
        }
        else{
            completion(false, Constants.kNoNetworkMessage)
            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
    
    func postLogin(request:BaseRequest, completion:@escaping CompletionHandler){
        if ApplicationDelegate.isNetworkAvailable{
            RealAPI().postObject(request:request, genericResponse: Pin.Login.Response.self, completion:completion)
        }
        else{
            let response = Pin.Login.Response(errorMessage: Constants.kNoNetworkMessage)
            completion(false, response)
            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
    
    func getPaymentHistory(request:BaseRequest, completion:@escaping CompletionHandler){
        if ApplicationDelegate.isNetworkAvailable{
            RealAPI().getObject(request:request, genericResponse: Home.PaymentHistory.Response.self, completion:completion)
        }
        else{
            completion(false, Constants.kNoNetworkMessage)
            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
    
    func getPaymentDetail(request:BaseRequest, completion:@escaping CompletionHandler){
        if ApplicationDelegate.isNetworkAvailable{
            RealAPI().getObject(request:request, genericResponse: Home.PaymentDetail.Response.self, completion:completion)
        }
        else{
            completion(false, Constants.kNoNetworkMessage)
            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
    
    func processPayment(request:BaseRequest, completion:@escaping CompletionHandler){
        if ApplicationDelegate.isNetworkAvailable{
            RealAPI().postObject(request:request, genericResponse: ProductDetails.ProcessPayment.Response.self, completion:completion)
        }
        else{
            completion(false, Constants.kNoNetworkMessage)
            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
    
    func createPayment(request:BaseRequest, completion:@escaping CompletionHandler){
        if ApplicationDelegate.isNetworkAvailable{
            RealAPI().postObject(request:request, genericResponse: ProductDetails.CreatePayment.Response.self, completion:completion)
        }
        else{
            completion(false, Constants.kNoNetworkMessage)
            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
    
    func getCardToken(request:BaseRequest, completion:@escaping CompletionHandler){
        if ApplicationDelegate.isNetworkAvailable{
            RealAPI().postObject(request:request, genericResponse: ProductDetails.CardToken.Response.self, completion:completion)
        }
        else{
            completion(false, Constants.kNoNetworkMessage)
            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
    
    func getCampaigns(request:BaseRequest, completion:@escaping CompletionHandler){
        if ApplicationDelegate.isNetworkAvailable{
            RealAPI().getObject(request:request, genericResponse: Home.GetCampaigns.Response.self, completion:completion)
        }
        else{
            completion(false, Constants.kNoNetworkMessage)
            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
    
    func postAddItemToBasket(request:BaseRequest, completion:@escaping CompletionHandler){
        if ApplicationDelegate.isNetworkAvailable{
            RealAPI().postObject(request:request, genericResponse: ProductDetails.ItemAddedToBasket.Response.self, completion:completion)
        }
        else{
            completion(false, Constants.kNoNetworkMessage)
            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
    
    func changePin(request:BaseRequest, completion:@escaping CompletionHandler){
        if ApplicationDelegate.isNetworkAvailable{
            RealAPI().postObject(request:request, genericResponse: ChangePin.ChangePin.Response.self, completion:completion)
        }
        else{
            completion(false, Constants.kNoNetworkMessage)
            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
    
    func lockAccount(request:BaseRequest, completion:@escaping CompletionHandler){
        if ApplicationDelegate.isNetworkAvailable{
            RealAPI().postObject(request:request, genericResponse: LockAccount.LockAccount.Response.self, completion:completion)
        }
        else{
            completion(false, Constants.kNoNetworkMessage)
            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
    
    
}
