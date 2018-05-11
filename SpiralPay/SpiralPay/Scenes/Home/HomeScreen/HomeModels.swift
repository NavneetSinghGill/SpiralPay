//
//  HomeModels.swift
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
import ObjectMapper

enum Home
{
    // MARK: Use cases
    
    enum PaymentHistory
    {
        struct Request
        {
            var from: String?
            
            func baseRequest() -> BaseRequest {
                let baseRequest = BaseRequest()
                baseRequest.urlPath = "/v1/wallet/customers/\(User.shared.customerID ?? "")/payments?from=\(from ?? "")"
                
                baseRequest.parameters[BaseRequest.hasArrayResponse] = true
                
                return baseRequest
            }
        }
        struct Response: Mappable {
            
            private struct SerializationKeys {
                static let paymentId = "payment_id"
                static let merchantName = "merchant_name"
                static let created = "created"
                static let merchantLogoId = "merchant_logo_id"
                static let currency = "currency"
                static let amount = "amount"
                static let merchantId = "merchant_id"
                static let message = "message"
            }
            

            public var paymentId: String?
            public var merchantName: String?
            public var created: Int?
            public var merchantLogoId: String?
            public var currency: String?
            public var amount: CGFloat?
            public var merchantId: String?
            public var message: String?
            
            public var details: Home.PaymentDetail.Response?
            
            public init?(map: Map){
                
            }
            
            public init?(message: String){
                self.message = message
            }
            public init(){
                
            }
            
            public mutating func mapping(map: Map) {
                paymentId <- map[SerializationKeys.paymentId]
                merchantName <- map[SerializationKeys.merchantName]
                created <- map[SerializationKeys.created]
                merchantLogoId <- map[SerializationKeys.merchantLogoId]
                currency <- map[SerializationKeys.currency]
                amount <- map[SerializationKeys.amount]
                merchantId <- map[SerializationKeys.merchantId]
                message <- map[SerializationKeys.message]
            }
            
            public func dictionaryRepresentation() -> [String: Any] {
                var dictionary: [String: Any] = [:]
                if let value = paymentId { dictionary[SerializationKeys.paymentId] = value }
                if let value = merchantName { dictionary[SerializationKeys.merchantName] = value }
                if let value = created { dictionary[SerializationKeys.created] = value }
                if let value = merchantLogoId { dictionary[SerializationKeys.merchantLogoId] = value }
                if let value = currency { dictionary[SerializationKeys.currency] = value }
                if let value = amount { dictionary[SerializationKeys.amount] = value }
                if let value = merchantId { dictionary[SerializationKeys.merchantId] = value }
                if let value = message { dictionary[SerializationKeys.message] = value }
                return dictionary
            }
            
        }
    }
    
    
    
    enum PaymentDetail {
        struct Request
        {
            var paymentID: String?
            
            func baseRequest() -> BaseRequest {
                let baseRequest = BaseRequest()
                baseRequest.urlPath = "/v1/qr_payments/\(paymentID ?? "")"
                
                return baseRequest
            }
        }
        struct Response: Mappable {
            
            private struct SerializationKeys {
                static let paymentId = "payment_id"
                static let status = "status"
                static let errors = "errors"
                static let merchantName = "merchant_name"
                static let created = "created"
                static let merchantLogoId = "merchant_logo_id"
                static let customerItems = "customer_items"
                static let currency = "currency"
                static let amount = "amount"
                static let merchantId = "merchant_id"
                static let redirectUrl = "redirect_url"
                static let vat = "vat"
                static let message = "message"
            }
            
            
            public var paymentId: String?
            public var status: String?
            public var errors: [Any]?
            public var merchantName: String?
            public var created: Int?
            public var merchantLogoId: String?
            public var customerItems: [CustomerItems]?
            public var currency: String?
            public var amount: CGFloat?
            public var merchantId: String?
            public var redirectUrl: String?
            public var vat: CGFloat?
            public var message: String?
            
