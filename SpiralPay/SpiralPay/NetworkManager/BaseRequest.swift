//
//  Request.swift
//  SaitamaCycles
//
//  Created by Zoeb on 29/05/17.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//

import UIKit
import Alamofire

enum ApiType {
    case Put_UpdateMobileAndEmail
    case Post_LockAccount
    case None
}

class BaseRequest: NSObject {
  static let hasArrayResponse = "HasArrayResponse"
  static let hasNullResponse = "HasNullResponse"
    var urlPath: String
    var requestType: NSInteger
    var fileData: Data
    var dataFilename: String
    var fileName: String
    var mimeType: String
    var headers: [String: String]?
    var parameters: Dictionary<String, Any>
    
    var apiType: ApiType = .None
        
    override init() {
        urlPath = ""
        requestType = 0
        fileData = Data()
        dataFilename = ""
        fileName = ""
        mimeType = ""
        parameters = [:]
        super.init()
    }
    
    public func getParams() -> Dictionary<String, Any> {
        return parameters
    }
    
    public class func getUrl(path: String) -> String {
        let client: NetworkHttpClient = NetworkHttpClient.sharedInstance
        return String.init(format: "%@%@",client.urlPathSubstring, path)
    }
}
