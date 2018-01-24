//
//  CommonResponse.swift
//  SpiralPay
//
//  Created by Bestpeers on 29/12/17.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import Foundation
import ObjectMapper

enum Common
{
    struct Response: Mappable {
        
        // MARK: Declaration for string constants to be used to decode and also serialize.
        private struct SerializationKeys {
            static let errorCode = "ErrorCode"
            static let message = "Message"
        }
        
        // MARK: Properties
        public var errorCode: Int?
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
            message <- map[SerializationKeys.message]
            errorCode <- map[SerializationKeys.errorCode]
        }
        
        /// Generates description of the object in the form of a NSDictionary.
        ///
        /// - returns: A Key value pair containing all valid values in the object.
        public func dictionaryRepresentation() -> [String: Any] {
            
            var dictionary: [String: Any] = [:]
           if let value = errorCode { dictionary[SerializationKeys.errorCode] = value }
            if let value = message { dictionary[SerializationKeys.message] = value }
            return dictionary
        }
        
    }
    
}