            public init?(map: Map){
                
            }
            
            public init?(message: String){
                self.message = message
            }
            public init(){
                
            }
            
            public mutating func mapping(map: Map) {
                paymentId <- map[SerializationKeys.paymentId]
                status <- map[SerializationKeys.status]
                errors <- map[SerializationKeys.errors]
                merchantName <- map[SerializationKeys.merchantName]
                created <- map[SerializationKeys.created]
                merchantLogoId <- map[SerializationKeys.merchantLogoId]
                customerItems <- map[SerializationKeys.customerItems]
                currency <- map[SerializationKeys.currency]
                amount <- map[SerializationKeys.amount]
                merchantId <- map[SerializationKeys.merchantId]
                redirectUrl <- map[SerializationKeys.redirectUrl]
                vat <- map[SerializationKeys.vat]
                message <- map[SerializationKeys.message]
            }
            
            public func dictionaryRepresentation() -> [String: Any] {
                var dictionary: [String: Any] = [:]
                if let value = paymentId { dictionary[SerializationKeys.paymentId] = value }
                if let value = status { dictionary[SerializationKeys.status] = value }
                if let value = errors { dictionary[SerializationKeys.errors] = value }
                if let value = merchantName { dictionary[SerializationKeys.merchantName] = value }
                if let value = created { dictionary[SerializationKeys.created] = value }
                if let value = merchantLogoId { dictionary[SerializationKeys.merchantLogoId] = value }
                if let value = customerItems { dictionary[SerializationKeys.customerItems] = value.map { $0.dictionaryRepresentation() } }
                if let value = currency { dictionary[SerializationKeys.currency] = value }
                if let value = amount { dictionary[SerializationKeys.amount] = value }
                if let value = merchantId { dictionary[SerializationKeys.merchantId] = value }
                if let value = redirectUrl { dictionary[SerializationKeys.redirectUrl] = value }
                if let value = vat { dictionary[SerializationKeys.vat] = value }
                if let value = message { dictionary[SerializationKeys.message] = value }
                return dictionary
            }
            
        }
        
        public struct CustomerItems: Mappable {
            
            // MARK: Declaration for string constants to be used to decode and also serialize.
            private struct SerializationKeys {
                static let descriptionValue = "description"
                static let name = "name"
                static let amount = "amount"
                static let currency = "currency"
                static let count = "count"
                static let vat = "vat"
                static let imageID = "image_id"
                static let errorDescription = "error_description"
                static let error = "error"
            }
            
            // MARK: Properties
            public var descriptionValue: String?
            public var name: String?
            public var amount: CGFloat?
            public var currency: String?
            public var count: Int?
            public var vat: CGFloat?
            public var imageID: String?
            public var errorDescription: String?
            public var error: String?
            
            // MARK: ObjectMapper Initializers
            /// Map a JSON object to this class using ObjectMapper.
            ///
            /// - parameter map: A mapping from ObjectMapper.
            public init?(map: Map){
                
            }
            
            /// Map a JSON object to this class using ObjectMapper.
            ///
            /// - parameter map: A mapping from ObjectMapper.
            public mutating func mapping(map: Map) {
                descriptionValue <- map[SerializationKeys.descriptionValue]
                name <- map[SerializationKeys.name]
                amount <- map[SerializationKeys.amount]
                currency <- map[SerializationKeys.currency]
                count <- map[SerializationKeys.count]
                vat <- map[SerializationKeys.vat]
                imageID <- map[SerializationKeys.imageID]
                errorDescription <- map[SerializationKeys.errorDescription]
                error <- map[SerializationKeys.error]
            }
            
