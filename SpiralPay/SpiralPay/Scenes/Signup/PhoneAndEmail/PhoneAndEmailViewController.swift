//
//  PhoneAndEmailViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 29/01/18.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol PhoneAndEmailDisplayLogic: class
{
  func displaySomething(viewModel: PhoneAndEmail.Something.ViewModel)
}

class PhoneAndEmailViewController: ProgressBarViewController, PhoneAndEmailDisplayLogic
{
  var interactor: PhoneAndEmailBusinessLogic?
  var router: (NSObjectProtocol & PhoneAndEmailRoutingLogic & PhoneAndEmailDataPassing)?

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
    let interactor = PhoneAndEmailInteractor()
    let presenter = PhoneAndEmailPresenter()
    let router = PhoneAndEmailRouter()
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
    percentageOfProgressBar = CGFloat(1/numberOfProgressBarPages)
    super.viewDidLoad()
    initialSetup()
    doSomething()
  }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
  
  // MARK: Do something
    
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var countryCodeTextField: FloatingHeaderTextField!
    @IBOutlet weak var mobileNumberTextField: FloatingHeaderTextField!
    @IBOutlet weak var emailAddressTextField: FloatingHeaderTextField!
    @IBOutlet weak var nextButton: SpiralPayButton!
    
    var countryName: String?
    var countryCode: String?
  
  func doSomething()
  {
    let request = PhoneAndEmail.Something.Request()
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: PhoneAndEmail.Something.ViewModel)
  {
    //nameTextField.text = viewModel.name
  }
    
    //MARK:- IBAction methods
    
    @IBAction func nextButtonTapped(button: UIButton) {
        User.shared.countryName = countryName
        User.shared.countryCode = countryCode
        User.shared.phone = mobileNumberTextField.text
        User.shared.email = emailAddressTextField.text
        router?.routeToCreatePin()
    }
    
    @IBAction func countryButtonTapped(button: UIButton) {
        router?.routeToCountrySelection()
    }
    
    //MARK:- Private methods
    
    func initialSetup() {
        let dropDownArrowImage = UIImage(named: "dropDownArrow")
        let dropDownArrowImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        dropDownArrowImageView.image = dropDownArrowImage
        dropDownArrowImageView.contentMode = .center
        countryCodeTextField.rightView = dropDownArrowImageView
        countryCodeTextField.rightViewMode = .always
        
        countryName = "United Kingdom"
        countryCode = "44"
    }
    
    func checkIfEntriesValid() -> Bool {
        var message = ""
        
        if !emailAddressTextField.isValidEmail() {
            message = "Please enter a valid email address."
        }
        if !mobileNumberTextField.isValidPhoneNumber() {
            message = "Please enter a valid mobile number."
        }
        
        nextButton.isSelected = message.isEmpty
        return !message.isEmpty
    }
    
}

extension PhoneAndEmailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nextButton.isSelected = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        _ = self.checkIfEntriesValid()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mobileNumberTextField {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            if updatedText.count > 10 {
                return false
            }
        }
        
        return true
        
    }
}

extension PhoneAndEmailViewController: CountrySelectionDelegate {
    
    func performActionWith(countryName: String, countryCode: String) {
        self.countryName = countryName
        self.countryCode = countryCode
        
        countryCodeLabel.text = "+\(countryCode)"
    }
    
}
