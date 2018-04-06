//
//  NetworkHttpClient.swift
//  SaitamaCycles
//
//  Created by Zoeb on 31/05/17.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper



class NetworkHttpClient: NSObject {
    
    typealias successBlock = (_ response: Any?) -> Void
    typealias failureBlock = (_ response: Any?) -> Void
    
    static let sharedInstance = NetworkHttpClient()
    
    var urlPathSubstring: String = ""
    
    override init() {
        let appSettings: AppSettings = AppSettingsManager.sharedInstance.fetchSettings()
        urlPathSubstring = appSettings.URLPathSubstring
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: BASE URL
    class func baseUrl() -> String {
        let appSettings: AppSettings = AppSettingsManager.sharedInstance.appSettings
        
        let secureConnection: String = appSettings.EnableSecureConnection ? Constants.SecureProtocol : Constants.InsecureProtocol
        if appSettings.NetworkMode == Constants.LiveEnviroment { // for live env
            return String.init(format: "%@%@", secureConnection, appSettings.ProductionURL)
        } else if appSettings.NetworkMode == Constants.StagingEnviroment { // for staging env
            return String.init(format: "%@%@", secureConnection, appSettings.StagingURL)
        } else // for local env
        {
            return String.init(format: "%@%@", secureConnection, appSettings.LocalURL)
        }
    }
    
    // MARK: API calls
    func getAPICall<T:Mappable>(_ strURL : String, parameters : Dictionary<String, Any>?, headers : [String : String]?, apiType: ApiType, genericResponse:T.Type, success:@escaping successBlock, failure:@escaping failureBlock) {
        performAPICall(strURL, methodType: .get, parameters: parameters, requestHeaders: headers, apiType: apiType, genericResponse: genericResponse, success: success, failure: failure)
    }
    
    func putAPICall<T:Mappable>(_ strURL : String, parameters : Dictionary<String, Any>?, headers : [String : String]?, apiType: ApiType, genericResponse:T.Type, success:@escaping successBlock, failure:@escaping failureBlock) {
        performAPICall(strURL, methodType: .put, parameters: parameters, requestHeaders: headers, apiType: apiType, genericResponse: genericResponse, success: success, failure: failure)
    }
    
    func postAPICall<T:Mappable>(_ strURL : String, parameters : Dictionary<String, Any>?, headers : [String : String]?, apiType: ApiType, genericResponse:T.Type, success:@escaping successBlock, failure:@escaping failureBlock) {
        performAPICall(strURL, methodType: .post, parameters: parameters, requestHeaders: headers, apiType: apiType, genericResponse:genericResponse, success: success, failure: failure)
    }
    
    func deleteAPICall<T:Mappable>(_ strURL : String, parameters : Dictionary<String, Any>?, headers : [String : String]?, apiType: ApiType, genericResponse:T.Type, success:@escaping successBlock, failure:@escaping failureBlock) {
        performAPICall(strURL, methodType: .delete, parameters: parameters, requestHeaders: headers, apiType: apiType, genericResponse: genericResponse, success: success, failure: failure)
    }
    
    func performAPICall<T:Mappable>(_ strURL : String, methodType: HTTPMethod, parameters : Dictionary<String, Any>?, requestHeaders : [String : String]?, apiType: ApiType, genericResponse:T.Type, success:@escaping successBlock, failure:@escaping failureBlock){
        
        
        var completeURL:String = NetworkHttpClient.baseUrl() + BaseRequest.getUrl(path: strURL)
        if parameters != nil && (parameters![Constants.kShouldRunOnlyOnLive] as? Bool == true) {
            var params:Dictionary<String, Any> = parameters!
            params[Constants.kShouldRunOnlyOnLive] = nil
            completeURL = "https://\(AppSettingsManager.sharedInstance.appSettings.ProductionURL)\(BaseRequest.getUrl(path: strURL))"
        }
        
        
        var headers = requestHeaders
        if headers == nil && strURL != loginURL {
            headers = NetworkHttpClient.getHeader() as? HTTPHeaders
        }
        
        
        if parameters?[BaseRequest.hasArrayResponse] != nil {
            var params:Dictionary<String, Any> = parameters!
            params[BaseRequest.hasArrayResponse] = nil
            
            Alamofire.request(completeURL, method: methodType, parameters: params, encoding: (methodType == .get ? URLEncoding.default : JSONEncoding.default), headers: headers).responseArray { (response: DataResponse<[T]>) in
                self.showAlertWith(message: "1\(response)")
                print("Response array: \(response)")
                switch response.result {
                case .success(let value):
                    print(value)
                    success(response)
                case .failure(let error):
                    print(error.localizedDescription)
                    failure(response)
                }
            }
        }
        else if parameters?[BaseRequest.hasNullResponse] != nil {
            
            var params:Dictionary<String, Any> = parameters!
            params[BaseRequest.hasNullResponse] = nil
            Alamofire.request(completeURL, method: methodType, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) -> Void in
                self.showAlertWith(message: "2\(response)")
                print("Response null: \(response)")
                switch response.result {
                case .success(let value):
                    print(value)
                    success(response)
                case .failure(let error):
                    print(error.localizedDescription)
                    failure(response)
                }
//                if response.result.isSuccess {
//                    print(responseObject.result)
//                    //                let resJson = JSON(response.result.value!)
//                    success(responseObject)
//                }
//                if response.result.isFailure {
//                    //                let error : Error = response.result.error!
//                    failure(responseObject)
//                }
            }
        }
        else
        {
            Alamofire.request(completeURL, method: methodType, parameters: parameters, encoding: (methodType == .get ? URLEncoding.default : JSONEncoding.default), headers: headers).responseObject { (response: DataResponse<T>) in
                self.showAlertWith(message: "3\(response)")
                print("Response regular: \(response)")
                
                //Exception is for the ones when response is empty
                let exceptionSuccess: AnyObject? = self.handleExceptionsFor(url: BaseRequest.getUrl(path: strURL), withResponseCode: response.response?.statusCode ?? 0, response: response, apiType: apiType, genericResponse: genericResponse)
                
                if exceptionSuccess != nil {
                    print("Exception success")
                    success(exceptionSuccess)
                    return
                }
                
                switch response.result {
                case .success(let value):
                    print(value)
                    success(response)
                case .failure(let error):
                    print(error.localizedDescription)
                    failure(response)
                }
            }
        }
        
    }
    
