//
//  PinInteractor.swift
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

protocol PinBusinessLogic
{
  func doSomething(request: Pin.Something.Request)
}

protocol PinDataStore
{
  //var name: String { get set }
}

class PinInteractor: PinBusinessLogic, PinDataStore
{
  var presenter: PinPresentationLogic?
  var worker: PinWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: Pin.Something.Request)
  {
    worker = PinWorker()
    worker?.doSomeWork()
    
    let response = Pin.Something.Response()
    presenter?.presentSomething(response: response)
  }
}
