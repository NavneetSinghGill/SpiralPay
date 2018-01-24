//
//  TokenWorker.swift
//  SpiralPay
//
//  Created by Zoeb on 11/12/17.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

typealias accessTokenResponseHandler = (_ response:Token.JWTToken.Response) ->()


class TokenWorker:BaseWorker
{
    func fetchJWTToken(request:Token.JWTToken.Request, success:@escaping(accessTokenResponseHandler), fail:@escaping(accessTokenResponseHandler))
    {
        //call network etc.
        let manager = RequestManager()
        
        manager.fetchJWTToken(request: request.baseRequest()) { (status, response) in
            self.handleTokenResponse(success: success, fail: fail, status: status, response: response)
        }
    }
    
    func fetchRefreshToken(refreshToken:String, success:@escaping(accessTokenResponseHandler), fail:@escaping(accessTokenResponseHandler))
    {
        //call network etc.
        let manager = RequestManager()
        
        manager.fetchRefreshToken(request: Token.JWTToken.RefreshRequest().baseRequest(refreshToken: refreshToken)) { (status, response) in
            self.handleTokenResponse(success: success, fail: fail, status: status, response: response)
        }
    }
}

