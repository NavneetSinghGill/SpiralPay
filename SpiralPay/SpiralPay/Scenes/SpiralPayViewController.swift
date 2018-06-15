//
//  SpiralPayViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 02/02/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit
import CoreData
import GIDSDK

class SpiralPayViewController: UIViewController {
    
    var badge: Int? {
        didSet {
            if (badge ?? 0) > 0 {
                badgeLabel?.isHidden = false
            } else {
                badgeLabel?.isHidden = true
            }
            if (badge ?? 0) > 9 {
                badgeLabel?.text = "+"
            } else {
                badgeLabel?.text = "\(badge ?? 0)"
            }
        }
    }
    var badgeLabel: UILabel?
    var cartView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if badgeLabel != nil {
            let combinedItems = fetchCombinedItems()
            
            badge = combinedItems.count
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AppUtility.lockOrientation(.all)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(SpiralPayViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SpiralPayViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardWillShow(keyboardFrame: keyboardSize)
        }
        
    }
    
    func keyboardWillShow(keyboardFrame: CGRect) {
        
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardWillHide(keyboardFrame: keyboardSize)
        }
    }
    
    func keyboardWillHide(keyboardFrame: CGRect) {
        
    }
    
    //MARK: Cart
    
    func addCartIcon(parentView: UIView) {
        let pixelsToBeShiftedBy: CGFloat = 5
        cartView = UIView(frame: CGRect(x: self.view.frame.size.width - 50, y: (self.view == parentView) ? 25 : 5, width: 35 + pixelsToBeShiftedBy, height: 40))
        let cartButton = UIButton(frame: CGRect(x: 0, y: 0, width: cartView!.frame.size.width, height: cartView!.frame.size.height))
        cartButton.setImage(UIImage(named: "cart"), for: .normal)
        cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        cartButton.imageEdgeInsets = UIEdgeInsetsMake(0, -pixelsToBeShiftedBy, 0, 0)
        cartView!.addSubview(cartButton)
        
        let badgeWidth: CGFloat = 16
        badgeLabel = UILabel(frame: CGRect(x: cartView!.frame.size.width - badgeWidth - pixelsToBeShiftedBy, y: 0, width: badgeWidth, height: badgeWidth))
        badgeLabel!.backgroundColor = UIColor(red: 1, green: 211/255, blue: 93/255, alpha: 1)
        badgeLabel!.textAlignment = .center
        badgeLabel!.layer.cornerRadius = badgeWidth/2
        badgeLabel!.clipsToBounds = true
        badgeLabel!.textColor = UIColor.white
        badgeLabel?.font = UIFont(name: "Lato", size: 12)
        cartView!.addSubview(badgeLabel!)
        
        parentView.addSubview(cartView!)
    }
    
    @objc func cartButtonTapped() {
        if badge == 0 {
            return
        }
        let cartScreen = ShoppingCartViewController.create()
        if self.navigationController != nil {
            navigationController?.pushViewController(cartScreen, animated: true)
        } else {
            present(cartScreen, animated: true, completion: nil)
        }
    }
    
    //MARK:- Coredata methods
    
    func fetchCombinedItems() -> [CombinedItem] {
        
        Utils.shared.deleteDanglingDataIn(context: ApplicationDelegate.mainContext)
        
        return Utils.shared.getCombinedItemsIn(context: ApplicationDelegate.mainContext)
    }
    
    //MARK:- Vix verify
    
    
    
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
            //            Utils.print(object: ("Response: \(response)"))
            if let data = data {
                let strData = String(data: data, encoding: .utf8)
                Utils.print(object: ("Body: \(strData ?? "")"))
                
                if error != nil
                {
                    Utils.print(object: ("Error: " + error!.localizedDescription))
                }
            }
        }
        task.resume()
    }
    
    func saveCustomerDetailsWith(getVerificationResultResponse: GetVerificationResultResponse) {
        Utils.shared.saveCustomerDetailsWith(getVerificationResultResponse: getVerificationResultResponse)
        
        //Move to Welcome screen
        DispatchQueue.main.async {
            self.afterVixVerifySuccess(status: VerificationStatus.getStatus(string: getVerificationResultResponse.return_?.verificationResult?.overallVerificationStatus ?? ""))
        }
    }
    
    //MARK: Possibly overridden in derived controllers
    func afterVixVerifySuccess(status: VerificationStatus) { }
    func vixVerifyNotNow() { }

}

extension SpiralPayViewController: GIDDelegate, GIDLoggerDelegate {
    
    func mainViewController(_ mainViewController: GIDMainViewController, didCompleteProcessWithPayload payload: [AnyHashable : Any]?, resultCode: GIDResultCode, error: GIDErrorProtocol?) {
        
        if resultCode == .error {
            // An error occured
        } else if resultCode == .noNetwork {
            // There is no network connection
        } else if resultCode == .success {
            // Succesfully completed the process
            
            VixVerify.shared.reset()
            VixVerify.shared.save()
            
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
            
            NLoader.startAnimating()
            Utils.shared.getVerificationResult(getVerificationResult: getVerificationResult, completionBlock: { (getVerificationResultResponse) -> (Void) in
                NLoader.stopAnimating()
                DispatchQueue.main.async {
                    self.saveCustomerDetailsWith(getVerificationResultResponse: getVerificationResultResponse)
                }
            })
            
            
        } else if resultCode == .cancelled {
            // User opted out of the process
        } else if resultCode == .back {
            // User tapped the back button
            vixVerifyNotNow()
        } else if (resultCode == .userInactivity) {
            // User Inactivity
        } else if (resultCode == .resourceBundle) {
            // No Resource Bundle
        }
        
        if resultCode != .success && resultCode != .back {
            self.navigationController!.popViewController(animated: true)
        } else {
            
        }
    }
    
    func sdkDidLogLevel(_ levelString: String!, levelCode level: GIDLogLevel, analyticsCode: GIDAnalyticsCode, source: String!, message: String!) {
        if (level == .UI) {
            Utils.print(object: ("Got analytics info from SDK: %ld %s", analyticsCode, message))
        } else {
            Utils.print(object: ("LOG:" + message))
        }
    }
    
}
