//
//  PhoneVerificationViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 07/02/18.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//


/*

Flow of verification
 
 VC1 for sending sms
 VC2 for entering pin
 VC3 for success/failure


*/

import UIKit
import GIDSDK

enum PhoneVerificationScreenStatus {
    case SendSms
    case EnterPin
    case Success
    case Failed
}

protocol PhoneVerificationDisplayLogic: class
{
    func sendSmsForPhoneVerificationAPIsuccess(response: PhoneVerification.SmsPhoneVerification.Response)
    func sendSmsForPhoneVerificationAPIfailure(response: PhoneVerification.SmsPhoneVerification.Response)
    
    func updateMobileAndEmailSuccess(response: PhoneVerification.UpdateMobileAndEmail.Response)
    func updateMobileAndEmailFailure(response: PhoneVerification.UpdateMobileAndEmail.Response)
    
    func updateCustomerVerificationDataSuccess(response: PhoneVerification.UpdateCustomerVerificationData.Response)
    func updateCustomerVerificationDataFailure(response: PhoneVerification.UpdateCustomerVerificationData.Response)
}

class PhoneVerificationViewController: ProgressBarViewController, PhoneVerificationDisplayLogic
{
  var interactor: PhoneVerificationBusinessLogic?
  var router: (NSObjectProtocol & PhoneVerificationRoutingLogic & PhoneVerificationDataPassing)?

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
    let interactor = PhoneVerificationInteractor()
    let presenter = PhoneVerificationPresenter()
    let router = PhoneVerificationRouter()
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
    @IBOutlet weak var actionButton: SpiralPayButton!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var phoneStatusImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
    var screenStatus: PhoneVerificationScreenStatus = .SendSms
    var generatedCode: String?
    var screenType = AppFlowType.Onboard
    
    //Enter Pin
    @IBOutlet weak var enterPinView: UIView!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var enterPinPhoneNumberLabel: UILabel!
    @IBOutlet var pins: [UIButton]!
    
    // MARK:- View lifecycle
    
    override func viewDidLoad()
    {
        if screenType == .Onboard {
            if screenStatus == .SendSms {
                percentageOfProgressBar = CGFloat(4/numberOfProgressBarPages)
            } else if screenStatus == .EnterPin {
                percentageOfProgressBar = CGFloat(5/numberOfProgressBarPages)
            } else if screenStatus == .Success {
                percentageOfProgressBar = CGFloat(6/numberOfProgressBarPages)
            } else if screenStatus == .Failed {
                percentageOfProgressBar = CGFloat(6/numberOfProgressBarPages)
            }
        } else {
            progressBar.isHidden = true
        }
        
        super.viewDidLoad()
        
        initialSetup()
    }
    
    //MARK:- API response delegates
    
    func sendSmsForPhoneVerificationAPIsuccess(response: PhoneVerification.SmsPhoneVerification.Response) {
        NLoader.stopAnimating()
        
        if screenStatus != .EnterPin {
            router?.routeToEnterSmsPinScreen()
        }
    }
    
    func sendSmsForPhoneVerificationAPIfailure(response: PhoneVerification.SmsPhoneVerification.Response) {
        NLoader.stopAnimating()
    }
    
    //MARK: update mobile and email
    
    func updateMobileAndEmailSuccess(response: PhoneVerification.UpdateMobileAndEmail.Response) {
        NLoader.stopAnimating()
        User.shared.save()
        router?.routeToSuccessFulVerificationScreen()
    }
    
    func updateMobileAndEmailFailure(response: PhoneVerification.UpdateMobileAndEmail.Response) {
        NLoader.stopAnimating()
        router?.routeToFailedVerificationScreen()
    }
    
    //MARK: Update customer verification data
    
    func sendCustomerVerificationData(status: String, verificationID: String) {
        //This can be a silent api
        
        var request = PhoneVerification.UpdateCustomerVerificationData.Request()
        request.status = status
        request.verificationID = verificationID
        
//        NLoader.startAnimating()
        interactor?.updateCustomerVerificationData(request: request)
    }
    
    func updateCustomerVerificationDataSuccess(response: PhoneVerification.UpdateCustomerVerificationData.Response) {
//        NLoader.stopAnimating()
    }
    
