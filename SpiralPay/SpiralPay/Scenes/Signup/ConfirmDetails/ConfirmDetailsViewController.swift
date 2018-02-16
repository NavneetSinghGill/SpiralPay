//
//  ConfirmDetailsViewController.swift
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

protocol ConfirmDetailsDisplayLogic: class
{
    func displaySomething(viewModel: ConfirmDetails.Something.ViewModel)
}

class ConfirmDetailsViewController: ProgressBarViewController, ConfirmDetailsDisplayLogic
{
    var interactor: ConfirmDetailsBusinessLogic?
    var router: (NSObjectProtocol & ConfirmDetailsRoutingLogic & ConfirmDetailsDataPassing)?
    
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
        let interactor = ConfirmDetailsInteractor()
        let presenter = ConfirmDetailsPresenter()
        let router = ConfirmDetailsRouter()
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
        percentageOfProgressBar = CGFloat(7/numberOfProgressBarPages)
        
        super.viewDidLoad()
        
        initialSetup()
    }
    
    // MARK: Do something
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTextField: FloatingHeaderTextField!
    @IBOutlet weak var birthdayTextField: FloatingHeaderTextField!
    @IBOutlet weak var addressTextField: FloatingHeaderTextField!
    @IBOutlet weak var cityTextField: FloatingHeaderTextField!
    @IBOutlet weak var countryTextField: FloatingHeaderTextField!
    @IBOutlet weak var postCodeTextField: FloatingHeaderTextField!
    @IBOutlet weak var emailAddressTextField: FloatingHeaderTextField!
    @IBOutlet weak var countryCodeTextField: FloatingHeaderTextField!
    @IBOutlet weak var phoneTextField: FloatingHeaderTextField!
    @IBOutlet weak var confirmButton: SpiralPayButton!
    
    final let dateFormatString = "dd/MM/yyyy"
    
    func doSomething()
    {
        let request = ConfirmDetails.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: ConfirmDetails.Something.ViewModel)
    {

    }
    
    //MARK:- IBAction methods
    
    @IBAction func birthdayButtonTapped() {
        router?.routeToShowDateAndTimeScreen()
    }
    
    @IBAction func confirmButtonTapped() {
        
        User.shared.savedState = SavedState.CustomerDetailsEntered
        User.shared.name = nameTextField.text
        User.shared.birthday = birthdayTextField.text
        User.shared.address = addressTextField.text
        User.shared.city = cityTextField.text
        User.shared.postcode = postCodeTextField.text
        
        User.shared.save()
        
        router?.routeToWelcomeScreen()
    }
    
    @IBAction func termsButtonTapped() {
        
    }
    
    //MARK:- Private methods
    
    func initialSetup() {
        addKeyboardObservers()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ConfirmDetailsViewController.dismissKeyboard))
        scrollView.addGestureRecognizer(tapGesture)
        
        countryTextField.text = User.shared.countryName
        emailAddressTextField.text = User.shared.email
        countryCodeTextField.text = "+\(User.shared.countryCode ?? "")"
        phoneTextField.text = User.shared.phone
    }
    
    override func keyboardWillShow(keyboardFrame: CGRect) {
        scrollViewBottomConstraint.constant = keyboardFrame.size.height
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func keyboardWillHide(keyboardFrame: CGRect) {
        scrollViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func checkIfEntriesValid() -> Bool {
        var message = ""
        
        if !emailAddressTextField.isValidEmail() {
            message = "Please enter a valid email address."
        }
        if !birthdayTextField.isBirthdayIn(format: "DD/MM/YYYY") {
            message = "Please enter a valid birthday."
        }
        
        confirmButton.isSelected = message.isEmpty
        return !message.isEmpty
    }
    
}

extension ConfirmDetailsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        _ = self.checkIfEntriesValid()
        if textField == nameTextField {
            addressTextField.becomeFirstResponder()
        } else if textField == addressTextField {
            cityTextField.becomeFirstResponder()
        } else if textField == cityTextField {
            countryTextField.becomeFirstResponder()
        } else if textField == countryTextField {
            postCodeTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        confirmButton.isSelected = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        _ = self.checkIfEntriesValid()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.scrollView.scrollRectToVisible(textField.frame, animated: true)
        
        return true
    }
    
}

extension ConfirmDetailsViewController: DateAndTimeDelegate {
    
    func getFinal(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatString
        birthdayTextField.text = dateFormatter.string(from: date)
    }
    
}
