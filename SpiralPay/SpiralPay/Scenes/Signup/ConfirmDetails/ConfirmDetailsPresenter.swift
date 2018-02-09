//
//  ConfirmDetailsPresenter.swift
//  SpiralPay
//
//  Created by Zoeb on 09/02/18.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ConfirmDetailsPresentationLogic
{
  func presentSomething(response: ConfirmDetails.Something.Response)
}

class ConfirmDetailsPresenter: ConfirmDetailsPresentationLogic
{
  weak var viewController: ConfirmDetailsDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: ConfirmDetails.Something.Response)
  {
    let viewModel = ConfirmDetails.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
