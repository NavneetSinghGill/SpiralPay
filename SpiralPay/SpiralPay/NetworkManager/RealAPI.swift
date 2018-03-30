//
//  RealAPI.swift
//  SaitamaCycles
//
//  Created by Zoeb on 01/06/17.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class RealAPI: NSObject {
    
    var VMRequest: BaseRequest = BaseRequest()
    var isForbiddenRetry: Bool = false
    var realAPIBlock: CompletionHandler = { _,_ in }
    
    func putObject<T:Mappable>(request: BaseRequest, genericResponse:T.Type, completion: @escaping CompletionHandler) -> Void {
        interactAPIWithPutObject(request: request, genericResponse: genericResponse, completion: completion)
    }
    
    func getObject<T:Mappable>(request: BaseRequest, genericResponse:T.Type, completion: @escaping CompletionHandler) -> Void {
        interactAPIWithGetObject(request: request, genericResponse: genericResponse, completion: completion)
    }
    
    func postObject<T:Mappable>(request: BaseRequest, genericResponse:T.Type, completion: @escaping CompletionHandler) -> Void {
        interactAPIWithPostObject(request: request, genericResponse: genericResponse, completion: completion)
    }
    
    func deleteObject<T:Mappable>(request: BaseRequest, genericResponse:T.Type, completion: @escaping CompletionHandler) -> Void {
        interactAPIWithDeleteObject(request: request, genericResponse: genericResponse, completion: completion)
    }
    
    func multiPartObjectPost<T:Mappable>(request: BaseRequest, genericResponse:T.Type, completion: @escaping CompletionHandler) -> Void {
        interactAPIWithMultipartObjectPost(request: request, genericResponse: genericResponse, completion: completion)
    }
    
    // MARK: Request methods
    func interactAPIWithGetObject<T:Mappable>(request: BaseRequest, genericResponse:T.Type, completion: @escaping CompletionHandler) -> Void {
        initialSetup(request: request, requestType: Constants.RequestType.GET.rawValue)
        NetworkHttpClient.sharedInstance.getAPICall(request.urlPath, parameters: request.getParams(), headers: request.headers, genericResponse: genericResponse, success: { (responseObject) in
            self.handleSuccessResponse(request: request, response: responseObject as? DataResponse<T>, responseArray: responseObject as? DataResponse<[T]>, block: completion)
        }, failure: { (responseObject) in
            self.handleError(response: responseObject as? DataResponse<T>, responseArray: responseObject as? DataResponse<[T]>, block: completion)
        })
    }
    
    func interactAPIWithPutObject<T:Mappable>(request: BaseRequest, genericResponse:T.Type, completion: @escaping CompletionHandler) -> Void {
        initialSetup(request: request, requestType: Constants.RequestType.PUT.rawValue)
        NetworkHttpClient.sharedInstance.putAPICall(request.urlPath, parameters: request.getParams(), headers: request.headers, genericResponse: genericResponse, success: { (responseObject) in
            self.handleSuccessResponse(request: request, response: responseObject as? DataResponse<T>, responseArray: responseObject as? DataResponse<[T]>, block: completion)
        }, failure: { (responseObject) in
            self.handleError(response: responseObject as? DataResponse<T>, responseArray: responseObject as? DataResponse<[T]>, block: completion)
        })
    }
    
    func interactAPIWithPostObject<T:Mappable>(request: BaseRequest, genericResponse:T.Type, completion: @escaping CompletionHandler) -> Void {
        initialSetup(request: request, requestType: Constants.RequestType.POST.rawValue)
        NetworkHttpClient.sharedInstance.postAPICall(request.urlPath, parameters: request.getParams(), headers: request.headers, genericResponse: genericResponse, success: { (responseObject) in
            self.handleSuccessResponse(request: request, response: responseObject as? DataResponse<T>, responseArray: responseObject as? DataResponse<[T]>, block: completion)
        }, failure: { (responseObject) in
            self.handleError(response: responseObject as? DataResponse<T>, responseArray: responseObject as? DataResponse<[T]>, block: completion)
        })
    }
    
    func interactAPIWithDeleteObject<T:Mappable>(request: BaseRequest, genericResponse:T.Type, completion: @escaping CompletionHandler) -> Void {
        initialSetup(request: request, requestType: Constants.RequestType.DELETE.rawValue)
        NetworkHttpClient.sharedInstance.deleteAPICall(request.urlPath, parameters: request.getParams(), headers: request.headers, genericResponse: genericResponse, success: { (responseObject) in
            self.handleSuccessResponse(request: request, response: responseObject as? DataResponse<T>, responseArray: responseObject as? DataResponse<[T]>, block: completion)
        }, failure: { (responseObject) in
            self.handleError(response: responseObject as? DataResponse<T>, responseArray: responseObject as? DataResponse<[T]>, block: completion)
        })
    }
    
    func interactAPIWithMultipartObjectPost<T:Mappable>(request: BaseRequest, genericResponse:T.Type, completion: @escaping CompletionHandler) -> Void {
        initialSetup(request: request, requestType: Constants.RequestType.MultiPartPost.rawValue)
        NetworkHttpClient.sharedInstance.multipartPostAPICall(request.urlPath, parameters: request.getParams(), data: request.fileData, name: request.dataFilename, fileName: request.fileName, mimeType: request.mimeType, success: { (responseObject) in
            self.handleSuccessResponse(request: request, response: responseObject as? DataResponse<T>, responseArray: responseObject as? DataResponse<[T]>, block: completion)
        }, failure: { (responseObject) in
            self.handleError(response: responseObject as? DataResponse<T>, responseArray: responseObject as? DataResponse<[T]>, block: completion)
        })
    }
    
    //Handling success response
    func handleSuccessResponse<T:Mappable>(request: BaseRequest, response: DataResponse<T>?, responseArray: DataResponse<[T]>?, block:@escaping CompletionHandler) -> Void {
        let responseStatus = response != nil ? response?.response : responseArray?.response
        
//        let message: String = String.init(format: "Success:- URL:%@\n", (responseStatus?.url?.absoluteString)!)
//        print(message)
        if ((request.urlPath == sendSmsURL || (request.urlPath.range(of: processPaymentUrlSuffix) != nil && request.urlPath.range(of: processPaymentUrlPrefix) != nil)) && responseStatus?.statusCode == Constants.ResponseStatusAccepted) ||
            (request.urlPath.hasSuffix(itemAddedToBasketURLSuffix) && responseStatus?.statusCode == Constants.ResponseStatusSuccess){
            //Exception success
            block(true, response)
            return
        }
        
        if responseStatus?.statusCode == Constants.ResponseStatusSuccess || responseStatus?.statusCode == Constants.ResponseStatusCreated {
            if response != nil || responseArray != nil || (response?.result.isSuccess)! {
                isForbiddenRetry = false
                let value = getResultValue(response: response, responseArray: responseArray)
                if let result = value {
                    block(true, result)
                }
                return
            }
        }
        else if self.isForbiddenResponse(statusCode: (responseStatus?.statusCode), url: responseStatus?.url?.absoluteString) {
            realAPIBlock = block
            renewLogin()
            return
        } else {
            if response != nil || responseArray != nil {
                let value = getResultValue(response: response, responseArray: responseArray)
                if let result = value {
                    block(false, result)
                    return
                }
            }
        }
        
        block(false, nil)
    }
    
    func getResultValue<T:Mappable>(response: DataResponse<T>?, responseArray: DataResponse<[T]>?) -> Any? {
        var value:Any?
        
        if response != nil {
            value = response?.result.value
        }
        else if responseArray != nil {
            value = responseArray?.result.value
        }
        
        return value
    }
    
    //Handling Error response
    func handleError<T:Mappable>(response: DataResponse<T>?, responseArray: DataResponse<[T]>?, block: @escaping CompletionHandler) -> Void {
        let responseStatus = response != nil ? response?.response : responseArray?.response
        
        if self.isForbiddenResponse(statusCode: (responseStatus?.statusCode), url: responseStatus?.url?.absoluteString) {
            realAPIBlock = block
            renewLogin()
            return
        }
        
        var errorResponse: Any?
        
        let error : Error? =  response != nil ? response?.result.error! : responseArray?.result.error!
        
        let detailedError: NSError = error! as NSError
        if detailedError.localizedRecoverySuggestion != nil {
            do {
                errorResponse = try JSONSerialization.jsonObject(with: (detailedError.localizedRecoverySuggestion?.data(using: String.Encoding.utf8))!, options: JSONSerialization.ReadingOptions.mutableContainers)
                errorResponse != nil ? block(false, errorResponse) : block(false, error)
            }
            catch _ {
                // Error handling
            }
        }
        else {
            block(false, detailedError.localizedDescription)
        }
    }
    
    func initialSetup(request: BaseRequest, requestType: NSInteger) -> Void {
        VMRequest = request
        VMRequest.requestType = requestType
        let message: String = String.init(format: "Info: Performing API call with [URL:%@] [params: %@]", request.urlPath, request.getParams())
        print(message)
    }
    
    func isForbiddenResponse(statusCode: NSInteger?, url:String?) -> Bool {
        if statusCode != nil && statusCode == Constants.ResponseStatusForbidden && isForbiddenRetry == false && !(url!.hasSuffix(tokenURL)) {
            isForbiddenRetry = true
            return true
        }
        else if statusCode != nil && statusCode == Constants.ResponseStatusForbidden && isForbiddenRetry == true {
            // logout on token invalid
//            SecurityStorageWorker().updateLoggedInState(isLoggedIn: false)
//            ApplicationDelegate.setLandingAsRootViewController()
        }
        return false
    }
    
    func renewLogin() -> Void {
        // login with saved values
        self.loginWithSavedValues()
    }
    
    func loginWithSavedValues() {
        
    }
    
    func getLoginDetails() -> (email:String?, password:String?) {
        
//        guard let username = UserDefaults.standard.value(forKey: Constants.kUsernameKey) as? String else {
//            return (nil, nil)
//        }
        
//        do {
//            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
//                                                    account: username,
//                                                    accessGroup: KeychainConfiguration.accessGroup)
//            let keychainPassword = try passwordItem.readPassword()
//            return (username, keychainPassword)
//        }
//        catch {
//            fatalError("Error reading password from keychain - \(error)")
//        }
        
        return (nil, nil)
    }
    
    func renewLoginRequestCompleted() {
        // calling failed API again
       /* switch VMRequest.requestType {
        case Constants.RequestType.GET.rawValue:
            self.interactAPIWithGetObject(request: VMRequest, completion: realAPIBlock)
            break
        case Constants.RequestType.POST.rawValue:
            self.interactAPIWithPostObject(request: VMRequest, completion: realAPIBlock)
            break
        case Constants.RequestType.PUT.rawValue:
            self.interactAPIWithPutObject(request: VMRequest, completion: realAPIBlock)
            break
        case Constants.RequestType.MultiPartPost.rawValue:
            self.interactAPIWithMultipartObjectPost(request: VMRequest, completion: realAPIBlock)
            break
        case Constants.RequestType.DELETE.rawValue:
            self.interactAPIWithDeleteObject(request: VMRequest, completion: realAPIBlock)
            break
        default:
            break
        }*/
    }
}
