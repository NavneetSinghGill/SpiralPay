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
        ["Card", "Personal details", "Verify yourself", "Change PIN", "Enable Touch ID"],
        ["Help", "Contact us"]]
    var optionImages: Array<Array<UIImage?>> = [
        [UIImage(named: "settingCard"),
         UIImage(named: "settingPersonalInfo"),
         UIImage(named: "settingVerify"),
         UIImage(named: "settingChangePin"),
         UIImage(named: "settingEnableTouch")],
        [UIImage(named: "settingHelp"),
         UIImage(named: "settingContact")]
    ]
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //This will restore User data in case its changed in any of the settings flow
        User.shared.restore()
        
        tableView.reloadData()
    }
    
    //MARK:- Private methods
    
    private func openCardsListScreen() {
        DispatchQueue.main.async {
            let cardsListScreen = CardListViewController.create()
            self.parent?.navigationController?.pushViewController(cardsListScreen, animated: true)
        }
    }
    
    private func openPersonalDetailsScreen() {
        DispatchQueue.main.async {
            let personalDetailsScreen = PersonalDetailsViewController.create()
            self.parent?.navigationController?.pushViewController(personalDetailsScreen, animated: true)
        }
    }
    
    private func openChangePinScreen() {
        DispatchQueue.main.async {
            let changePinScreen = ChangePinViewController.create()
            self.parent?.navigationController?.pushViewController(changePinScreen, animated: true)
        }
    }
    
    private func openLockAccountScreen() {
        DispatchQueue.main.async {
            let lockAccountScreen = LockAccountViewController.create()
            self.parent?.navigationController?.pushViewController(lockAccountScreen, animated: true)
        }
    }
    
    @IBAction func touchIDswitchValueChanged(touchSwitch: UISwitch) {
        UserDefaults.standard.set(touchSwitch.isOn, forKey: Constants.kIsFingerPrintEnabled)
        UserDefaults.standard.synchronize()
    }
    
    //MARK:- Overridden methods
    
    override func afterVixVerifySuccess() {
        self.navigationController?.popToRootViewController(animated: true)
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
                optionSwitch.isOn = UserDefaults.standard.bool(forKey: Constants.kIsFingerPrintEnabled)
                optionSwitch.isHidden = false
                cell.accessoryType = .none
            } else {
                optionSwitch.isHidden = true
                cell.accessoryType = .disclosureIndicator
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 1:
                openCardsListScreen()
            case 2:
                openPersonalDetailsScreen()
            case 3:
                routeToVixVerify()
            case 4:
                openChangePinScreen()
            default:
                return ()
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 1:
                return ()
            case 2:
                return ()
            default:
                return ()
            }
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
