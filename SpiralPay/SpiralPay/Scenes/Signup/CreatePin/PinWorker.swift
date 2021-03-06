//
//  PinWorker.swift
//  SpiralPay
//
//  Created by Zoeb on 02/02/18.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

typealias customerRegistrationResponseHandler = (_ response:Pin.CustomerRegistration.Response) ->()
typealias loginResponseHandler = (_ response:Pin.Login.Response) ->()

class PinWorker
{
    func postCustomerRegistrationWith(request: Pin.CustomerRegistration.Request, successCompletionHandler: @escaping customerRegistrationResponseHandler, failureCompletionHandler: @escaping customerRegistrationResponseHandler)
    {
        RequestManager().postCustomerRegistration(request: request.baseRequest()) { (status, response) in
            self.handlePostCustomerRegistrationResponse(success: successCompletionHandler, fail: failureCompletionHandler, status: status, response: response)
        }
        
    }
    
    func postDoLoginWith(request: Pin.Login.Request, successCompletionHandler: @escaping loginResponseHandler, failureCompletionHandler: @escaping loginResponseHandler)
    {
        RequestManager().postLogin(request: request.baseRequest()) { (status, response) in
            self.handlePostLoginResponse(success: successCompletionHandler, fail: failureCompletionHandler, status: status, response: response)
        }
        
    }
    
    //MARK: Parse methods
    
    public func handlePostCustomerRegistrationResponse(success:@escaping(customerRegistrationResponseHandler), fail:@escaping(customerRegistrationResponseHandler), status: Bool, response: Any?) {
        var message:String = Constants.kErrorMessage
        if status {
            if let result = response as? Pin.CustomerRegistration.Response {
                success(result)
                return
            }
        }
        else {
            if let result = response as? Pin.CustomerRegistration.Response {
                fail(result)
                return
            }
            else
            {
                if let result = response as? String {
                    message = result
                }
            }
        }
        fail(Pin.CustomerRegistration.Response(message:message)!)
    }
    
    public func handlePostLoginResponse(success:@escaping(loginResponseHandler), fail:@escaping(loginResponseHandler), status: Bool, response: Any?) {
        var message:String = Constants.kErrorMessage
        if status {
            if let result = response as? Pin.Login.Response {
                success(result)
                return
            }
        }
        else {
            if let result = response as? Pin.Login.Response {
                fail(result)
                return
            }
            else
            {
                if let result = response as? String {
                    message = result
                }
            }
        }
        fail(Pin.Login.Response(message:message)!)
    }
    
}