    func multipartPostAPICall(_ strURL: String, parameters: Dictionary<String, Any>?, data: Data, name: String, fileName: String, mimeType: String, success: @escaping successBlock, failure: @escaping failureBlock) -> Void{
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(data, withName: name, fileName: fileName, mimeType: mimeType)
        }, to: strURL, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    success(response)
                }
            case .failure(let encodingError):
                failure(encodingError)
            }
        })
    }
    
    class func getHeader() -> Dictionary<String, Any> {
        var header: HTTPHeaders = [String : String]()
        if User.shared.accessToken != nil && User.shared.accessToken?.count != 0 {
            let accessToken = User.shared.accessToken!
            header[Constants.kAuthorizationkey] = "\(Constants.kBearerkey)\(accessToken)"
            header[Constants.kContentTypeKey] = Constants.kContentTypeValue
            print("Header: \(header)")
        }
        return header
    }
    
    func showAlertWith(message: String) {
        return
        let alert = UIAlertController(title: nil, message: "\(UserDefaults.standard.value(forKey: Constants.deviceIdentifier)!) \(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func handleExceptionsFor<T:Mappable>(url: String, withResponseCode: Int, response: DataResponse<T>, apiType: ApiType, genericResponse:T.Type) -> AnyObject? {
        
        if (apiType == .Put_UpdateMobileAndEmail ||
            apiType == .Post_LockAccount) &&
            withResponseCode == 200 {
            return response as AnyObject
        }
        
        if url == sendSmsURL && withResponseCode == 202 {
//            let response = PhoneVerification.SmsPhoneVerification.Response(message: "Sms sent successfully")
//            response.response?.statusCode
            return response as AnyObject
        } else if (url.range(of: processPaymentUrlSuffix) != nil && url.range(of: processPaymentUrlPrefix) != nil)
            && withResponseCode == 202 {
            
            return response as AnyObject
        } else if (url.hasSuffix(itemAddedToBasketURLSuffix) ||
                    url.hasSuffix(changePinSuffix)) && withResponseCode == 200 {
            return response as AnyObject
        }
        
        
        return nil
    }
    
}


/*
 Alamofire.request(completeURL, method: methodType, parameters: parameters, encoding: (methodType == .get ? URLEncoding.default : JSONEncoding.default), headers: headers).responseJSON { response in
 
 switch response.result {
 case .success(let value):
 print(value)
 success(response)
 case .failure(let error):
 print(error.localizedDescription)
 failure(response)
 }
 
 }
 */

