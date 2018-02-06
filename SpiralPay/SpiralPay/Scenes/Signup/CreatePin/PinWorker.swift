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

class PinWorker
{
    func postCustomerRegistrationWith(request: Pin.CustomerRegistration.Request, successCompletionHandler: @escaping customerRegistrationResponseHandler, failureCompletionHandler: @escaping customerRegistrationResponseHandler)
  {
    RequestManager().postCustomerRegistration(request: request.baseRequest()) { (status, response) in
        self.handlePostCustomerRegistrationResponse(success: successCompletionHandler, fail: failureCompletionHandler, status: status, response: response)
    }
    
  }
    
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
    
}
