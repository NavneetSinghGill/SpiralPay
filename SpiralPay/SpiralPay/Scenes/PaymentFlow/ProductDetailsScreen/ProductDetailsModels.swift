//
//  ProductDetailsModels.swift
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
import ObjectMapper

enum ProductDetails
{
    // MARK: Use cases
    
    enum ProcessPayment
    {
        struct Request
        {
            var paymentId: String?
            
            func baseRequest() -> BaseRequest {
                let baseRequest = BaseRequest()
                baseRequest.urlPath = "/v1/qr_payments/\(paymentId ?? "")"
                
                return baseRequest
            }
        }
        struct Response: Mappable {
            
            private struct SerializationKeys {
                static let customerEmail = "customer_email"
                static let cardToken = "card_token"
                static let customerPhone = "customer_phone"
                static let message = "message"
                static let errors = "errors"
            }
            
            public var customerEmail: String?
            public var cardToken: String?
            public var customerPhone: String?
            public var message: String?
            public var errors: String?
            
            public init?(map: Map){
                
            }
            
            public init?(message: String){
                self.message = message
            }
            
            public mutating func mapping(map: Map) {
                customerEmail <- map[SerializationKeys.customerEmail]
                cardToken <- map[SerializationKeys.cardToken]
                customerPhone <- map[SerializationKeys.customerPhone]
                message <- map[SerializationKeys.message]
                errors <- map[SerializationKeys.errors]
            }
            
            public func dictionaryRepresentation() -> [String: Any] {
                var dictionary: [String: Any] = [:]
                if let value = customerEmail { dictionary[SerializationKeys.customerEmail] = value }
                if let value = cardToken { dictionary[SerializationKeys.cardToken] = value }
                if let value = customerPhone { dictionary[SerializationKeys.customerPhone] = value }
                if let value = message { dictionary[SerializationKeys.message] = value }
                if let value = errors { dictionary[SerializationKeys.errors] = value }
                return dictionary
            }
            
        }
    }
    
    
    
    
    enum CardToken
    {
        struct Request
        {
            var clientIP: String?
            var locale: String?
            var currency: String?
            var amount: CGFloat?
            var userAgent: String?
            var city: String?
            var country: String?
            var line1: String?
            var line2: String?
            var state: String?
            var postcode: String?
            var type: String?
            var email: String?
            var cvv: String?
            var expiryMonth: Int?
            var expiryYear: Int?
            var number: String?
            var name: String?
            
            func baseRequest() -> BaseRequest {
                let baseRequest = BaseRequest()
                baseRequest.urlPath = "/v1/tokens"
                
                baseRequest.parameters["client_ip"] = clientIP ?? ""
                baseRequest.parameters["locale"] = locale ?? ""
                baseRequest.parameters["currency"] = currency ?? ""
                baseRequest.parameters["amount"] = amount ?? 0
                baseRequest.parameters["type"] = type ?? ""
                baseRequest.parameters["email"] = email ?? ""
                
                var address = Dictionary<String,String>()
                address["city"] = city ?? ""
                address["country"] = country ?? ""
                address["line1"] = line1 ?? ""
                address["line2"] = line2 ?? ""
                address["state"] = state ?? ""
                address["postcode"] = postcode ?? ""
                baseRequest.parameters["address"] = address
                
                var card = Dictionary<String,AnyObject>()
                card["cvv"] = (cvv ?? "") as AnyObject
                card["expiry_month"] = (expiryMonth ?? 0) as AnyObject
                card["expiry_year"] = (expiryYear ?? 0) as AnyObject
                card["number"] = (number ?? "") as AnyObject
                card["name"] = (name ?? "") as AnyObject
                baseRequest.parameters["card"] = card
                
                return baseRequest
            }
        }
        struct Response: Mappable {
            
            private struct SerializationKeys {
                static let token = "token"
                static let message = "message"
                static let errors = "errors"
            }
            
            public var token: String?
            public var message: String?
            public var errors: String?
            
            public init?(map: Map){
                
            }
            
            public init?(message: String){
                self.message = message
            }
            
            public mutating func mapping(map: Map) {
                token <- map[SerializationKeys.token]
                message <- map[SerializationKeys.message]
                errors <- map[SerializationKeys.errors]
            }
            
            public func dictionaryRepresentation() -> [String: Any] {
                var dictionary: [String: Any] = [:]
                if let value = token { dictionary[SerializationKeys.token] = value }
                if let value = message { dictionary[SerializationKeys.message] = value }
                if let value = errors { dictionary[SerializationKeys.errors] = value }
                return dictionary
            }
            
        }
    }
}