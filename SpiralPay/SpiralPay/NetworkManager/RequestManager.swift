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
//            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
    
    func sendSmsForPhoneVerification(request:BaseRequest, completion:@escaping CompletionHandler){
        if ApplicationDelegate.isNetworkAvailable{
            RealAPI().postObject(request:request, genericResponse: PhoneVerification.SmsPhoneVerification.Response.self, completion:completion)
        }
        else{
            completion(false, Constants.kNoNetworkMessage)
//            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
    
    func postLogin(request:BaseRequest, completion:@escaping CompletionHandler){
        if ApplicationDelegate.isNetworkAvailable{
            RealAPI().postObject(request:request, genericResponse: Pin.Login.Response.self, completion:completion)
        }
        else{
            completion(false, Constants.kNoNetworkMessage)
//            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
    
    func getPaymentHistory(request:BaseRequest, completion:@escaping CompletionHandler){
        if ApplicationDelegate.isNetworkAvailable{
            RealAPI().getObject(request:request, genericResponse: Home.PaymentHistory.Response.self, completion:completion)
        }
        else{
            completion(false, Constants.kNoNetworkMessage)
            //            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
    
    func getPaymentDetail(request:BaseRequest, completion:@escaping CompletionHandler){
        if ApplicationDelegate.isNetworkAvailable{
            RealAPI().getObject(request:request, genericResponse: Home.PaymentDetail.Response.self, completion:completion)
        }
        else{
            completion(false, Constants.kNoNetworkMessage)
            //            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
    
    
}
