//
//  PhoneVerificationWorker.swift
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

typealias smsPhoneVerificationResponseHandler = (_ response:PhoneVerification.SmsPhoneVerification.Response) ->()
typealias updateMobileAndEmailResponseHandler = (_ response:PhoneVerification.UpdateMobileAndEmail.Response) ->()
typealias updateCustomerVerificationDataResponseHandler = (_ response:PhoneVerification.UpdateCustomerVerificationData.Response) ->()

class PhoneVerificationWorker
{
    func sendSmsForPhoneVerification(request: PhoneVerification.SmsPhoneVerification.Request, successCompletionHandler: @escaping smsPhoneVerificationResponseHandler, failureCompletionHandler: @escaping smsPhoneVerificationResponseHandler)
    {
        RequestManager().sendSmsForPhoneVerification(request: request.baseRequest()) { (status, response) in
            self.handleSendSmsForPhoneVerificationResponse(success: successCompletionHandler, fail: failureCompletionHandler, status: status, response: response)
        }
        
    }
    
    func updateMobileAndEmail(request: PhoneVerification.UpdateMobileAndEmail.Request, successCompletionHandler: @escaping updateMobileAndEmailResponseHandler, failureCompletionHandler: @escaping updateMobileAndEmailResponseHandler)
    {
        RequestManager().updateMobileAndEmail(request: request.baseRequest()) { (status, response) in
            self.handleUpdateMobileAndEmailResponse(success: successCompletionHandler, fail: failureCompletionHandler, status: status, response: response)
        }
        
    }
    func updateCustomerVerificationData(request: PhoneVerification.UpdateCustomerVerificationData.Request, successCompletionHandler: @escaping updateCustomerVerificationDataResponseHandler, failureCompletionHandler: @escaping updateCustomerVerificationDataResponseHandler)
    {
        RequestManager().updateCustomerVerificationData(request: request.baseRequest()) { (status, response) in
            self.updateCustomerVerificationDataResponse(success: successCompletionHandler, fail: failureCompletionHandler, status: status, response: response)
        }
        
    }
    
    //MARK: Parse methods
    
    public func handleSendSmsForPhoneVerificationResponse(success:@escaping(smsPhoneVerificationResponseHandler), fail:@escaping(smsPhoneVerificationResponseHandler), status: Bool, response: Any?) {
        let message:String = Constants.kErrorMessage
        if status {
            success(PhoneVerification.SmsPhoneVerification.Response(message: "Sms sent successfully")!)
            return
        }
        fail(PhoneVerification.SmsPhoneVerification.Response(message:message)!)
    }
    
    public func handleUpdateMobileAndEmailResponse(success:@escaping(updateMobileAndEmailResponseHandler), fail:@escaping(updateMobileAndEmailResponseHandler), status: Bool, response: Any?) {
        let message:String = Constants.kErrorMessage
        if status {
            success(PhoneVerification.UpdateMobileAndEmail.Response(message: "Email/phone updated successfully")!)
            return
        }
        fail(PhoneVerification.UpdateMobileAndEmail.Response(message:message)!)
    }
    
    public func updateCustomerVerificationDataResponse(success:@escaping(updateCustomerVerificationDataResponseHandler), fail:@escaping(updateCustomerVerificationDataResponseHandler), status: Bool, response: Any?) {
        let message:String = Constants.kErrorMessage
        if status {
            success(PhoneVerification.UpdateCustomerVerificationData.Response(message: "Verification status updated")!)
            return
        }
        fail(PhoneVerification.UpdateCustomerVerificationData.Response(message:message)!)
    }
    
}
