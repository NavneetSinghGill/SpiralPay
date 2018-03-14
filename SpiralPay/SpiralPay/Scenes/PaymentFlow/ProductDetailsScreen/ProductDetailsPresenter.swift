//
//  ProductDetailsPresenter.swift
//  SpiralPay
//
//  Created by Zoeb on 12/03/18.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ProductDetailsPresentationLogic
{
    func processPaymentSuccessWith(response: ProductDetails.ProcessPayment.Response)
    func processPaymentFailureWith(response: ProductDetails.ProcessPayment.Response)
    
    func createPaymentSuccessWith(response: ProductDetails.CreatePayment.Response)
    func createPaymentFailureWith(response: ProductDetails.CreatePayment.Response)
    
    func getCardTokenSuccessWith(response: ProductDetails.CardToken.Response)
    func getCardTokenFailureWith(response: ProductDetails.CardToken.Response)
    
    func getPaymentDetailSuccessWith(response: Home.PaymentDetail.Response)
    func getPaymentDetailFailureWith(response: Home.PaymentDetail.Response)
}

class ProductDetailsPresenter: ProductDetailsPresentationLogic
{
    weak var viewController: ProductDetailsDisplayLogic?
    
    func processPaymentSuccessWith(response: ProductDetails.ProcessPayment.Response) {
        viewController?.processPaymentSuccessWith(response: response)
    }
    
    func processPaymentFailureWith(response: ProductDetails.ProcessPayment.Response) {
        viewController?.processPaymentFailureWith(response: response)
    }
    
    
    
    func createPaymentSuccessWith(response: ProductDetails.CreatePayment.Response) {
        viewController?.createPaymentSuccessWith(response: response)
    }
    
    func createPaymentFailureWith(response: ProductDetails.CreatePayment.Response) {
        viewController?.createPaymentFailureWith(response: response)
    }
    
    
    
    func getCardTokenSuccessWith(response: ProductDetails.CardToken.Response) {
        viewController?.getCardTokenSuccessWith(response: response)
    }
    
    func getCardTokenFailureWith(response: ProductDetails.CardToken.Response) {
        viewController?.getCardTokenFailureWith(response: response)
    }
    
    
    
    func getPaymentDetailSuccessWith(response: Home.PaymentDetail.Response) {
        viewController?.getPaymentDetailSuccessWith(response: response)
    }
    
    func getPaymentDetailFailureWith(response: Home.PaymentDetail.Response) {
        viewController?.getPaymentDetailFailureWith(response: response)
    }
    
}