            /// Generates description of the object in the form of a NSDictionary.
            ///
            /// - returns: A Key value pair containing all valid values in the object.
            public func dictionaryRepresentation() -> [String: Any] {
                var dictionary: [String: Any] = [:]
                if let value = descriptionValue { dictionary[SerializationKeys.descriptionValue] = value }
                if let value = name { dictionary[SerializationKeys.name] = value }
                if let value = amount { dictionary[SerializationKeys.amount] = value }
                if let value = currency { dictionary[SerializationKeys.currency] = value }
                if let value = count { dictionary[SerializationKeys.count] = value }
                if let value = vat { dictionary[SerializationKeys.vat] = value }
                if let value = imageID { dictionary[SerializationKeys.imageID] = value }
                if let value = errorDescription { dictionary[SerializationKeys.errorDescription] = value }
                if let value = error { dictionary[SerializationKeys.error] = value }
                return dictionary
            }
            
            public init(combinedItem: CombinedItem) {
                self.descriptionValue = combinedItem.descriptionValue
                self.name = combinedItem.name
                self.amount = CGFloat(combinedItem.amount)
                self.currency = combinedItem.currency
                self.count = Int(combinedItem.count)
                self.vat = CGFloat(combinedItem.vat)
                self.imageID = combinedItem.imageID
            }
            
        }
    }
    
    enum GetCampaigns {
        struct Request
        {
            var campaignID: String?
            
            func baseRequest() -> BaseRequest {
                let baseRequest = BaseRequest()
                baseRequest.urlPath = "/v1/campaigns/\(campaignID ?? "")"
                
                baseRequest.parameters[Constants.kShouldRunOnlyOnLive] = true
                
                return baseRequest
            }
        }
        struct Response: Mappable {
            
            private struct SerializationKeys {
                static let active = "active"
                static let items = "items"
                static let merchantId = "merchant_id"
                static let campaignId = "campaign_id"
                static let name = "name"
                static let errors = "errors"
                static let message = "message"
            }
            
            
            public var active: Bool?
            public var items: [PaymentDetail.CustomerItems]?
            public var merchantId: String?
            public var campaignId: String?
            public var name: String?
            public var errors: [Any]?
            public var message: String?
            
            public var currency: String? {
                get {
                    if items?.first?.currency != nil {
                        return items!.first?.currency
                    } else {
                        return ""
                    }
                }
            }
            
            public var amount: CGFloat? {
                get {
                    if items != nil {
                        var totalAmount: CGFloat = 0
                        for item in items! {
                            totalAmount = totalAmount + ((item.amount ?? 0) * CGFloat(item.count ?? 0))
                        }
                        return totalAmount
                    } else {
                        return 0
                    }
                }
            }
            
            public var vat: CGFloat? {
                get {
                    if items != nil {
                        var totalVat: CGFloat = 0
                        for item in items! {
                            totalVat = totalVat + ((item.vat ?? 0) * CGFloat(item.count ?? 0))
                        }
                        return totalVat
                    } else {
                        return 0
                    }
                }
            }
            
            public init?(map: Map){
                
            }
            
            public init?(message: String){
                self.message = message
            }
            public init(){
                
            }
            
            public mutating func mapping(map: Map) {
                active <- map[SerializationKeys.active]
                items <- map[SerializationKeys.items]
                merchantId <- map[SerializationKeys.merchantId]
                campaignId <- map[SerializationKeys.campaignId]
                name <- map[SerializationKeys.name]
                errors <- map[SerializationKeys.errors]
                message <- map[SerializationKeys.message]
            }
            
            public func dictionaryRepresentation() -> [String: Any] {
                var dictionary: [String: Any] = [:]
                if let value = active { dictionary[SerializationKeys.active] = value }
                if let value = items { dictionary[SerializationKeys.items] = value }
                if let value = merchantId { dictionary[SerializationKeys.merchantId] = value }
                if let value = campaignId { dictionary[SerializationKeys.campaignId] = value }
                if let value = name { dictionary[SerializationKeys.name] = value }
                if let value = errors { dictionary[SerializationKeys.errors] = value }
                if let value = message { dictionary[SerializationKeys.message] = value }
                return dictionary
            }
            
        }
        
    }
}
