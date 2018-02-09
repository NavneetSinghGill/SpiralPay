//
//  DateAndTimeViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 09/02/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

protocol DateAndTimeDelegate {
    func getFinal(date: Date)
}

class DateAndTimeViewController: SpiralPayViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var dateAndTimeDelegate: DateAndTimeDelegate?
    
    var initialDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.maximumDate = Date()

        if initialDate != nil {
            datePicker.date = initialDate!
        }
    }
    
    @IBAction func cancelButtonTapped() {
        closeTheScreen()
    }
    
    @IBAction func doneButtonTapped() {
        dateAndTimeDelegate?.getFinal(date: datePicker.date)
        closeTheScreen()
    }
    
    func closeTheScreen() {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

}