    func updateCustomerVerificationDataFailure(response: PhoneVerification.UpdateCustomerVerificationData.Response) {
//        NLoader.stopAnimating()
    }
    
    //MARK:- IBAction methods
    
    @IBAction func actionButtonTapped() {
        if screenStatus == .SendSms {
            sendaRandomCodeToUser()
        } else if screenStatus == .Success {
            if screenType == .Onboard {
                User.shared.savedState = .PhoneVerified
                User.shared.save()
                //TODO: Correct flow after success?
//                router?.routeToConfirmDetailsScreen()
                routeToVixVerify()
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else if screenStatus == .Failed {
            if screenType == .Onboard {
                router?.routeToFirstPhoneVerificationScreen()
            } else {
                router?.routeToChangeEmailScreen()
            }
        }
    }
    
    @IBAction func backButtonTapped() {
        if screenStatus == .SendSms || screenStatus == .Failed{
            if screenType == .Onboard {
                User.shared.reset()
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func resendCode() {
        sendaRandomCodeToUser()
    }
    
    //MARK:- Private methods
    
    private func initialSetup() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        phoneNumberLabel.text = User.shared.phoneWithCode
        actionButton.isSelected = true
        
        if screenStatus == .SendSms {
            phoneStatusImageView.image = UIImage(named: "phoneConnect")
            actionButton.setTitle("Send", for: .selected)
            actionButton.setTitle("Send", for: .normal)
            backButton.isHidden = false
            
            headingLabel.text = "Verify your phone"
            infoLabel.text = "We are going to send a verification code to"
            phoneNumberLabel.isHidden = false
        } else if screenStatus == .EnterPin {
            enterPinPhoneNumberLabel.text = User.shared.phoneWithCode
            enterPinView.isHidden = false
            codeTextField.becomeFirstResponder()
            backButton.isHidden = true
        } else if screenStatus == .Success {
            phoneStatusImageView.image = UIImage(named: "phoneVerified")
            actionButton.setTitle("Continue", for: .selected)
            actionButton.setTitle("Continue", for: .normal)
            backButton.isHidden = true
            
            headingLabel.text = "We verified your phone"
            infoLabel.text = "To setup your app Please tap continue"
            phoneNumberLabel.isHidden = true
        } else if screenStatus == .Failed {
            phoneStatusImageView.image = UIImage(named: "phoneVerifyFailed")
            actionButton.setTitle("Try again", for: .selected)
            actionButton.setTitle("Try again", for: .normal)
            backButton.isHidden = false
            progressBar.isHidden = true
            
            headingLabel.text = "Unfortunately we are unable\nto verify your phone"
            infoLabel.text = "Please check the following number is correct and try again"
            phoneNumberLabel.isHidden = false
        }
    }
    
    private func sendaRandomCodeToUser() {
        NLoader.stopAnimating()
        
        //6-digit code
        generatedCode = "\(arc4random_uniform(899999) + 100000)"
        print("Genegrated code: \(generatedCode!)")
        
        var request = PhoneVerification.SmsPhoneVerification.Request()
        request.phone = User.shared.phoneWithCode
        request.code = generatedCode!
        
        interactor?.sendSmsForPhoneVerification(request: request)
    }
    
    private func selectDotWith(count: Int) {
        var pinCount = 1
        for pin in pins {
            pin.isSelected = pinCount <= count
            pinCount = pinCount + 1
        }
    }
    
    private func codeMatchingSuccessful() {
        if screenType == .Onboard {
            router?.routeToSuccessFulVerificationScreen()
        } else {
            let request = PhoneVerification.UpdateMobileAndEmail.Request()
            NLoader.startAnimating()
            interactor?.updateMobileAndEmail(request: request)
        }
    }
    
    private func codeMatchingFailed() {
        router?.routeToFailedVerificationScreen()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !codeTextField.isFirstResponder && screenStatus == .EnterPin {
            codeTextField.becomeFirstResponder()
        }
    }
    
    func routeToVixVerify() {
        let main = Utils.shared.getVixVerifyControllerWith(delegate: self)
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(main, animated: true)
        }
    }
    
    func getVerificationResult() {
        let is_SoapMessage: String = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cgs=\"http://uat1.vixverify.com/\"><soapenv:Header/><soapenv:Body><cgs:getVerificationResult/></soapenv:Body></soapenv:Envelope>"
        
        let is_URL: String = "https://uat1.vixverify.com/Registrations-Registrations/DynamicFormsServiceV3?wsdl"
        
        var lobj_Request = URLRequest(url: URL(string: is_URL)!)
        let session = URLSession.shared
        
        lobj_Request.httpMethod = "POST"
        lobj_Request.httpBody = is_SoapMessage.data(using: .utf8)
        lobj_Request.addValue("uat1.vixverify.com", forHTTPHeaderField: "Host")
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        lobj_Request.addValue(String(is_SoapMessage.count), forHTTPHeaderField: "Content-Length")
        //lobj_Request.addValue("223", forHTTPHeaderField: "Content-Length")
        lobj_Request.addValue("", forHTTPHeaderField: "SOAPAction")
        
        let task = session.dataTask(with: lobj_Request) { (data, response, error) in
//            print("Response: \(response)")
            if let data = data {
                let strData = String(data: data, encoding: .utf8)
                print("Body: \(strData ?? "")")
                
                if error != nil
                {
                    print("Error: " + error!.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    func saveCustomerDetailsWith(getVerificationResultResponse: GetVerificationResultResponse?) {
        if let gVRResponse = getVerificationResultResponse {
            Utils.shared.saveCustomerDetailsWith(getVerificationResultResponse: gVRResponse)
            
            //Move to Welcome screen
            DispatchQueue.main.async {
                let welcomeScreen: WelcomeViewController = WelcomeViewController.create()
                self.navigationController?.setViewControllers([welcomeScreen], animated: true)
            }
        }
    }
    
}

extension PhoneVerificationViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if screenStatus == .EnterPin {
            let updatedText = textField.text!.replacingCharacters(in: Range(range, in: textField.text ?? "")!, with: string)
            
            selectDotWith(count: updatedText.count)
            
            if updatedText.count <= pins.count {
                
                if updatedText.count == pins.count {
                    if generatedCode != updatedText {
                        codeMatchingFailed()
                    } else {
                        codeMatchingSuccessful()
                    }
                }
                return true
            }
            return false
        }
        
        return true
    }
    
}

extension PhoneVerificationViewController: GIDDelegate, GIDLoggerDelegate {
    
    func mainViewController(_ mainViewController: GIDMainViewController, didCompleteProcessWithPayload payload: [AnyHashable : Any]?, resultCode: GIDResultCode, error: GIDErrorProtocol?) {
        
        if resultCode == .error {
            // An error occured
        } else if resultCode == .noNetwork {
            // There is no network connection
        } else if resultCode == .success {
            // Succesfully completed the process
            
            //verificationToken
            //verificationState - PENDING, IN_PROGRESS

            let getVerificationResult = GetVerificationResult()
            getVerificationResult.accountId = Secret.accountID
            getVerificationResult.password = Secret.password
            if let payload = payload {
                if let token = payload["verificationToken"] as? String {
                    getVerificationResult.verificationToken = token
                }
                if let verificationId = payload["verificationId"] as? String {
                    getVerificationResult.verificationId = verificationId
                }
            }
            
            Utils.shared.getVerificationResult(getVerificationResult: getVerificationResult, completionBlock: { (getVerificationResultResponse) -> (Void) in
                
                self.saveCustomerDetailsWith(getVerificationResultResponse: getVerificationResultResponse)
            })
            
            
        } else if resultCode == .cancelled {
            // User opted out of the process
        } else if resultCode == .back {
            // User tapped the back button
        } else if (resultCode == .userInactivity) {
            // User Inactivity
        } else if (resultCode == .resourceBundle) {
            // No Resource Bundle
        }
        
        if resultCode != .success {
            self.navigationController!.popViewController(animated: true)
        } else {
            
        }
    }
    
    func sdkDidLogLevel(_ levelString: String!, levelCode level: GIDLogLevel, analyticsCode: GIDAnalyticsCode, source: String!, message: String!) {
        if (level == .UI) {
            print("Got analytics info from SDK: %ld %s", analyticsCode, message);
        } else {
            print("LOG:" + message);
        }
    }
    
}

