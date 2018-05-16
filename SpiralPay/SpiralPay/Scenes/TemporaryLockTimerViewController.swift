//
//  TemporaryLockTimerViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 18/05/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class TemporaryLockTimerViewController: SpiralPayViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    var timer: Timer?
    var lockDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
        resumeTimer()
    }
    
    //MARK:- Private methods
    
    func initialSetup() {
        let intervalString = UserDefaults.standard.string(forKey: Constants.kLockTime) ?? "0"
        lockDate = Date(timeIntervalSince1970: TimeInterval(intervalString)!)
    }
    
    func resumeTimer() {
        self.updateLabel()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.updateLabel()
        })
    }
    
    func updateLabel() {
        let difference = Calendar.current.dateComponents([.minute, .second], from: lockDate!, to: Date())
        if difference.minute! >= Constants.lockTime {
            UserDefaults.standard.set(false, forKey: Constants.kIsLockedTemporarily)
            UserDefaults.standard.set(nil, forKey: Constants.kLockTime)
            UserDefaults.standard.synchronize()
            
            if let loginVC = self.navigationController?.viewControllers.first as? PinViewController, loginVC.pinEntry == .Login {
                loginVC.resetPinRetries()
            }
            
            self.navigationController?.popToRootViewController(animated: true)
            timer?.invalidate()
            timer = nil
        } else {
            var seconds = "\(60 - difference.second! - 1)"
            if seconds.count == 1 {
                seconds = "0\(seconds)"
            }
            timerLabel.text = "\(Constants.lockTime - difference.minute! - 1):\(seconds)"
        }
    }

}
