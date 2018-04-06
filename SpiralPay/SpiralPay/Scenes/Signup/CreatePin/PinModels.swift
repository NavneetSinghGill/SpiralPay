//
//  PinModels.swift
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
import ObjectMapper

let customerRegistrationURL = "/v1/wallet/customers"
let loginURL = "/v1/wallet/customers/login"

enum Pin
{
  // MARK: Use cases
  
  enum CustomerRegistration
  {
    struct Request
    {
        var phone: String?
        var deviceID:String! = "did_\(UserDefaults.standard.value(forKey: Constants.deviceIdentifier)!)"
        var email: String?
        var pinCode: String?
        
        func baseRequest() -> BaseRequest {
            let baseRequest = BaseRequest()
            baseRequest.urlPath = customerRegistrationURL
            baseRequest.parameters["phone"] = phone ?? ""
            baseRequest.parameters["device_id"] = deviceID
            baseRequest.parameters["email"] = email ?? ""
            baseRequest.parameters["pin_code"] = pinCode ?? ""
            return baseRequest
        }
    }
    struct Response: Mappable {
        
        // MARK: Declaration for string constants to be used to decode and also serialize.
        private struct SerializationKeys {
            static let customerId = "customer_id"
            static let accessToken = "access_token"
            static let message = "message"
        }
        
        // MARK: Properties
        public var customerId: String?
        public var accessToken: String?
        public var message: String?
        
        // MARK: ObjectMapper Initializers
        /// Map a JSON object to this class using ObjectMapper.
        ///
        /// - parameter map: A mapping from ObjectMapper.
        public init?(map: Map){
            
        }
        public init?(message: String){
            self.message = message
        }
        
        /// Map a JSON object to this class using ObjectMapper.
        ///
        /// - parameter map: A mapping from ObjectMapper.
        public mutating func mapping(map: Map) {
            customerId <- map[SerializationKeys.customerId]
            accessToken <- map[SerializationKeys.accessToken]
            message <- map[SerializationKeys.message]
        }
        
        /// Generates description of the object in the form of a NSDictionary.
        ///
        /// - returns: A Key value pair containing all valid values in the object.
        public func dictionaryRepresentation() -> [String: Any] {
            var dictionary: [String: Any] = [:]
            if let value = customerId { dictionary[SerializationKeys.customerId] = value }
            if let value = accessToken { dictionary[SerializationKeys.accessToken] = value }
            if let value = message { dictionary[SerializationKeys.message] = value }
            return dictionary
        }
        
    }
  }
    
    enum Login
    {
        struct Request
        {
            var deviceID:String! = "did_\(UserDefaults.standard.value(forKey: Constants.deviceIdentifier)!)"
            var pinCode: String?
            
            func baseRequest() -> BaseRequest {
                let baseRequest = BaseRequest()
                baseRequest.urlPath = loginURL
                baseRequest.parameters["device_id"] = deviceID
                baseRequest.parameters["pin_code"] = pinCode ?? ""
                return baseRequest
            }
        }
        struct Response: Mappable {
            
            // MARK: Declaration for string constants to be used to decode and also serialize.
            private struct SerializationKeys {
                static let accessToken = "access_token"
                static let message = "message"
                static let errorDescription = "error_description"
            }
            
            // MARK: Properties
            public var accessToken: String?
            public var message: String?
            public var errorDescription: String?
            
            // MARK: ObjectMapper Initializers
            /// Map a JSON object to this class using ObjectMapper.
            ///
            /// - parameter map: A mapping from ObjectMapper.
            public init?(map: Map){
                
            }
            public init?(message: String){
                self.message = message
            }
            
            /// Map a JSON object to this class using ObjectMapper.
            ///
            /// - parameter map: A mapping from ObjectMapper.
            public mutating func mapping(map: Map) {
                accessToken <- map[SerializationKeys.accessToken]
                message <- map[SerializationKeys.message]
                errorDescription <- map[SerializationKeys.errorDescription]
            }
            
            /// Generates description of the object in the form of a NSDictionary.
            ///
            /// - returns: A Key value pair containing all valid values in the object.
            public func dictionaryRepresentation() -> [String: Any] {
                var dictionary: [String: Any] = [:]
                if let value = accessToken { dictionary[SerializationKeys.accessToken] = value }
                if let value = message { dictionary[SerializationKeys.message] = value }
                if let value = errorDescription { dictionary[SerializationKeys.errorDescription] = value }
                return dictionary
            }
            
        }
    }
}
