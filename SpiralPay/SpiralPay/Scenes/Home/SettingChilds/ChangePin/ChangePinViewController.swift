//
//  ChangePinViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 02/04/18.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum ChangePinEntry {
    case Current
    case New
    case ReenterNew
}

protocol ChangePinDisplayLogic: class
{
    func changePinSuccess(response: ChangePin.ChangePin.Response)
    func changePinFailed(response: ChangePin.ChangePin.Response)
}

class ChangePinViewController: SpiralPayViewController, ChangePinDisplayLogic
{
    var interactor: ChangePinBusinessLogic?
    var router: (NSObjectProtocol & ChangePinRoutingLogic & ChangePinDataPassing)?
    
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
        let interactor = ChangePinInteractor()
        let presenter = ChangePinPresenter()
        let router = ChangePinRouter()
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
    
    //MARK:- Variables
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var pins: [UIButton]!
    
    var changePinEntry: ChangePinEntry = .Current
    var createdPin: String?
    var currentPin: String?
    var newPin: String?
    
    let pinDoesntMatchText = "PIN code doesn't match"
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        codeTextField.becomeFirstResponder()
    }
    
    //MARK:- APIs
    //MARK: Change Pin
    
    private func changePIN() {
        var request = ChangePin.ChangePin.Request()
        request.currentPin = currentPin
        request.newPin = newPin
        
        NLoader.shared.startNLoader()
        interactor?.changePin(request: request)
    }
    
    func changePinSuccess(response: ChangePin.ChangePin.Response) {
        NLoader.shared.stopNLoader()
        User.shared.save(pin: newPin ?? "")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func changePinFailed(response: ChangePin.ChangePin.Response) {
        NLoader.shared.stopNLoader()
        
        var vcs = self.navigationController?.viewControllers
        vcs?.removeLast()
        vcs?.removeLast()
        if let previousVC = vcs?.last as? ChangePinViewController {
            previousVC.errorLabel.isHidden = false
            previousVC.resetUI()
        }
        if let vcs = vcs {
            self.navigationController?.setViewControllers(vcs, animated: true)
        }
    }
    
    //MARK:- IBAction methods
    
    @IBAction func backButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK:- Private methods
    
    private func initialSetup() {
        
        if changePinEntry == .Current {
            headingLabel.text = "Enter Current PIN Code"
        } else if changePinEntry == .New {
            headingLabel.text = "Enter New PIN Code"
        } else if changePinEntry == .ReenterNew {
            headingLabel.text = "Re-enter New PIN Code"
        }
    }
    
    private func selectDotWith(count: Int) {
        var pinCount = 1
        for pin in pins {
            pin.isSelected = pinCount <= count
            pinCount = pinCount + 1
        }
    }
    
    func resetUI() {
        selectDotWith(count: 0)
        codeTextField.text = ""
        codeTextField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !codeTextField.isFirstResponder {
            codeTextField.becomeFirstResponder()
        }
    }
}

extension ChangePinViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = textField.text!.replacingCharacters(in: Range(range, in: textField.text ?? "")!, with: string)
        
        selectDotWith(count: updatedText.count)
        
        errorLabel.isHidden = true
        
        if updatedText.count <= 5 {
            
            if updatedText.count == 5 {
                if changePinEntry == .Current {
                    router?.routeToEnterNewPinScreenWith(currentPin: updatedText)
                } else if changePinEntry == .New {
                    router?.routeToReEnterNewPinScreenWith(currentPin: currentPin ?? "", newPin: updatedText)
                } else if changePinEntry == .ReenterNew {
                    if updatedText == newPin {
                        textField.text = updatedText
                        codeTextField.resignFirstResponder()
                        newPin = updatedText
                        
                        changePIN()
                    } else {
                        errorLabel.text = pinDoesntMatchText
                        errorLabel.isHidden = false
                    }
                }
            }
            
            return true
        }
        
        return false
    }
    
}
