//
//  SettingsViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 20/02/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class SettingsViewController: SpiralPayViewController {
    
    var headers: Array<String> = ["ACCOUNT", "OTHER"]
    var options: Array<Array<String>> = [
        ["Card", "Personal details", "Change PIN", "Lock account", "Enable Touch Point"],
        ["Help", "Contact us", "Logout"]]
    var optionImages: Array<Array<UIImage?>> = [
        [UIImage(named: "settingCard"),
         UIImage(named: "settingPersonalInfo"),
         UIImage(named: "settingChangePin"),
         UIImage(named: "settingLockAccount"),
         UIImage(named: "settingEnableTouch")],
        [UIImage(named: "settingHelp"),
         UIImage(named: "settingContact"),
         UIImage(named: "settingLogout")]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()


    }

}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options[section].count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath)
            if let headerLabel = cell.contentView.viewWithTag(101) as? UILabel {
                headerLabel.text = headers[indexPath.section]
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "option", for: indexPath)
            if let optionLabel = cell.contentView.viewWithTag(103) as? UILabel {
                optionLabel.text = options[indexPath.section][indexPath.row - 1]
            }
            if let optionImageView = cell.contentView.viewWithTag(102) as? UIImageView {
                optionImageView.image = optionImages[indexPath.section][indexPath.row - 1]
            }
            
            guard  let optionSwitch = cell.contentView.viewWithTag(104) as? UISwitch else {
                return cell
            }
            if indexPath.section == 0 && indexPath.row == 5 {
                optionSwitch.isHidden = false
                cell.accessoryType = .none
            } else {
                optionSwitch.isHidden = true
                cell.accessoryType = .disclosureIndicator
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 56
        } else {
            return 44
        }
    }
    
}
