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

enum PickerType {
    case DateMonthYear
    case MonthYear
}

class DateAndTimeViewController: SpiralPayViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateYearPicker: MonthYearPickerView!
    var dateAndTimeDelegate: DateAndTimeDelegate?
    var pickerType: PickerType = .DateMonthYear
    var initialDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch pickerType {
        case .DateMonthYear:
            datePicker.isHidden = false
            dateYearPicker.isHidden = true
            
            if initialDate != nil {
                datePicker.date = initialDate!
            }
            datePicker.maximumDate = Date()
            
        case .MonthYear:
            datePicker.isHidden = true
            dateYearPicker.isHidden = false
        }
    }
    
    @IBAction func cancelButtonTapped() {
        closeTheScreen()
    }
    
    @IBAction func doneButtonTapped() {
        switch pickerType {
        case .DateMonthYear:
            dateAndTimeDelegate?.getFinal(date: datePicker.date)
        case .MonthYear:
            dateAndTimeDelegate?.getFinal(date: dateYearPicker.date)
        }
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
