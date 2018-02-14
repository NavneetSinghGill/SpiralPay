//
//  PinViewController.swift
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

enum PinEntry {
    case Create
    case ReEnter
    case Login
}

protocol PinDisplayLogic: class
{
    func customerRegistrationSuccess(response: Pin.CustomerRegistration.Response)
    func customerRegistrationFailed(response: Pin.CustomerRegistration.Response)
    
    func loginSuccess(response: Pin.Login.Response)
    func loginFailed(response: Pin.Login.Response)
}

class PinViewController: ProgressBarViewController, PinDisplayLogic
{
  var interactor: PinBusinessLogic?
  var router: (NSObjectProtocol & PinRoutingLogic & PinDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = PinInteractor()
    let presenter = PinPresenter()
    let router = PinRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initialSetup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        codeTextField.becomeFirstResponder()
    }
  
  // MARK: Do something
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var passwordDoesntMatch: UILabel!
    @IBOutlet var pins: [UIButton]!
    
    var pinEntry: PinEntry = .Create
    var createdPin: String?
    
    
    //MARK: - API
    //MARK: Customer registration
    func doCustomerRegistrationWith(pin: String?)
    {
        NLoader.startAnimating()
        
        //This removes space from country code
        
        var request = Pin.CustomerRegistration.Request()
        request.email = User.shared.email
        request.pinCode = pin
        request.phone = User.shared.phoneWithCode
        interactor?.doCustomerRegistration(request: request)
    }
    
    func customerRegistrationSuccess(response: Pin.CustomerRegistration.Response) {
        NLoader.stopAnimating()
        User.shared.save()
        
        router?.routeToPhoneVerificationProcess()
    }
    
    func customerRegistrationFailed(response: Pin.CustomerRegistration.Response) {
        NLoader.stopAnimating()
    }
    
    //MARK: Login
    
    func loginSuccess(response: Pin.Login.Response) {
        NLoader.shared.stopNLoader()
        
        User.shared.accessToken = response.accessToken
        self.dismiss(animated: true, completion: nil)
    }
    
    func loginFailed(response: Pin.Login.Response) {
        NLoader.shared.stopNLoader()
        
        codeTextField.becomeFirstResponder()
        self.passwordDoesntMatch.isHidden = false
    }
    
    //MARK:- Private methods
    
    private func initialSetup() {
        if pinEntry == .Create {
            percentageOfProgressBar = CGFloat(2/numberOfProgressBarPages)
        } else if pinEntry == .ReEnter {
            percentageOfProgressBar = CGFloat(3/numberOfProgressBarPages)
        } else {
            progressBar.isHidden = true
        }
        
        if pinEntry == .ReEnter {
            headingLabel.text = "Re-enter PIN Code"
        } else if pinEntry == .Login {
            headingLabel.text = "Enter PIN Code"
            passwordDoesntMatch.text = "PIN code doesn't match"
        }
    }
    
    private func selectDotWith(count: Int) {
        var pinCount = 1
        for pin in pins {
            pin.isSelected = pinCount <= count
            pinCount = pinCount + 1
        }
    }
    
    private func pinCreationAndMatchingDoneLocally() {
        doCustomerRegistrationWith(pin: codeTextField.text)
    }
    
    private func doLoginCheckWith(pin: String?) {
        passwordDoesntMatch.isHidden = true
        
        //Reset old access token
        User.shared.accessToken = nil
        
        NLoader.shared.startNLoader()
        
        var request = Pin.Login.Request()
        request.pinCode = pin
        
        interactor?.doLogin(request: request)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !codeTextField.isFirstResponder {
            codeTextField.becomeFirstResponder()
        }
    }
}

extension PinViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = textField.text!.replacingCharacters(in: Range(range, in: textField.text ?? "")!, with: string)
        
        selectDotWith(count: updatedText.count)
        
        passwordDoesntMatch.isHidden = true
        
        if updatedText.count <= 5 {
            
            if updatedText.count == 5 {
                if pinEntry == .Create {
                    router?.routeToReEnterPinScreenWith(pin: updatedText)
                } else if pinEntry == .ReEnter {
                    if createdPin != updatedText {
                        passwordDoesntMatch.isHidden = false
                    } else {
                        textField.text = updatedText
                        codeTextField.resignFirstResponder()
                        
                        pinCreationAndMatchingDoneLocally()
                    }
                } else {
                    textField.text = updatedText
                    codeTextField.resignFirstResponder()
                    
                    doLoginCheckWith(pin: updatedText)
                }
            }
            
            return true
        } else {
            if pinEntry == .ReEnter {
                passwordDoesntMatch.isHidden = false
            }
        }
        
        return false
    }
    
}
